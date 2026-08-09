/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pmove.c — Parallel Move Engine with NVMe MQ & PCIe Topology Awareness
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/file.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/workqueue.h>
#include <linux/completion.h>
#include <linux/cpumask.h>
#include <linux/blkdev.h>
#include <linux/blk-mq.h>
#include <linux/pci.h>
#include <linux/miscdevice.h>
#include <linux/namei.h>
#include <linux/splice.h>
#include <linux/atomic.h>
#include <linux/mutex.h>
#include <linux/sched.h>
#include <linux/delay.h>

#include "pmove.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maximilian Eric Alexander Rupplin von Keffikon");
MODULE_DESCRIPTION("Parallel Move (pmove) — NVMe Multi-Queue & PCIe Lane Aware");
MODULE_VERSION("1.0");

/* Intermediate Engine Operational Schemas */
struct pmove_batch_ctx;

struct pmove_work_item {
	struct work_struct work;
	struct pmove_batch_ctx *ctx;
	unsigned int idx;
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
	ssize_t payload_bytes;
	int status;
	struct completion signal;
};

struct pmove_batch_ctx {
	struct pmove_work_item *items;
	unsigned int total_files;
	unsigned int active_channels;
	unsigned int run_chunk_size;
	unsigned int runtime_flags;
	atomic_t metrics_processed;
	atomic_t metrics_failed;
	atomic64_t metrics_copied_bytes;
	struct workqueue_struct *private_wq;
	bool abort_triggered;
};

static struct {
	struct proc_dir_entry *proc_root;
	struct miscdevice misc_dev;
	struct mutex engine_lock;
	atomic_t runtime_active_ops;
	unsigned int global_chunk_override;
	unsigned int global_channel_override;
} pmove_state;

/* ===========================================================================
 * Hardware Detection Mechanics
 * ===========================================================================
 */

static unsigned int pmove_probe_queues(const char *path)
{
	struct path target_path;
	struct request_queue *q;
	unsigned int q_depth = 1;

	if (kern_path(path, LOOKUP_FOLLOW, &target_path) == 0) {
		if (target_path.dentry && target_path.dentry->d_inode &&
		    target_path.dentry->d_inode->i_sb &&
		    target_path.dentry->d_inode->i_sb->s_bdev) {
			q = bdev_get_queue(target_path.dentry->d_inode->i_sb->s_bdev);
			if (q)
				q_depth = q->nr_hw_queues;
		}
		path_put(&target_path);
	}
	return q_depth ? q_depth : 1;
}

static unsigned int pmove_probe_bandwidth(const char *path, unsigned int *gen, unsigned int *lanes)
{
	struct path target_path;
	struct block_device *bdev;
	struct pci_dev *pdev = NULL;
	u16 link_status;
	unsigned int raw_speed, width, raw_bw = 985; /* default baseline fallback */

	*gen = 0;
	*lanes = 0;

	if (kern_path(path, LOOKUP_FOLLOW, &target_path) != 0)
		return 0;

	if (!target_path.dentry || !target_path.dentry->d_inode ||
	    !target_path.dentry->d_inode->i_sb || !target_path.dentry->d_inode->i_sb->s_bdev) {
		path_put(&target_path);
		return 0;
	}

	bdev = target_path.dentry->d_inode->i_sb->s_bdev;
	if (bdev->bd_disk && bdev->bd_disk->driverfs_dev) {
		struct device *d_node = bdev->bd_disk->driverfs_dev;
		while (d_node && !dev_is_pci(d_node))
			d_node = d_node->parent;
		if (d_node && dev_is_pci(d_node))
			pdev = to_pci_dev(d_node);
	}
	path_put(&target_path);

	if (!pdev)
		return 0;

	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &link_status);
	raw_speed = link_status & PCI_EXP_LNKSTA_CLS;
	width = (link_status & PCI_EXP_LNKSTA_NLW) >> 4;

	switch (raw_speed) {
	case 1: *gen = 1; raw_bw = 250; break;
	case 2: *gen = 2; raw_bw = 500; break;
	case 3: *gen = 3; raw_bw = 985; break;
	case 4: *gen = 4; raw_bw = 1969; break;
	case 5: *gen = 5; raw_bw = 3938; break;
	default: *gen = 3; raw_bw = 985; break;
	}

	*lanes = width;
	return raw_bw * width;
}

