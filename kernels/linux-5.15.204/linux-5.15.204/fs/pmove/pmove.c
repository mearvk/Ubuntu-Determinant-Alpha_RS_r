/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pmove.c — Parallel Move Engine with Dynamic Lane & Channel Assignment
 *
 * Dedicated move engine with independent telemetry, abort capability,
 * and move-specific optimizations:
 *
 *   - Atomic rename fast path (same-fs: instant, zero data copy)
 *   - Splice fallback for cross-device moves
 *   - Dynamic channel assignment shared with pcopy module
 *   - CPU load awareness: reduces parallelism under system pressure
 *   - Device class speed constants: won't over-parallelize slow storage
 *
 * Move semantics:
 *   1. Try do_renameat2() — O(1) inode reference swap (same filesystem)
 *   2. If -EXDEV: splice copy + unlink source (cross-device boundary)
 *   3. PMOVE_F_FORCE_COPY: always use splice path (testing/benchmarks)
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
#include <linux/sched/loadavg.h>
#include <linux/delay.h>
#include <linux/kernel_stat.h>

#include "pmove.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maximilian Eric Alexander Rupplin von Keffikon");
MODULE_DESCRIPTION("Parallel Move (pmove) — Dynamic Lane & Channel Assignment");
MODULE_VERSION("2.0");

/* ===========================================================================
 * Internal Structures
 * ===========================================================================
 */

struct pmove_work_item {
	struct work_struct work;
	struct pmove_batch_ctx *ctx;
	unsigned int idx;
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
	ssize_t payload_bytes;
	int status;
	bool used_rename;              /* true if atomic rename succeeded */
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
	atomic_t metrics_renamed;      /* Atomic renames (instant) */
	atomic_t metrics_spliced;      /* Splice fallbacks (cross-device) */
	atomic64_t metrics_copied_bytes;
	struct workqueue_struct *private_wq;
	bool abort_triggered;
	struct pmove_dynamic_decision decision;
};

static struct {
	struct proc_dir_entry *proc_root;
	struct miscdevice misc_dev;
	struct mutex engine_lock;
	atomic_t runtime_active_ops;
	unsigned int global_chunk_override;
	unsigned int global_channel_override;

	/* Last decision for /proc */
	struct pmove_dynamic_decision last_decision;
	struct mutex decision_lock;
} pmove_state;

/* ===========================================================================
 * CPU Load Measurement (mirrors pcopy)
 * ===========================================================================
 */

static unsigned int pmove_get_cpu_load_pct(void)
{
	unsigned long avnrun[3];
	unsigned int online_cpus;
	unsigned int load_pct;

	get_avenrun(avnrun, FIXED_1 / 200, 0);
	online_cpus = num_online_cpus();

	if (online_cpus == 0)
		return 100;

	load_pct = (unsigned int)((avnrun[0] * 100) / (online_cpus * FIXED_1));
	return min(load_pct, (unsigned int)100);
}

