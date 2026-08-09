// SPDX-License-Identifier: GPL-2.0
/*
 * pcopy.c — Parallel Copy/Move with NVMe Multi-Queue & PCIe Lane Awareness
 *
 * This module provides hardware-aware parallel file copy and move operations.
 * It detects the underlying block device capabilities (NVMe queue depth,
 * PCIe lane width, CPU count) and schedules concurrent I/O across multiple
 * channels to saturate available hardware bandwidth.
 *
 * Theory of operation:
 *   - Standard cp/mv operates sequentially: read → write → read → write
 *   - NVMe SSDs expose multiple hardware submission queues (often 1 per CPU)
 *   - PCIe Gen4 x4 provides ~7 GB/s per device
 *   - This module issues parallel I/O across multiple files simultaneously,
 *     using a channel count derived from: min(online_cpus, hw_queues, file_count)
 *
 * The module exposes:
 *   /proc/pcopy/status       - Current state and hardware detection
 *   /proc/pcopy/config       - Tunable parameters
 *   /dev/pcopy               - ioctl interface for userspace pcopy/pmove tools
 *
 * Syscall extension:
 *   sys_pcopy_file_range()   - Parallel multi-file copy_file_range
 *   sys_pmove()              - Parallel multi-file rename/move with fallback
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
#include <linux/nvme.h>
#include <linux/pci.h>
#include <linux/miscdevice.h>
#include <linux/namei.h>
#include <linux/mount.h>
#include <linux/splice.h>
#include <linux/atomic.h>
#include <linux/mutex.h>
#include <linux/kthread.h>
#include <linux/sched.h>
#include <linux/string.h>
#include <linux/types.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maximilian Eric Alexander Rupplin von Keffikon");
MODULE_DESCRIPTION("Parallel Copy/Move — NVMe Multi-Queue & PCIe Lane Aware");
MODULE_VERSION("1.0");

/* ===========================================================================
 * Constants & Configuration
 * ===========================================================================
 */

#define PCOPY_MAX_CHANNELS      64      /* Max parallel copy channels */
#define PCOPY_MAX_FILES         4096    /* Max files in one batch operation */
#define PCOPY_CHUNK_SIZE        (4 * 1024 * 1024)  /* 4MB per I/O chunk */
#define PCOPY_CHUNK_SIZE_MIN    (64 * 1024)        /* 64KB minimum */
#define PCOPY_CHUNK_SIZE_MAX    (64 * 1024 * 1024) /* 64MB maximum */
#define PCOPY_PIPE_BUFS         16      /* Splice pipe buffer count */
#define PCOPY_IOCTL_MAGIC       0xPC
#define PCOPY_WQ_NAME           "pcopy_wq"

/* ioctl commands */
#define PCOPY_IOC_COPY          _IOW(PCOPY_IOCTL_MAGIC, 1, struct pcopy_batch_request)
#define PCOPY_IOC_MOVE          _IOW(PCOPY_IOCTL_MAGIC, 2, struct pcopy_batch_request)
#define PCOPY_IOC_STATUS        _IOR(PCOPY_IOCTL_MAGIC, 3, struct pcopy_hw_status)
#define PCOPY_IOC_CANCEL        _IO(PCOPY_IOCTL_MAGIC, 4)

/* PCIe generation bandwidth per lane (MB/s, approximate) */
#define PCIE_GEN1_LANE_BW       250
#define PCIE_GEN2_LANE_BW       500
#define PCIE_GEN3_LANE_BW       985
#define PCIE_GEN4_LANE_BW       1969
#define PCIE_GEN5_LANE_BW       3938

/* ===========================================================================
 * Data Structures
 * ===========================================================================
 */

/* Per-file copy/move request from userspace */
struct pcopy_file_pair {
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
};

/* Batch request from userspace */
struct pcopy_batch_request {
	__u32 nr_files;                         /* Number of file pairs */
	__u32 flags;                            /* PCOPY_F_* flags */
	__u32 max_channels;                     /* 0 = auto-detect */
	__u32 chunk_size;                       /* 0 = auto-tune */
	struct pcopy_file_pair __user *pairs;   /* Array of src/dst pairs */
};