static void pmove_harvest_telemetry(const char *path, struct pmove_hw_telemetry *tel)
{
	unsigned int g = 0, l = 0;

	memset(tel, 0, sizeof(*tel));
	tel->online_cpus = num_online_cpus();
	tel->nr_hw_queues = pmove_probe_queues(path);
	tel->estimated_bw_mb_s = pmove_probe_bandwidth(path, &g, &l);
	tel->pcie_gen = g;
	tel->pcie_lanes = l;
	tel->is_nvme = (tel->nr_hw_queues > 2) ? 1 : 0;

	/* Dynamic topology calculation logic */
	tel->optimal_channels = min3(tel->online_cpus, tel->nr_hw_queues, (unsigned int)PMOVE_MAX_CHANNELS);
	if (tel->estimated_bw_mb_s >= 5000)
		tel->calculated_chunk_size = 16 * 1024 * 1024;
	else if (tel->estimated_bw_mb_s >= 2000)
		tel->calculated_chunk_size = 8 * 1024 * 1024;
	else
		tel->calculated_chunk_size = PMOVE_CHUNK_DEFAULT;

	if (tel->nr_hw_queues <= 2)
		tel->calculated_chunk_size = min(tel->calculated_chunk_size, (unsigned int)(2 * 1024 * 1024));
}

/* ===========================================================================
 * Core Processing fallbacks & Relocations
 * ===========================================================================
 */

static ssize_t pmove_fallback_copy_loop(const char *src, const char *dst, unsigned int chunk, unsigned int flags)
{
	struct file *f_in = NULL, *f_out = NULL;
	struct path dst_path;
	struct iattr target_attr;
	loff_t pos_in = 0, pos_out = 0, size_in;
	ssize_t global_transferred = 0, delta = 0;
	int creation_flags = O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE;

	f_in = filp_open(src, O_RDONLY | O_LARGEFILE, 0);
	if (IS_ERR(f_in))
		return PTR_ERR(f_in);

	size_in = i_size_read(file_inode(f_in));
	if (!(flags & PMOVE_F_OVERWRITE))
		creation_flags |= O_EXCL;

	f_out = filp_open(dst, creation_flags, 0644);
	if (IS_ERR(f_out)) {
		filp_close(f_in, NULL);
		return PTR_ERR(f_out);
	}

	while (pos_in < size_in) {
		size_t processing_len = min_t(loff_t, chunk, size_in - pos_in);
		delta = do_splice_direct(f_in, &pos_in, f_out, &pos_out, processing_len, SPLICE_F_MOVE);
		if (delta <= 0) {
			if (delta == 0) break;
			global_transferred = delta;
			goto closure;
		}
		global_transferred += delta;
		cond_resched();
	}

	if (flags & PMOVE_F_SYNC) {
		int sync_err = vfs_fsync(f_out, 0);
		if (sync_err < 0) {
			global_transferred = sync_err;
			goto closure;
		}
	}

	if (flags & PMOVE_F_PRESERVE) {
		struct inode *inode_src = file_inode(f_in);
		memset(&target_attr, 0, sizeof(target_attr));
		target_attr.ia_valid = ATTR_MODE | ATTR_ATIME | ATTR_MTIME;
		target_attr.ia_mode = inode_src->i_mode;
		target_attr.ia_atime = inode_src->i_atime;
		target_attr.ia_mtime = inode_src->i_mtime;

		if (kern_path(dst, LOOKUP_FOLLOW, &dst_path) == 0) {
			notify_change(&init_user_ns, dst_path.dentry, &target_attr, NULL);
			path_put(&dst_path);
		}
	}

closure:
	filp_close(f_out, NULL);
	filp_close(f_in, NULL);
	return global_transferred;
}