/* ===========================================================================
 * Hardware Detection (mirrors pcopy)
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

static unsigned int pmove_probe_bandwidth(const char *path,
					  unsigned int *gen, unsigned int *lanes)
{
	struct path target_path;
	struct block_device *bdev;
	struct pci_dev *pdev = NULL;
	u16 link_status;
	unsigned int raw_speed, width, bw_per_lane;

	*gen = 0;
	*lanes = 0;

	if (kern_path(path, LOOKUP_FOLLOW, &target_path) != 0)
		return 0;

	if (!target_path.dentry || !target_path.dentry->d_inode ||
	    !target_path.dentry->d_inode->i_sb ||
	    !target_path.dentry->d_inode->i_sb->s_bdev) {
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
	case 1: *gen = 1; bw_per_lane = PCIE_GEN1_LANE_BW; break;
	case 2: *gen = 2; bw_per_lane = PCIE_GEN2_LANE_BW; break;
	case 3: *gen = 3; bw_per_lane = PCIE_GEN3_LANE_BW; break;
	case 4: *gen = 4; bw_per_lane = PCIE_GEN4_LANE_BW; break;
	case 5: *gen = 5; bw_per_lane = PCIE_GEN5_LANE_BW; break;
	default: *gen = 3; bw_per_lane = PCIE_GEN3_LANE_BW; break;
	}

	*lanes = width;
	return bw_per_lane * width;
}

static enum pcopy_device_class pmove_classify_device(const char *path,
						     unsigned int hw_queues,
						     unsigned int pcie_gen)
{
	struct path p;
	struct request_queue *q;
	int rotational = 1;

	if (kern_path(path, LOOKUP_FOLLOW, &p) == 0) {
		if (p.dentry && p.dentry->d_inode &&
		    p.dentry->d_inode->i_sb &&
		    p.dentry->d_inode->i_sb->s_bdev) {
			q = bdev_get_queue(p.dentry->d_inode->i_sb->s_bdev);
			if (q)
				rotational = !blk_queue_nonrot(q);
		}
		path_put(&p);
	}

	if (hw_queues > 2 && pcie_gen > 0) {
		if (pcie_gen >= 5) return PCOPY_DEV_NVME_GEN5;
		if (pcie_gen >= 4) return PCOPY_DEV_NVME_GEN4;
		return PCOPY_DEV_NVME_GEN3;
	}

	if (!rotational && hw_queues <= 2)
		return PCOPY_DEV_SATA_SSD;

	if (rotational) {
		if (hw_queues >= 2) return PCOPY_DEV_SAS_HDD;
		return PCOPY_DEV_SATA_HDD;
	}

	return PCOPY_DEV_UNKNOWN;
}

/* ===========================================================================
 * Dynamic Assignment (uses pcopy constants from shared header)
 * ===========================================================================
 */

static void pmove_dynamic_assign(unsigned int nr_files,
				 unsigned int hw_queues,
				 unsigned int pcie_gen,
				 unsigned int pcie_lanes,
				 unsigned int pcie_bw,
				 enum pcopy_device_class dev_class,
				 unsigned int flags,
				 struct pmove_dynamic_decision *out)
{
	unsigned int cpu_load_pct;
	unsigned int online_cpus;
	unsigned int device_speed;
	unsigned int cpu_alloc_pct;
	unsigned int cpu_channels, device_channels, pcie_channels, file_channels;
	unsigned int final_channels;
	unsigned int per_channel_bw;
	unsigned int chunk_kb;
	unsigned int bw_per_lane;

	memset(out, 0, sizeof(*out));

	online_cpus = num_online_cpus();
	cpu_load_pct = pmove_get_cpu_load_pct();

	/* Look up device speed from the shared pcopy constants */
	switch (dev_class) {
	case PCOPY_DEV_IDE_HDD:    device_speed = PCOPY_SPEED_IDE_HDD; break;
	case PCOPY_DEV_SATA_HDD:   device_speed = PCOPY_SPEED_SATA_HDD; break;
	case PCOPY_DEV_SAS_HDD:    device_speed = PCOPY_SPEED_SAS_HDD; break;
	case PCOPY_DEV_SATA_SSD:   device_speed = PCOPY_SPEED_SATA_SSD; break;
	case PCOPY_DEV_NVME_GEN3:  device_speed = PCOPY_SPEED_NVME_GEN3_X4; break;
	case PCOPY_DEV_NVME_GEN4:  device_speed = PCOPY_SPEED_NVME_GEN4_X4; break;
	case PCOPY_DEV_NVME_GEN5:  device_speed = PCOPY_SPEED_NVME_GEN5_X4; break;
	case PCOPY_DEV_USB2:       device_speed = PCOPY_SPEED_USB2; break;
	case PCOPY_DEV_USB3_GEN1:  device_speed = PCOPY_SPEED_USB3_GEN1; break;
	case PCOPY_DEV_USB3_GEN2:  device_speed = PCOPY_SPEED_USB3_GEN2; break;
	case PCOPY_DEV_USB4:       device_speed = PCOPY_SPEED_USB4; break;
	default:                   device_speed = 200; break;
	}

	out->nr_files = nr_files;
	out->device_class = dev_class;
	out->device_speed_mb_s = device_speed;
	out->pcie_bandwidth_mb_s = pcie_bw;
	out->cpu_load_pct = cpu_load_pct;
	out->available_cores = online_cpus;