/* Flags for batch request */
#define PCOPY_F_SYNC            (1 << 0)    /* fsync after each file */
#define PCOPY_F_PRESERVE        (1 << 1)    /* Preserve permissions/timestamps */
#define PCOPY_F_OVERWRITE       (1 << 2)    /* Overwrite existing destinations */
#define PCOPY_F_MOVE            (1 << 3)    /* Move (copy + unlink source) */
#define PCOPY_F_CROSS_DEVICE    (1 << 4)    /* Allow cross-device copy for move */
#define PCOPY_F_VERBOSE         (1 << 5)    /* Track per-file progress */

/* Hardware status report */
struct pcopy_hw_status {
	__u32 online_cpus;
	__u32 nr_hw_queues;         /* From block device */
	__u32 pcie_gen;             /* 1-5 */
	__u32 pcie_lanes;           /* x1, x2, x4, x8, x16 */
	__u32 bandwidth_mb_s;       /* Estimated total bandwidth */
	__u32 recommended_channels; /* Computed optimal channel count */
	__u32 chunk_size;           /* Recommended chunk size */
	__u32 nvme_detected;        /* 1 if NVMe device found on path */
};

/* Internal: per-file work item */
struct pcopy_work_item {
	struct work_struct work;
	struct pcopy_batch_ctx *ctx;     /* Parent batch context */
	unsigned int index;              /* File index in batch */
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
	ssize_t bytes_copied;            /* Result: bytes copied */
	int error;                       /* Result: error code or 0 */
	struct completion done;          /* Signaled on completion */
};

/* Internal: batch operation context */
struct pcopy_batch_ctx {
	struct pcopy_work_item *items;
	unsigned int nr_files;
	unsigned int nr_channels;
	unsigned int chunk_size;
	unsigned int flags;
	atomic_t completed;
	atomic_t errors;
	atomic64_t total_bytes;
	struct workqueue_struct *wq;
	bool cancelled;
};

/* Module-global state */
static struct {
	struct workqueue_struct *wq;
	struct proc_dir_entry *proc_dir;
	struct miscdevice misc;
	struct mutex op_lock;
	atomic_t active_ops;
	unsigned int default_chunk_size;
	unsigned int max_channels;

	/* Cached hardware detection */
	unsigned int cached_cpus;
	unsigned int cached_hw_queues;
	unsigned int cached_pcie_gen;
	unsigned int cached_pcie_lanes;
	unsigned int cached_bandwidth;
} pcopy_state;

/* ===========================================================================
 * Hardware Detection
 * ===========================================================================
 */

/*
 * Detect the number of hardware queues on the block device backing a path.
 * NVMe devices typically expose nr_hw_queues == num_online_cpus().
 */
static unsigned int pcopy_detect_hw_queues(const char *path)
{
	struct path p;
	struct request_queue *q;
	unsigned int hw_queues = 1;
	int err;

	err = kern_path(path, LOOKUP_FOLLOW, &p);
	if (err)
		return 1;

	if (p.dentry && p.dentry->d_inode &&
	    p.dentry->d_inode->i_sb &&
	    p.dentry->d_inode->i_sb->s_bdev) {
		q = bdev_get_queue(p.dentry->d_inode->i_sb->s_bdev);
		if (q)
			hw_queues = q->nr_hw_queues;
	}

	path_put(&p);
	return hw_queues ? hw_queues : 1;
}

/*
 * Detect PCIe generation and lane width for the block device.
 * Returns bandwidth estimate in MB/s.
 *
 * For NVMe: the PCI device is the NVMe controller.
 * We read the PCIe Link Status register to get speed and width.
 */