static int pmove_process_displacement(struct pmove_work_item *item)
{
	struct filename *fn_src;
	struct filename *fn_dst;
	int structural_status;

	if (!(item->ctx->runtime_flags & PMOVE_F_FORCE_COPY)) {
		fn_src = getname_kernel(item->src_path);
		if (!IS_ERR(fn_src)) {
			fn_dst = getname_kernel(item->dst_path);
			if (!IS_ERR(fn_dst)) {
				/* Leverage filesystem level descriptor shifting across standard endpoints */
				structural_status = do_renameat2(AT_FDCWD, fn_src, AT_FDCWD, fn_dst, 0);
				putname(fn_dst);
				putname(fn_src);

				if (structural_status != -EXDEV) {
					item->payload_bytes = 0; /* Handled via inode reference swap */
					return structural_status;
				}
			} else {
				putname(fn_src);
			}
		}
	}

	/* Cross-device boundary detected: falling back to zero-copy data migration loop */
	item->payload_bytes = pmove_fallback_copy_loop(item->src_path, item->dst_path,
	                                               item->ctx->run_chunk_size, item->ctx->runtime_flags);
	if (item->payload_bytes < 0)
		return (int)item->payload_bytes;

	/* Data transmission successful, scrubbing source descriptor */
	fn_src = getname_kernel(item->src_path);
	if (IS_ERR(fn_src))
		return PTR_ERR(fn_src);

	structural_status = do_unlinkat(AT_FDCWD, fn_src, 0);
	putname(fn_src);
	return structural_status;
}

static void pmove_execution_worker(struct work_struct *work)
{
	struct pmove_work_item *item = container_of(work, struct pmove_work_item, work);
	struct pmove_batch_ctx *ctx = item->ctx;

	if (ctx->abort_triggered) {
		item->status = -ECANCELED;
		goto escape;
	}

	item->status = pmove_process_displacement(item);

	if (item->status != 0) {
		atomic_inc(&ctx->metrics_failed);
		if (ctx->runtime_flags & PMOVE_F_VERBOSE)
			pr_warn("pmove: Failed item idx %u, path %s -> %s, err: %d\n", item->idx, item->src_path, item->dst_path, item->status);
	} else {
		if (item->payload_bytes > 0)
			atomic64_add(item->payload_bytes, &ctx->metrics_copied_bytes);
		atomic_inc(&ctx->metrics_processed);
	}

escape:
	complete(&item->signal);
}

/* ===========================================================================
 * Orchestrated Batch Lifecycle Pipeline
 * ===========================================================================
 */

static int pmove_dispatch_batch(struct pmove_batch_request __user *ureq)
{
	struct pmove_batch_request kreq;
	struct pmove_batch_ctx *ctx;
	struct pmove_file_pair current_pair;
	struct pmove_hw_telemetry active_tel;
	unsigned int loop_idx;
	int internal_rc = 0;

	if (copy_from_user(&kreq, ureq, sizeof(kreq)))
		return -EFAULT;
	if (kreq.nr_files == 0 || kreq.nr_files > PMOVE_MAX_FILES || !kreq.pairs)
		return -EINVAL;

	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
	if (!ctx)
		return -ENOMEM;

	ctx->items = kcalloc(kreq.nr_files, sizeof(struct pmove_work_item), GFP_KERNEL);
	if (!ctx->items) {
		kfree(ctx);
		return -ENOMEM;
	}

	ctx->total_files = kreq.nr_files;
	ctx->runtime_flags = kreq.flags;
	atomic_set(&ctx->metrics_processed, 0);
	atomic_set(&ctx->metrics_failed, 0);
	atomic64_set(&ctx->metrics_copied_bytes, 0);

	if (copy_from_user(&current_pair, &kreq.pairs[0], sizeof(current_pair))) {