	/* CPU load → allocation percentage */
	if (flags & PCOPY_F_HIGH_PRIORITY) {
		cpu_alloc_pct = 90;
	} else if (flags & PCOPY_F_LOW_PRIORITY) {
		cpu_alloc_pct = (cpu_load_pct > PCOPY_CPU_LOAD_MEDIUM) ? 5 : 15;
	} else {
		if (cpu_load_pct < PCOPY_CPU_LOAD_LOW)
			cpu_alloc_pct = PCOPY_ALLOC_IDLE;
		else if (cpu_load_pct < PCOPY_CPU_LOAD_MEDIUM)
			cpu_alloc_pct = PCOPY_ALLOC_MODERATE;
		else if (cpu_load_pct < PCOPY_CPU_LOAD_HIGH)
			cpu_alloc_pct = PCOPY_ALLOC_HEAVY;
		else
			cpu_alloc_pct = PCOPY_ALLOC_CRITICAL;
	}

	cpu_channels = max((online_cpus * cpu_alloc_pct) / 100, 1U);

	/* Device ceiling */
	per_channel_bw = device_speed / max(1U, (device_speed / 500));
	if (per_channel_bw == 0) per_channel_bw = 100;
	device_channels = device_speed / per_channel_bw;
	device_channels = clamp(device_channels, 1U, (unsigned int)PMOVE_MAX_CHANNELS);

	/* PCIe ceiling */
	if (pcie_bw > 0) {
		pcie_channels = pcie_bw / per_channel_bw;
		if (pcie_channels < 1) pcie_channels = 1;
	} else {
		pcie_channels = PMOVE_MAX_CHANNELS;
	}

	/* File count ceiling */
	file_channels = min(nr_files, (unsigned int)PMOVE_MAX_CHANNELS);

	/* Take tightest constraint */
	final_channels = min(cpu_channels, device_channels);
	final_channels = min(final_channels, pcie_channels);
	final_channels = min(final_channels, file_channels);
	final_channels = min(final_channels, hw_queues);
	final_channels = clamp(final_channels, 1U, (unsigned int)PMOVE_MAX_CHANNELS);

	/* Throttle reason */
	if (final_channels == cpu_channels && cpu_channels < device_channels)
		out->throttle_reason = PCOPY_THROTTLE_CPU_LOAD;
	else if (final_channels == device_channels && device_channels < cpu_channels)
		out->throttle_reason = PCOPY_THROTTLE_DEVICE_LIMIT;
	else if (final_channels == file_channels && file_channels < device_channels)
		out->throttle_reason = PCOPY_THROTTLE_FILE_COUNT;
	else if (final_channels == pcie_channels && pcie_channels < device_channels)
		out->throttle_reason = PCOPY_THROTTLE_PCIE_BW;
	else
		out->throttle_reason = PCOPY_THROTTLE_NONE;

	/* Assigned lanes */
	if (pcie_lanes > 0 && pcie_bw > 0) {
		bw_per_lane = pcie_bw / pcie_lanes;
		if (bw_per_lane > 0) {
			unsigned int needed = final_channels * per_channel_bw;
			out->assigned_lanes = min((needed + bw_per_lane - 1) / bw_per_lane,
						  pcie_lanes);
		} else {
			out->assigned_lanes = pcie_lanes;
		}
	}

	/* Chunk size from device class */
	switch (dev_class) {
	case PCOPY_DEV_IDE_HDD:
	case PCOPY_DEV_USB2:       chunk_kb = 512; break;
	case PCOPY_DEV_SATA_HDD:
	case PCOPY_DEV_SAS_HDD:
	case PCOPY_DEV_NFS_1GBE:   chunk_kb = 1024; break;
	case PCOPY_DEV_SATA_SSD:
	case PCOPY_DEV_USB3_GEN1:
	case PCOPY_DEV_NFS_10GBE:  chunk_kb = 4096; break;
	case PCOPY_DEV_NVME_GEN3:
	case PCOPY_DEV_USB3_GEN2:  chunk_kb = 4096; break;
	case PCOPY_DEV_NVME_GEN4:
	case PCOPY_DEV_NVME_GEN5:
	case PCOPY_DEV_USB4:       chunk_kb = 16384; break;
	default:                   chunk_kb = 4096; break;
	}

	if (cpu_load_pct > PCOPY_CPU_LOAD_HIGH && chunk_kb > 2048)
		chunk_kb /= 2;

	out->assigned_channels = final_channels;
	out->chunk_size = chunk_kb * 1024;
}

/* ===========================================================================
 * Core Move Processing
 * ===========================================================================
 */