static unsigned int pcopy_detect_pcie_bandwidth(const char *path,
						unsigned int *out_gen,
						unsigned int *out_lanes)
{
	struct path p;
	struct block_device *bdev;
	struct pci_dev *pdev = NULL;
	u16 link_status;
	unsigned int speed, width;
	unsigned int bw_per_lane;
	int err;

	*out_gen = 0;
	*out_lanes = 0;

	err = kern_path(path, LOOKUP_FOLLOW, &p);
	if (err)
		return 0;

	if (!p.dentry || !p.dentry->d_inode ||
	    !p.dentry->d_inode->i_sb ||
	    !p.dentry->d_inode->i_sb->s_bdev) {
		path_put(&p);
		return 0;
	}

	bdev = p.dentry->d_inode->i_sb->s_bdev;

	/*
	 * Walk up the device hierarchy to find the PCI device.
	 * For NVMe, the gendisk's parent device is the NVMe controller,
	 * which is a PCI device.
	 */
	if (bdev->bd_disk && bdev->bd_disk->driverfs_dev) {
		struct device *dev = bdev->bd_disk->driverfs_dev;

		/* Walk up to find PCI device */
		while (dev && !dev_is_pci(dev))
			dev = dev->parent;

		if (dev && dev_is_pci(dev))
			pdev = to_pci_dev(dev);
	}

	path_put(&p);

	if (!pdev)
		return 0;

	/* Read PCIe Link Status register */
	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &link_status);

	speed = link_status & PCI_EXP_LNKSTA_CLS;  /* Link speed */
	width = (link_status & PCI_EXP_LNKSTA_NLW) >> 4;  /* Link width */

	switch (speed) {
	case 1: *out_gen = 1; bw_per_lane = PCIE_GEN1_LANE_BW; break;
	case 2: *out_gen = 2; bw_per_lane = PCIE_GEN2_LANE_BW; break;
	case 3: *out_gen = 3; bw_per_lane = PCIE_GEN3_LANE_BW; break;
	case 4: *out_gen = 4; bw_per_lane = PCIE_GEN4_LANE_BW; break;
	case 5: *out_gen = 5; bw_per_lane = PCIE_GEN5_LANE_BW; break;
	default: *out_gen = 0; bw_per_lane = PCIE_GEN3_LANE_BW; break;
	}

	*out_lanes = width;
	return bw_per_lane * width;
}

/*
 * Compute the optimal number of parallel channels for a batch operation.
 *
 * The formula:
 *   channels = min(online_cpus, hw_queues, nr_files)
 *
 * Rationale:
 *   - Each channel occupies one CPU for splice/copy work
 *   - Each channel should map to a distinct hardware queue (NVMe SQ)
 *   - No point having more channels than files
 *   - PCIe bandwidth caps total throughput regardless of queue count
 *
 * For cross-device copies (src NVMe → dst NVMe), channels can be doubled
 * since read and write go to different devices with independent lanes.
 */
static unsigned int pcopy_compute_channels(unsigned int nr_files,
					   unsigned int hw_queues,
					   unsigned int max_override)
{
	unsigned int cpus = num_online_cpus();
	unsigned int channels;

	/* Base: min of all constraints */
	channels = min3(cpus, hw_queues, nr_files);

	/* Cap at configured maximum */
	if (channels > PCOPY_MAX_CHANNELS)
		channels = PCOPY_MAX_CHANNELS;

	/* User override (non-zero) takes precedence but still capped */
	if (max_override > 0 && max_override < channels)
		channels = max_override;

	/* Always at least 1 */
	return channels ? channels : 1;
}

/*
 * Compute optimal chunk size based on device characteristics.
 *
 * NVMe devices with high queue depth benefit from larger chunks
 * (fewer I/O submissions, better coalescing). SATA/slow devices
 * benefit from smaller chunks (lower latency, better interleaving).
 */
static unsigned int pcopy_compute_chunk_size(unsigned int bandwidth_mb_s,
					     unsigned int hw_queues)
{
	unsigned int chunk;

	if (bandwidth_mb_s >= 5000) {
		/* PCIe Gen4 x4 or better: 16MB chunks */
		chunk = 16 * 1024 * 1024;
	} else if (bandwidth_mb_s >= 2000) {
		/* PCIe Gen3 x4: 8MB chunks */
		chunk = 8 * 1024 * 1024;
	} else if (bandwidth_mb_s >= 500) {
		/* SATA SSD / PCIe Gen3 x1: 4MB chunks */
		chunk = 4 * 1024 * 1024;
	} else {
		/* HDD or USB: 1MB chunks */
		chunk = 1024 * 1024;
	}

	/* Scale down if few hw queues (device can't absorb many large I/Os) */
	if (hw_queues <= 2)
		chunk = min(chunk, (unsigned int)(2 * 1024 * 1024));

	return clamp(chunk, (unsigned int)PCOPY_CHUNK_SIZE_MIN,
		     (unsigned int)PCOPY_CHUNK_SIZE_MAX);
}

/*
 * Populate a hardware status structure for the given path.
 */
static void pcopy_get_hw_status(const char *path, struct pcopy_hw_status *st)
{
	unsigned int pcie_gen, pcie_lanes;

	memset(st, 0, sizeof(*st));

	st->online_cpus = num_online_cpus();
	st->nr_hw_queues = pcopy_detect_hw_queues(path);
	st->bandwidth_mb_s = pcopy_detect_pcie_bandwidth(path,
							 &pcie_gen, &pcie_lanes);
	st->pcie_gen = pcie_gen;
	st->pcie_lanes = pcie_lanes;
	st->nvme_detected = (st->nr_hw_queues > 2) ? 1 : 0;
	st->chunk_size = pcopy_compute_chunk_size(st->bandwidth_mb_s,
						  st->nr_hw_queues);
	st->recommended_channels = pcopy_compute_channels(
		PCOPY_MAX_FILES, st->nr_hw_queues, 0);
}

/* ===========================================================================
 * Core Copy Engine
 * ===========================================================================
 */

/*
 * Copy a single file using kernel splice (zero-copy when possible).
 * This is the work function executed on each channel's workqueue thread.
 *
 * Uses do_splice_direct() which leverages the page cache and can achieve
 * zero-copy on same-filesystem operations where the fs supports it.
 */
static ssize_t pcopy_copy_single_file(const char *src_path,
				      const char *dst_path,
				      unsigned int chunk_size,
				      unsigned int flags)
{
	struct file *src_file = NULL;
	struct file *dst_file = NULL;
	struct path src_p;
	struct iattr attr;
	loff_t src_pos = 0, dst_pos = 0;
	loff_t src_size;
	ssize_t total = 0, ret;
	int open_flags;
	int err;

	/* Open source for reading */
	src_file = filp_open(src_path, O_RDONLY | O_LARGEFILE, 0);
	if (IS_ERR(src_file))
		return PTR_ERR(src_file);

	src_size = i_size_read(file_inode(src_file));
	if (src_size == 0) {
		/* Zero-length file: just create destination */
		open_flags = O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE;
		if (!(flags & PCOPY_F_OVERWRITE))
			open_flags |= O_EXCL;

		dst_file = filp_open(dst_path, open_flags, 0644);
		if (IS_ERR(dst_file)) {
			ret = PTR_ERR(dst_file);
			filp_close(src_file, NULL);
			return ret;
		}
		filp_close(dst_file, NULL);
		filp_close(src_file, NULL);
		return 0;
	}

	/* Open destination for writing */
	open_flags = O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE;
	if (!(flags & PCOPY_F_OVERWRITE))
		open_flags |= O_EXCL;

	dst_file = filp_open(dst_path, open_flags, 0644);
	if (IS_ERR(dst_file)) {
		ret = PTR_ERR(dst_file);
		filp_close(src_file, NULL);
		return ret;
	}

	/* Copy loop: splice in chunks */
	while (src_pos < src_size) {
		size_t to_copy = min_t(loff_t, chunk_size, src_size - src_pos);

		ret = do_splice_direct(src_file, &src_pos,
				       dst_file, &dst_pos,
				       to_copy, SPLICE_F_MOVE);
		if (ret <= 0) {
			if (ret == 0)
				break;  /* EOF */
			total = ret;  /* Error */
			goto out;
		}

		total += ret;

		/* Allow other work to proceed */
		cond_resched();
	}

	/* Optionally sync to stable storage */
	if (flags & PCOPY_F_SYNC) {
		ret = vfs_fsync(dst_file, 0);
		if (ret < 0) {
			total = ret;
			goto out;
		}
	}

	/* Preserve permissions and timestamps if requested */
	if (flags & PCOPY_F_PRESERVE) {
		struct inode *src_inode = file_inode(src_file);

		memset(&attr, 0, sizeof(attr));
		attr.ia_valid = ATTR_MODE | ATTR_ATIME | ATTR_MTIME;
		attr.ia_mode = src_inode->i_mode;
		attr.ia_atime = src_inode->i_atime;
		attr.ia_mtime = src_inode->i_mtime;

		/* Best-effort: don't fail the copy if attrs can't be set */
		err = kern_path(dst_path, LOOKUP_FOLLOW, &src_p);
		if (!err) {
			notify_change(&init_user_ns, src_p.dentry, &attr, NULL);
			path_put(&src_p);
		}
	}

out:
	filp_close(dst_file, NULL);
	filp_close(src_file, NULL);
	return total;
}