static ssize_t pmove_fallback_copy_loop(const char *src, const char *dst,
					unsigned int chunk, unsigned int flags)
{
	struct file *f_in = NULL, *f_out = NULL;
	struct path dst_path;
	struct iattr target_attr;
	loff_t pos_in = 0, pos_out = 0, size_in;
	ssize_t global_transferred = 0, delta;
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
		delta = do_splice_direct(f_in, &pos_in, f_out, &pos_out,
					processing_len, SPLICE_F_MOVE);
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

	/* Try atomic rename first (unless forced to copy) */
	if (!(item->ctx->runtime_flags & PMOVE_F_FORCE_COPY)) {
		fn_src = getname_kernel(item->src_path);
		if (!IS_ERR(fn_src)) {
			fn_dst = getname_kernel(item->dst_path);
			if (!IS_ERR(fn_dst)) {
				structural_status = do_renameat2(AT_FDCWD, fn_src,
								AT_FDCWD, fn_dst, 0);
				putname(fn_dst);
				putname(fn_src);

				if (structural_status != -EXDEV) {
					item->payload_bytes = 0;
					item->used_rename = true;
					return structural_status;
				}
			} else {
				putname(fn_src);
			}
		}
	}

	/* Cross-device: splice copy + unlink */
	item->used_rename = false;
	item->payload_bytes = pmove_fallback_copy_loop(
		item->src_path, item->dst_path,
		item->ctx->run_chunk_size,
		item->ctx->runtime_flags | PMOVE_F_PRESERVE);

	if (item->payload_bytes < 0)
		return (int)item->payload_bytes;

	/* Unlink source after successful copy */
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
			pr_warn("pmove: item %u failed: %s → %s (err %d)\n",
				item->idx, item->src_path, item->dst_path,
				item->status);
	} else {
		atomic_inc(&ctx->metrics_processed);
		if (item->used_rename)
			atomic_inc(&ctx->metrics_renamed);
		else
			atomic_inc(&ctx->metrics_spliced);
		if (item->payload_bytes > 0)
			atomic64_add(item->payload_bytes, &ctx->metrics_copied_bytes);
	}

escape:
	complete(&item->signal);
}

/* ===========================================================================
 * Batch Execution with Dynamic Assignment
 * ===========================================================================
 */