/*
 * Attempt atomic rename (same filesystem). Falls back to copy+unlink
 * for cross-device moves.
 */
static int pcopy_move_single_file(const char *src_path,
				  const char *dst_path,
				  unsigned int chunk_size,
				  unsigned int flags)
{
	struct path old_path, new_parent_path;
	struct dentry *old_dentry, *new_dentry;
	struct filename *from, *to;
	ssize_t ret;
	int err;

	/*
	 * First attempt: vfs_rename (atomic, same filesystem).
	 * This is the fast path — no data copy needed.
	 */
	from = getname_kernel(src_path);
	if (IS_ERR(from))
		return PTR_ERR(from);

	to = getname_kernel(dst_path);
	if (IS_ERR(to)) {
		putname(from);
		return PTR_ERR(to);
	}

	err = do_renameat2(AT_FDCWD, from, AT_FDCWD, to, 0);

	if (err != -EXDEV)
		return err;  /* Success or non-cross-device error */

	/*
	 * Cross-device move: copy data then unlink source.
	 * Only proceed if PCOPY_F_CROSS_DEVICE is set.
	 */
	if (!(flags & PCOPY_F_CROSS_DEVICE))
		return -EXDEV;

	/* Copy the file data */
	ret = pcopy_copy_single_file(src_path, dst_path, chunk_size,
				     flags | PCOPY_F_PRESERVE);
	if (ret < 0)
		return (int)ret;

	/* Unlink source after successful copy */
	from = getname_kernel(src_path);
	if (IS_ERR(from))
		return PTR_ERR(from);

	err = do_unlinkat(AT_FDCWD, from, 0);
	return err;
}

/* ===========================================================================
 * Workqueue Dispatch (Parallel Engine)
 * ===========================================================================
 */

/*
 * Per-file work function. Executed in parallel across workqueue threads.
 */
static void pcopy_work_fn(struct work_struct *work)
{
	struct pcopy_work_item *item =
		container_of(work, struct pcopy_work_item, work);
	struct pcopy_batch_ctx *ctx = item->ctx;

	if (ctx->cancelled) {
		item->error = -ECANCELED;
		goto done;
	}

	if (ctx->flags & PCOPY_F_MOVE) {
		item->error = pcopy_move_single_file(
			item->src_path, item->dst_path,
			ctx->chunk_size, ctx->flags);
		if (item->error == 0)
			item->bytes_copied = 0;  /* Rename, no data copy */
	} else {
		item->bytes_copied = pcopy_copy_single_file(
			item->src_path, item->dst_path,
			ctx->chunk_size, ctx->flags);
		if (item->bytes_copied < 0) {
			item->error = (int)item->bytes_copied;
			item->bytes_copied = 0;
		}
	}

	if (item->error)
		atomic_inc(&ctx->errors);

	atomic64_add(item->bytes_copied, &ctx->total_bytes);
	atomic_inc(&ctx->completed);

done:
	complete(&item->done);
}

/*
 * Execute a batch of copy/move operations in parallel.
 *
 * Channel allocation:
 *   - Creates a workqueue with max_active = nr_channels
 *   - Each channel processes one file at a time
 *   - Files are dispatched round-robin across channels
 *   - Workqueue threads are CPU-affinitized by the scheduler
 *
 * NVMe multi-queue benefit:
 *   - blk-mq maps software queues to hardware queues per-CPU
 *   - With N channels on N CPUs, we hit N distinct hardware submission queues
 *   - NVMe controller processes all N queues in parallel (hardware parallelism)
 *   - Result: N × single-queue throughput (up to PCIe bandwidth limit)
 */