static int pmove_dispatch_batch(struct pmove_batch_request __user *ureq)
{
	struct pmove_batch_request kreq;
	struct pmove_batch_ctx *ctx;
	struct pmove_file_pair current_pair;
	struct pmove_dynamic_decision decision;
	unsigned int hw_queues, pcie_gen, pcie_lanes, pcie_bw;
	enum pcopy_device_class dev_class;
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
	atomic_set(&ctx->metrics_renamed, 0);
	atomic_set(&ctx->metrics_spliced, 0);
	atomic64_set(&ctx->metrics_copied_bytes, 0);
	ctx->abort_triggered = false;

	/* Detect hardware from first file */
	if (copy_from_user(&current_pair, &kreq.pairs[0], sizeof(current_pair))) {
		internal_rc = -EFAULT;
		goto cleanup;
	}

	hw_queues = pmove_probe_queues(current_pair.src_path);
	pcie_bw = pmove_probe_bandwidth(current_pair.src_path, &pcie_gen, &pcie_lanes);
	dev_class = pmove_classify_device(current_pair.src_path, hw_queues, pcie_gen);

	/* Dynamic assignment */
	pmove_dynamic_assign(kreq.nr_files, hw_queues, pcie_gen, pcie_lanes,
			     pcie_bw, dev_class, kreq.flags, &decision);

	/* User overrides */
	if (kreq.max_channels > 0 && kreq.max_channels < decision.assigned_channels)
		decision.assigned_channels = kreq.max_channels;
	if (kreq.chunk_size > 0)
		decision.chunk_size = clamp(kreq.chunk_size,
					    (unsigned int)PMOVE_CHUNK_MIN,
					    (unsigned int)PMOVE_CHUNK_MAX);

	ctx->active_channels = decision.assigned_channels;
	ctx->run_chunk_size = decision.chunk_size;
	ctx->decision = decision;

	/* Store decision */
	mutex_lock(&pmove_state.decision_lock);
	pmove_state.last_decision = decision;
	mutex_unlock(&pmove_state.decision_lock);

	/* Create workqueue */
	ctx->private_wq = alloc_workqueue("pmove_wq",
					  WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
					  ctx->active_channels);
	if (!ctx->private_wq) {
		internal_rc = -ENOMEM;
		goto cleanup;
	}

	/* Dispatch work items */
	for (loop_idx = 0; loop_idx < kreq.nr_files; loop_idx++) {
		struct pmove_work_item *item = &ctx->items[loop_idx];

		if (copy_from_user(&current_pair, &kreq.pairs[loop_idx],
				   sizeof(current_pair))) {
			internal_rc = -EFAULT;
			ctx->abort_triggered = true;
			break;
		}

		item->ctx = ctx;
		item->idx = loop_idx;
		strscpy(item->src_path, current_pair.src_path, PATH_MAX);
		strscpy(item->dst_path, current_pair.dst_path, PATH_MAX);
		item->payload_bytes = 0;
		item->status = 0;
		item->used_rename = false;
		init_completion(&item->signal);
		INIT_WORK(&item->work, pmove_execution_worker);

		queue_work(ctx->private_wq, &item->work);
	}

	/* Wait for completion */
	for (loop_idx = 0; loop_idx < kreq.nr_files; loop_idx++) {
		if (ctx->items[loop_idx].ctx)
			wait_for_completion(&ctx->items[loop_idx].signal);
	}

	destroy_workqueue(ctx->private_wq);
	ctx->private_wq = NULL;

	/* Record rename/splice stats in decision */
	decision.atomic_renames = atomic_read(&ctx->metrics_renamed);
	decision.splice_fallbacks = atomic_read(&ctx->metrics_spliced);

	mutex_lock(&pmove_state.decision_lock);
	pmove_state.last_decision = decision;
	mutex_unlock(&pmove_state.decision_lock);

	if (atomic_read(&ctx->metrics_failed) > 0 && internal_rc == 0) {
		for (loop_idx = 0; loop_idx < kreq.nr_files; loop_idx++) {
			if (ctx->items[loop_idx].status) {
				internal_rc = ctx->items[loop_idx].status;
				break;
			}
		}
	}

	pr_info("pmove: batch complete — %u files, %u channels, %u lanes, "
		"%u renamed, %u spliced, %lld bytes, cpu=%u%%\n",
		kreq.nr_files, ctx->active_channels, decision.assigned_lanes,
		atomic_read(&ctx->metrics_renamed),
		atomic_read(&ctx->metrics_spliced),
		(long long)atomic64_read(&ctx->metrics_copied_bytes),
		decision.cpu_load_pct);

cleanup:
	kfree(ctx->items);
	kfree(ctx);
	return internal_rc;
}

/* ===========================================================================
 * /proc Interface
 * ===========================================================================
 */

static const char *pmove_throttle_name(unsigned int reason)
{
	switch (reason) {
	case PCOPY_THROTTLE_NONE:         return "none";
	case PCOPY_THROTTLE_CPU_LOAD:     return "cpu_load";
	case PCOPY_THROTTLE_DEVICE_LIMIT: return "device_limit";
	case PCOPY_THROTTLE_FILE_COUNT:   return "file_count";
	case PCOPY_THROTTLE_PCIE_BW:      return "pcie_bandwidth";
	default:                          return "unknown";
	}
}

static const char *pmove_device_name(enum pcopy_device_class c)
{
	switch (c) {
	case PCOPY_DEV_IDE_HDD:    return "IDE HDD";
	case PCOPY_DEV_SATA_HDD:   return "SATA HDD";
	case PCOPY_DEV_SAS_HDD:    return "SAS HDD";
	case PCOPY_DEV_SATA_SSD:   return "SATA SSD";
	case PCOPY_DEV_NVME_GEN3:  return "NVMe Gen3";
	case PCOPY_DEV_NVME_GEN4:  return "NVMe Gen4";
	case PCOPY_DEV_NVME_GEN5:  return "NVMe Gen5";
	case PCOPY_DEV_USB2:       return "USB 2.0";
	case PCOPY_DEV_USB3_GEN1:  return "USB 3.0";
	case PCOPY_DEV_USB3_GEN2:  return "USB 3.1 Gen2";
	case PCOPY_DEV_USB4:       return "USB4/TB3";
	default:                   return "Unknown";
	}
}

static int pmove_status_show(struct seq_file *m, void *v)
{
	struct pmove_dynamic_decision d;
	unsigned int cpu_load = pmove_get_cpu_load_pct();

	seq_puts(m, "=== Parallel Move — Dynamic Assignment Status ===\n\n");
	seq_printf(m, "Online CPUs:          %u\n", num_online_cpus());
	seq_printf(m, "Current CPU Load:     %u%%\n", cpu_load);
	seq_printf(m, "Active Operations:    %d\n",
		   atomic_read(&pmove_state.runtime_active_ops));
	seq_puts(m, "\n");

	mutex_lock(&pmove_state.decision_lock);
	d = pmove_state.last_decision;
	mutex_unlock(&pmove_state.decision_lock);

	if (d.nr_files > 0) {
		seq_puts(m, "--- Last Dynamic Decision ---\n");
		seq_printf(m, "  Files:            %u\n", d.nr_files);
		seq_printf(m, "  Device:           %s (%u MB/s)\n",
			   pmove_device_name(d.device_class), d.device_speed_mb_s);
		seq_printf(m, "  PCIe BW:          %u MB/s\n", d.pcie_bandwidth_mb_s);
		seq_printf(m, "  CPU Load:         %u%%\n", d.cpu_load_pct);
		seq_printf(m, "  → Channels:       %u\n", d.assigned_channels);
		seq_printf(m, "  → Lanes:          %u\n", d.assigned_lanes);
		seq_printf(m, "  → Chunk:          %u KB\n", d.chunk_size / 1024);
		seq_printf(m, "  → Throttle:       %s\n",
			   pmove_throttle_name(d.throttle_reason));
		seq_printf(m, "  → Renames:        %u (instant)\n", d.atomic_renames);
		seq_printf(m, "  → Spliced:        %u (cross-device)\n", d.splice_fallbacks);
	} else {
		seq_puts(m, "--- No operations performed yet ---\n");
	}

	return 0;
}

static int pmove_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, pmove_status_show, NULL);
}

static const struct proc_ops pmove_status_ops = {
	.proc_open    = pmove_status_open,
	.proc_read    = seq_read,
	.proc_lseek   = seq_lseek,
	.proc_release = single_release,
};

static int pmove_config_show(struct seq_file *m, void *v)
{
	seq_puts(m, "=== pmove Dynamic Configuration ===\n\n");
	seq_printf(m, "channel_override: %u (0 = dynamic)\n",
		   pmove_state.global_channel_override);
	seq_printf(m, "chunk_override:   %u KB (0 = dynamic)\n",
		   pmove_state.global_chunk_override / 1024);
	seq_puts(m, "\nWrite 'channels=N' or 'chunk=N' to override.\n");
	return 0;
}

static int pmove_config_open(struct inode *inode, struct file *file)
{
	return single_open(file, pmove_config_show, NULL);
}

static ssize_t pmove_config_write(struct file *file, const char __user *buf,
				  size_t count, loff_t *ppos)
{
	char kbuf[64];
	unsigned int val;

	if (count >= sizeof(kbuf))
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';

	if (sscanf(kbuf, "channels=%u", &val) == 1) {
		if (val > PMOVE_MAX_CHANNELS) return -EINVAL;
		pmove_state.global_channel_override = val;
	} else if (sscanf(kbuf, "chunk=%u", &val) == 1) {
		if (val > 0) {
			val *= 1024;
			if (val < PMOVE_CHUNK_MIN || val > PMOVE_CHUNK_MAX)
				return -EINVAL;
		}
		pmove_state.global_chunk_override = val;
	} else {
		return -EINVAL;
	}

	return count;
}

static const struct proc_ops pmove_config_ops = {
	.proc_open    = pmove_config_open,
	.proc_read    = seq_read,
	.proc_write   = pmove_config_write,
	.proc_lseek   = seq_lseek,
	.proc_release = single_release,
};

/* ===========================================================================
 * /dev/pmove — ioctl interface
 * ===========================================================================
 */