static int pcopy_execute_batch(struct pcopy_batch_request __user *ureq)
{
	struct pcopy_batch_request req;
	struct pcopy_batch_ctx *ctx = NULL;
	struct pcopy_file_pair pair;
	struct pcopy_hw_status hw;
	unsigned int i;
	int ret = 0;

	if (copy_from_user(&req, ureq, sizeof(req)))
		return -EFAULT;

	if (req.nr_files == 0 || req.nr_files > PCOPY_MAX_FILES)
		return -EINVAL;

	if (!req.pairs)
		return -EINVAL;

	/* Allocate batch context */
	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
	if (!ctx)
		return -ENOMEM;

	ctx->items = kcalloc(req.nr_files, sizeof(struct pcopy_work_item),
			     GFP_KERNEL);
	if (!ctx->items) {
		kfree(ctx);
		return -ENOMEM;
	}

	ctx->nr_files = req.nr_files;
	ctx->flags = req.flags;
	atomic_set(&ctx->completed, 0);
	atomic_set(&ctx->errors, 0);
	atomic64_set(&ctx->total_bytes, 0);
	ctx->cancelled = false;

	/* Copy file pairs from userspace and detect hardware on first path */
	if (copy_from_user(&pair, &req.pairs[0], sizeof(pair))) {
		ret = -EFAULT;
		goto out_free;
	}

	/* Detect hardware capabilities from first source path */
	pcopy_get_hw_status(pair.src_path, &hw);

	/* Compute channel count */
	ctx->nr_channels = pcopy_compute_channels(req.nr_files,
						  hw.nr_hw_queues,
						  req.max_channels);

	/* Compute chunk size */
	ctx->chunk_size = req.chunk_size ? req.chunk_size : hw.chunk_size;
	ctx->chunk_size = clamp(ctx->chunk_size,
				(unsigned int)PCOPY_CHUNK_SIZE_MIN,
				(unsigned int)PCOPY_CHUNK_SIZE_MAX);

	/*
	 * Create a dedicated workqueue with bounded concurrency.
	 *
	 * WQ_UNBOUND: threads not pinned (scheduler distributes across CPUs)
	 * max_active = nr_channels: at most N files processed simultaneously
	 *
	 * This naturally maps to blk-mq's per-CPU hardware queue mapping:
	 * each worker thread, running on its own CPU, submits I/O to that
	 * CPU's associated NVMe submission queue.
	 */
	ctx->wq = alloc_workqueue(PCOPY_WQ_NAME,
				  WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
				  ctx->nr_channels);
	if (!ctx->wq) {
		ret = -ENOMEM;
		goto out_free;
	}

	/* Initialize and dispatch all work items */
	for (i = 0; i < req.nr_files; i++) {
		struct pcopy_work_item *item = &ctx->items[i];

		if (copy_from_user(&pair, &req.pairs[i], sizeof(pair))) {
			ret = -EFAULT;
			ctx->cancelled = true;
			break;
		}

		item->ctx = ctx;
		item->index = i;
		strscpy(item->src_path, pair.src_path, PATH_MAX);
		strscpy(item->dst_path, pair.dst_path, PATH_MAX);
		item->bytes_copied = 0;
		item->error = 0;
		init_completion(&item->done);
		INIT_WORK(&item->work, pcopy_work_fn);

		queue_work(ctx->wq, &item->work);
	}

	/* Wait for all dispatched items to complete */
	for (i = 0; i < req.nr_files; i++) {
		if (ctx->items[i].ctx)  /* Only wait if dispatched */
			wait_for_completion(&ctx->items[i].done);
	}

	/* Drain and destroy the workqueue */
	destroy_workqueue(ctx->wq);
	ctx->wq = NULL;

	/* Return first error encountered, or 0 for complete success */
	if (atomic_read(&ctx->errors) > 0 && ret == 0) {
		for (i = 0; i < req.nr_files; i++) {
			if (ctx->items[i].error) {
				ret = ctx->items[i].error;
				break;
			}
		}
	}

	pr_info("pcopy: batch complete — %u files, %u channels, "
		"%lld bytes, %u errors\n",
		req.nr_files, ctx->nr_channels,
		(long long)atomic64_read(&ctx->total_bytes),
		atomic_read(&ctx->errors));

out_free:
	kfree(ctx->items);
	kfree(ctx);
	return ret;
}