static long pmove_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	switch (cmd) {
	case PMOVE_IOC_EXEC_BATCH:
		atomic_inc(&pmove_state.runtime_active_ops);
		{
			int ret = pmove_dispatch_batch(
				(struct pmove_batch_request __user *)arg);
			atomic_dec(&pmove_state.runtime_active_ops);
			return ret;
		}

	case PMOVE_IOC_GET_TELEMETRY:
		{
			struct pmove_hw_telemetry tel;
			struct pmove_dynamic_decision d;
			unsigned int hw_q, gen, lanes, bw;
			enum pcopy_device_class dclass;

			memset(&tel, 0, sizeof(tel));

			hw_q = pmove_probe_queues("/");
			bw = pmove_probe_bandwidth("/", &gen, &lanes);
			dclass = pmove_classify_device("/", hw_q, gen);

			tel.online_cpus = num_online_cpus();
			tel.nr_hw_queues = hw_q;
			tel.pcie_gen = gen;
			tel.pcie_lanes = lanes;
			tel.estimated_bw_mb_s = bw;
			tel.is_nvme = (hw_q > 2) ? 1 : 0;
			tel.cpu_load_pct = pmove_get_cpu_load_pct();

			pmove_dynamic_assign(100, hw_q, gen, lanes, bw,
					     dclass, 0, &d);
			tel.device_speed_mb_s = d.device_speed_mb_s;
			tel.device_class = d.device_class;
			tel.optimal_channels = d.assigned_channels;
			tel.calculated_chunk_size = d.chunk_size;
			tel.assigned_lanes = d.assigned_lanes;
			tel.throttle_reason = d.throttle_reason;

			if (copy_to_user((void __user *)arg, &tel, sizeof(tel)))
				return -EFAULT;
			return 0;
		}

	case PMOVE_IOC_GET_DECISION:
		{
			struct pmove_dynamic_decision d;

			mutex_lock(&pmove_state.decision_lock);
			d = pmove_state.last_decision;
			mutex_unlock(&pmove_state.decision_lock);

			if (copy_to_user((void __user *)arg, &d, sizeof(d)))
				return -EFAULT;
			return 0;
		}

	default:
		return -ENOTTY;
	}
}

static const struct file_operations pmove_fops = {
	.owner          = THIS_MODULE,
	.unlocked_ioctl = pmove_ioctl,
	.compat_ioctl   = pmove_ioctl,
};

/* ===========================================================================
 * Module Init / Exit
 * ===========================================================================
 */

static int __init pmove_init(void)
{
	int ret;

	pr_info("pmove: initializing Parallel Move with Dynamic Assignment\n");

	mutex_init(&pmove_state.engine_lock);
	mutex_init(&pmove_state.decision_lock);
	atomic_set(&pmove_state.runtime_active_ops, 0);
	pmove_state.global_chunk_override = 0;
	pmove_state.global_channel_override = 0;
	memset(&pmove_state.last_decision, 0, sizeof(pmove_state.last_decision));

	/* Create /proc/pmove/ */
	pmove_state.proc_root = proc_mkdir("pmove", NULL);
	if (!pmove_state.proc_root) {
		pr_err("pmove: failed to create /proc/pmove\n");
		return -ENOMEM;
	}

	proc_create("status", 0444, pmove_state.proc_root, &pmove_status_ops);
	proc_create("config", 0644, pmove_state.proc_root, &pmove_config_ops);

	/* Register /dev/pmove */
	pmove_state.misc_dev.minor = MISC_DYNAMIC_MINOR;
	pmove_state.misc_dev.name = "pmove";
	pmove_state.misc_dev.fops = &pmove_fops;
	pmove_state.misc_dev.mode = 0660;

	ret = misc_register(&pmove_state.misc_dev);
	if (ret) {
		pr_err("pmove: failed to register /dev/pmove: %d\n", ret);
		proc_remove(pmove_state.proc_root);
		return ret;
	}

	pr_info("pmove: ready — %u CPUs, dynamic assignment active\n",
		num_online_cpus());

	return 0;
}

static void __exit pmove_exit(void)
{
	while (atomic_read(&pmove_state.runtime_active_ops) > 0) {
		pr_info("pmove: waiting for %d active operations...\n",
			atomic_read(&pmove_state.runtime_active_ops));
		msleep(100);
	}

	misc_deregister(&pmove_state.misc_dev);
	proc_remove(pmove_state.proc_root);

	pr_info("pmove: module unloaded\n");
}

module_init(pmove_init);
module_exit(pmove_exit);