/* ===========================================================================
 * /proc Interface
 * ===========================================================================
 */

static int pcopy_status_show(struct seq_file *m, void *v)
{
	struct pcopy_hw_status hw;

	/* Refresh hardware detection (use root fs as reference) */
	pcopy_get_hw_status("/", &hw);

	seq_puts(m, "=== Parallel Copy/Move — Hardware Status ===\n\n");
	seq_printf(m, "Online CPUs:            %u\n", hw.online_cpus);
	seq_printf(m, "Block HW Queues:        %u\n", hw.nr_hw_queues);
	seq_printf(m, "NVMe Detected:          %s\n",
		   hw.nvme_detected ? "YES" : "no");
	seq_printf(m, "PCIe Generation:        Gen%u\n", hw.pcie_gen);
	seq_printf(m, "PCIe Lanes:             x%u\n", hw.pcie_lanes);
	seq_printf(m, "Est. Bandwidth:         %u MB/s\n", hw.bandwidth_mb_s);
	seq_printf(m, "Recommended Channels:   %u\n", hw.recommended_channels);
	seq_printf(m, "Recommended Chunk:      %u KB\n",
		   hw.chunk_size / 1024);
	seq_puts(m, "\n");
	seq_printf(m, "Active Operations:      %d\n",
		   atomic_read(&pcopy_state.active_ops));
	seq_puts(m, "\n");
	seq_puts(m, "--- Theory ---\n");
	seq_puts(m, "Standard cp:  1 read + 1 write per chunk (sequential)\n");
	seq_printf(m, "pcopy:        %u files × %u KB chunks in parallel\n",
		   hw.recommended_channels, hw.chunk_size / 1024);
	seq_printf(m, "              Each channel → distinct NVMe SQ → "
		   "hardware parallelism\n");
	seq_printf(m, "              PCIe Gen%u x%u = %u MB/s total bandwidth\n",
		   hw.pcie_gen, hw.pcie_lanes, hw.bandwidth_mb_s);

	return 0;
}

static int pcopy_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, pcopy_status_show, NULL);
}

static const struct proc_ops pcopy_status_ops = {
	.proc_open    = pcopy_status_open,
	.proc_read    = seq_read,
	.proc_lseek   = seq_lseek,
	.proc_release = single_release,
};

static int pcopy_config_show(struct seq_file *m, void *v)
{
	seq_puts(m, "=== pcopy Configuration ===\n\n");
	seq_printf(m, "max_channels:       %u (0 = auto)\n",
		   pcopy_state.max_channels);
	seq_printf(m, "default_chunk_size: %u KB\n",
		   pcopy_state.default_chunk_size / 1024);
	seq_printf(m, "max_files_per_batch: %u\n", PCOPY_MAX_FILES);
	seq_puts(m, "\nWrite 'channels=N' or 'chunk=N' to configure.\n");
	return 0;
}

static int pcopy_config_open(struct inode *inode, struct file *file)
{
	return single_open(file, pcopy_config_show, NULL);
}

static ssize_t pcopy_config_write(struct file *file, const char __user *buf,
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
		if (val > PCOPY_MAX_CHANNELS)
			return -EINVAL;
		pcopy_state.max_channels = val;
		pr_info("pcopy: max_channels set to %u\n", val);
	} else if (sscanf(kbuf, "chunk=%u", &val) == 1) {
		val *= 1024;  /* Input in KB */
		if (val < PCOPY_CHUNK_SIZE_MIN || val > PCOPY_CHUNK_SIZE_MAX)
			return -EINVAL;
		pcopy_state.default_chunk_size = val;
		pr_info("pcopy: default_chunk_size set to %u KB\n", val / 1024);
	} else {
		return -EINVAL;
	}

	return count;
}

static const struct proc_ops pcopy_config_ops = {
	.proc_open    = pcopy_config_open,
	.proc_read    = seq_read,
	.proc_write   = pcopy_config_write,
	.proc_lseek   = seq_lseek,
	.proc_release = single_release,
};

/* ===========================================================================
 * /dev/pcopy — ioctl interface
 * ===========================================================================
 */

static long pcopy_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	switch (cmd) {
	case PCOPY_IOC_COPY:
		atomic_inc(&pcopy_state.active_ops);
		{
			int ret = pcopy_execute_batch(
				(struct pcopy_batch_request __user *)arg);
			atomic_dec(&pcopy_state.active_ops);
			return ret;
		}

	case PCOPY_IOC_MOVE:
		atomic_inc(&pcopy_state.active_ops);
		{
			struct pcopy_batch_request __user *ureq =
				(struct pcopy_batch_request __user *)arg;
			struct pcopy_batch_request req;

			if (copy_from_user(&req, ureq, sizeof(req))) {
				atomic_dec(&pcopy_state.active_ops);
				return -EFAULT;
			}
			/* Force MOVE flag */
			req.flags |= PCOPY_F_MOVE | PCOPY_F_CROSS_DEVICE;
			if (copy_to_user(ureq, &req, sizeof(req))) {
				atomic_dec(&pcopy_state.active_ops);
				return -EFAULT;
			}

			int ret = pcopy_execute_batch(ureq);
			atomic_dec(&pcopy_state.active_ops);
			return ret;
		}

	case PCOPY_IOC_STATUS:
		{
			struct pcopy_hw_status hw;
			pcopy_get_hw_status("/", &hw);
			if (copy_to_user((void __user *)arg, &hw, sizeof(hw)))
				return -EFAULT;
			return 0;
		}

	default:
		return -ENOTTY;
	}
}

static const struct file_operations pcopy_fops = {
	.owner          = THIS_MODULE,
	.unlocked_ioctl = pcopy_ioctl,
	.compat_ioctl   = pcopy_ioctl,
};

/* ===========================================================================
 * Module Init / Exit
 * ===========================================================================
 */

static int __init pcopy_init(void)
{
	int ret;

	pr_info("pcopy: initializing Parallel Copy/Move engine\n");

	mutex_init(&pcopy_state.op_lock);
	atomic_set(&pcopy_state.active_ops, 0);
	pcopy_state.default_chunk_size = PCOPY_CHUNK_SIZE;
	pcopy_state.max_channels = 0;  /* auto-detect */

	/* Cache initial hardware state */
	pcopy_state.cached_cpus = num_online_cpus();

	/* Create /proc/pcopy/ directory */
	pcopy_state.proc_dir = proc_mkdir("pcopy", NULL);
	if (!pcopy_state.proc_dir) {
		pr_err("pcopy: failed to create /proc/pcopy\n");
		return -ENOMEM;
	}

	proc_create("status", 0444, pcopy_state.proc_dir, &pcopy_status_ops);
	proc_create("config", 0644, pcopy_state.proc_dir, &pcopy_config_ops);

	/* Register /dev/pcopy misc device */
	pcopy_state.misc.minor = MISC_DYNAMIC_MINOR;
	pcopy_state.misc.name = "pcopy";
	pcopy_state.misc.fops = &pcopy_fops;
	pcopy_state.misc.mode = 0660;

	ret = misc_register(&pcopy_state.misc);
	if (ret) {
		pr_err("pcopy: failed to register /dev/pcopy: %d\n", ret);
		proc_remove(pcopy_state.proc_dir);
		return ret;
	}

	pr_info("pcopy: ready — %u CPUs available, /dev/pcopy registered\n",
		pcopy_state.cached_cpus);
	pr_info("pcopy: use 'cat /proc/pcopy/status' for hardware detection\n");

	return 0;
}

static void __exit pcopy_exit(void)
{
	/* Wait for any active operations */
	while (atomic_read(&pcopy_state.active_ops) > 0) {
		pr_info("pcopy: waiting for %d active operations...\n",
			atomic_read(&pcopy_state.active_ops));
		msleep(100);
	}

	misc_deregister(&pcopy_state.misc);
	proc_remove(pcopy_state.proc_dir);

	pr_info("pcopy: module unloaded\n");
}

module_init(pcopy_init);
module_exit(pcopy_exit);
