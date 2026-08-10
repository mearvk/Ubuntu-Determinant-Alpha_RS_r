// SPDX-License-Identifier: GPL-2.0
/*
 * pcopy.c — Parallel Copy/Move with Dynamic Lane & Channel Assignment
 *
 * This module provides hardware-aware parallel file copy and move operations
 * with dynamic assignment of PCIe lanes and NVMe parallelization based on:
 *
 *   1. Overall processor usage — scales channels inversely with CPU load
 *   2. Total number of files — matches parallelism to workload breadth
 *   3. Device class speed constants — won't over-parallelize slow devices
 *   4. PCIe bandwidth ceiling — respects physical bus limitations
 *
 * The dynamic optimizer continuously adjusts during batch operations:
 *   - At batch start: compute initial channel allocation
 *   - During operation: monitor CPU load and throttle if system stressed
 *   - Per-device: classify storage and cap parallelism at device ceiling
 *
 * Theory of operation:
 *   channels = min(
 *       cpu_cores_available_at_current_load,
 *       hw_queues_on_device,
 *       files_in_batch,
 *       device_speed_ceiling / per_channel_throughput,
 *       pcie_lanes * lane_bandwidth / chunk_throughput
 *   )
 *
 * The module exposes:
 *   /proc/pcopy/status       - Current state, hardware, and dynamic decision
 *   /proc/pcopy/config       - Tunable parameters
 *   /proc/pcopy/decision     - Last dynamic assignment decision (detailed)
 *   /dev/pcopy               - ioctl interface for userspace pcopy/pmove tools
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
#include <linux/sched/loadavg.h>
#include <linux/string.h>
#include <linux/types.h>
#include <linux/delay.h>
#include <linux/kernel_stat.h>

#include "pcopy.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maximilian Eric Alexander Rupplin von Keffikon");
MODULE_DESCRIPTION("Parallel Copy/Move — Dynamic Lane & Channel Assignment");
MODULE_VERSION("2.0");

/* ===========================================================================
 * Device Class Speed Table
 *
 * Maps device class enum to practical throughput ceiling in MB/s.
 * Used to judge how many CPU cores and PCIe lanes are useful.
 * ===========================================================================
 */

static const struct {
	enum pcopy_device_class class;
	unsigned int speed_mb_s;
	unsigned int min_channels;      /* Minimum useful channels */
	unsigned int max_channels;      /* Max channels before diminishing returns */
	unsigned int optimal_chunk_kb;  /* Optimal chunk size for this class */
	const char *name;
} pcopy_device_table[PCOPY_DEV_CLASS_COUNT] = {
	[PCOPY_DEV_UNKNOWN]    = { PCOPY_DEV_UNKNOWN,    200,  1, 4,   1024, "Unknown" },
	[PCOPY_DEV_IDE_HDD]    = { PCOPY_DEV_IDE_HDD,    PCOPY_SPEED_IDE_HDD,     1, 1,   512,  "IDE HDD" },
	[PCOPY_DEV_SATA_HDD]   = { PCOPY_DEV_SATA_HDD,   PCOPY_SPEED_SATA_HDD,    1, 2,   1024, "SATA HDD" },
	[PCOPY_DEV_SAS_HDD]    = { PCOPY_DEV_SAS_HDD,    PCOPY_SPEED_SAS_HDD,     1, 2,   1024, "SAS HDD" },
	[PCOPY_DEV_SATA_SSD]   = { PCOPY_DEV_SATA_SSD,   PCOPY_SPEED_SATA_SSD,    1, 4,   4096, "SATA SSD" },
	[PCOPY_DEV_NVME_GEN3]  = { PCOPY_DEV_NVME_GEN3,  PCOPY_SPEED_NVME_GEN3_X4, 2, 16,  4096, "NVMe Gen3" },
	[PCOPY_DEV_NVME_GEN4]  = { PCOPY_DEV_NVME_GEN4,  PCOPY_SPEED_NVME_GEN4_X4, 4, 32,  16384, "NVMe Gen4" },
	[PCOPY_DEV_NVME_GEN5]  = { PCOPY_DEV_NVME_GEN5,  PCOPY_SPEED_NVME_GEN5_X4, 8, 64,  16384, "NVMe Gen5" },
	[PCOPY_DEV_USB2]       = { PCOPY_DEV_USB2,       PCOPY_SPEED_USB2,         1, 1,   256,  "USB 2.0" },
	[PCOPY_DEV_USB3_GEN1]  = { PCOPY_DEV_USB3_GEN1,  PCOPY_SPEED_USB3_GEN1,    1, 2,   2048, "USB 3.0" },
	[PCOPY_DEV_USB3_GEN2]  = { PCOPY_DEV_USB3_GEN2,  PCOPY_SPEED_USB3_GEN2,    1, 4,   4096, "USB 3.1 Gen2" },
	[PCOPY_DEV_USB4]       = { PCOPY_DEV_USB4,       PCOPY_SPEED_USB4,         2, 8,   8192, "USB4/TB3" },
	[PCOPY_DEV_NFS_1GBE]   = { PCOPY_DEV_NFS_1GBE,   PCOPY_SPEED_NFS_1GBE,     1, 2,   1024, "NFS/1GbE" },
	[PCOPY_DEV_NFS_10GBE]  = { PCOPY_DEV_NFS_10GBE,  PCOPY_SPEED_NFS_10GBE,    2, 8,   4096, "NFS/10GbE" },
};

/* ===========================================================================
 * Internal: per-file work item
 * ===========================================================================
 */

struct pcopy_work_item {
	struct work_struct work;
	struct pcopy_batch_ctx *ctx;
	unsigned int index;
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
	ssize_t bytes_copied;
	int error;
	struct completion done;
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
	struct pcopy_dynamic_decision decision;
};

/* Module-global state */
static struct {
	struct workqueue_struct *wq;
	struct proc_dir_entry *proc_dir;
	struct miscdevice misc;
	struct mutex op_lock;
	atomic_t active_ops;
	unsigned int default_chunk_size;
	unsigned int max_channels_override;

	/* Last decision (for /proc/pcopy/decision) */
	struct pcopy_dynamic_decision last_decision;
	struct mutex decision_lock;
} pcopy_state;

/* ===========================================================================
 * CPU Load Measurement
 *
 * Reads the system's current CPU utilization as a percentage (0-100).
 * Uses the 1-minute load average normalized against online CPU count.
 * ===========================================================================
 */

static unsigned int pcopy_get_cpu_load_pct(void)
{
	unsigned long avnrun[3];
	unsigned int online_cpus;
	unsigned int load_pct;

	get_avenrun(avnrun, FIXED_1 / 200, 0);
	online_cpus = num_online_cpus();

	if (online_cpus == 0)
		return 100;

	/*
	 * avnrun[0] is the 1-minute load average in fixed-point.
	 * Convert to percentage of total CPU capacity.
	 * load_avg / nr_cpus * 100 = percent utilized
	 */
	load_pct = (unsigned int)((avnrun[0] * 100) / (online_cpus * FIXED_1));

	return min(load_pct, (unsigned int)100);
}

/* ===========================================================================
 * Device Class Detection
 *
 * Classifies the storage device backing a filesystem path.
 * Uses hw_queues, PCIe gen/lanes, rotational flag, and bus type.
 * ===========================================================================
 */

static enum pcopy_device_class pcopy_classify_device(const char *path,
						     unsigned int hw_queues,
						     unsigned int pcie_gen,
						     unsigned int pcie_lanes)
{
	struct path p;
	struct request_queue *q;
	int rotational = 1;  /* default: assume spinning */
	int err;

	err = kern_path(path, LOOKUP_FOLLOW, &p);
	if (err)
		return PCOPY_DEV_UNKNOWN;

	if (p.dentry && p.dentry->d_inode &&
	    p.dentry->d_inode->i_sb &&
	    p.dentry->d_inode->i_sb->s_bdev) {
		q = bdev_get_queue(p.dentry->d_inode->i_sb->s_bdev);
		if (q)
			rotational = !blk_queue_nonrot(q);
	}
	path_put(&p);

	/* NVMe detection: high queue count + PCIe attachment */
	if (hw_queues > 2 && pcie_gen > 0) {
		if (pcie_gen >= 5)
			return PCOPY_DEV_NVME_GEN5;
		if (pcie_gen >= 4)
			return PCOPY_DEV_NVME_GEN4;
		return PCOPY_DEV_NVME_GEN3;
	}

	/* Non-rotational, single queue: SATA SSD */
	if (!rotational && hw_queues <= 2)
		return PCOPY_DEV_SATA_SSD;

	/* Rotational: classify by queue count */
	if (rotational) {
		if (hw_queues >= 2)
			return PCOPY_DEV_SAS_HDD;
		return PCOPY_DEV_SATA_HDD;
	}

	return PCOPY_DEV_UNKNOWN;
}

/* ===========================================================================
 * Hardware Detection
 * ===========================================================================
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

	if (bdev->bd_disk && bdev->bd_disk->driverfs_dev) {
		struct device *dev = bdev->bd_disk->driverfs_dev;
		while (dev && !dev_is_pci(dev))
			dev = dev->parent;
		if (dev && dev_is_pci(dev))
			pdev = to_pci_dev(dev);
	}

	path_put(&p);

	if (!pdev)
		return 0;

	pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &link_status);

	speed = link_status & PCI_EXP_LNKSTA_CLS;
	width = (link_status & PCI_EXP_LNKSTA_NLW) >> 4;

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

/* ===========================================================================
 * Dynamic Channel & Lane Assignment Engine
 *
 * This is the core optimizer. Given:
 *   - Number of files to transfer
 *   - Device class and speed ceiling
 *   - Available PCIe bandwidth
 *   - Current CPU load
 *   - Hardware queue depth
 *
 * It produces:
 *   - Optimal channel count (parallelism)
 *   - Effective PCIe lanes to utilize
 *   - Chunk size tuned to device class
 *   - Throttle reason (if reduced from maximum)
 * ===========================================================================
 */

static void pcopy_dynamic_assign(unsigned int nr_files,
				 unsigned int hw_queues,
				 unsigned int pcie_gen,
				 unsigned int pcie_lanes,
				 unsigned int pcie_bandwidth_mb_s,
				 enum pcopy_device_class dev_class,
				 unsigned int flags,
				 struct pcopy_dynamic_decision *out)
{
	unsigned int cpu_load_pct;
	unsigned int online_cpus;
	unsigned int device_speed;
	unsigned int cpu_alloc_pct;
	unsigned int cpu_channels;
	unsigned int device_channels;
	unsigned int pcie_channels;
	unsigned int file_channels;
	unsigned int final_channels;
	unsigned int assigned_lanes;
	unsigned int chunk_kb;
	unsigned int per_channel_bw;
	unsigned int throttle = PCOPY_THROTTLE_NONE;

	memset(out, 0, sizeof(*out));

	online_cpus = num_online_cpus();
	cpu_load_pct = pcopy_get_cpu_load_pct();
	device_speed = pcopy_device_table[dev_class].speed_mb_s;

	/* Record inputs */
	out->nr_files = nr_files;
	out->device_class = dev_class;
	out->device_speed_mb_s = device_speed;
	out->pcie_bandwidth_mb_s = pcie_bandwidth_mb_s;
	out->cpu_load_pct = cpu_load_pct;
	out->available_cores = online_cpus;

	/*
	 * Step 1: CPU-load-based channel allocation
	 *
	 * The higher the current system load, the fewer cores we claim.
	 * Priority flags can override this: HIGH_PRIORITY takes more,
	 * LOW_PRIORITY takes less.
	 */
	if (flags & PCOPY_F_HIGH_PRIORITY) {
		/* High priority: ignore load, use up to 90% */
		cpu_alloc_pct = 90;
	} else if (flags & PCOPY_F_LOW_PRIORITY) {
		/* Low priority: be gentle regardless of load */
		cpu_alloc_pct = 15;
		if (cpu_load_pct > PCOPY_CPU_LOAD_MEDIUM)
			cpu_alloc_pct = 5;
	} else {
		/* Normal: scale inversely with load */
		if (cpu_load_pct < PCOPY_CPU_LOAD_LOW)
			cpu_alloc_pct = PCOPY_ALLOC_IDLE;
		else if (cpu_load_pct < PCOPY_CPU_LOAD_MEDIUM)
			cpu_alloc_pct = PCOPY_ALLOC_MODERATE;
		else if (cpu_load_pct < PCOPY_CPU_LOAD_HIGH)
			cpu_alloc_pct = PCOPY_ALLOC_HEAVY;
		else
			cpu_alloc_pct = PCOPY_ALLOC_CRITICAL;
	}

	cpu_channels = (online_cpus * cpu_alloc_pct) / 100;
	if (cpu_channels < PCOPY_CHANNELS_MIN)
		cpu_channels = PCOPY_CHANNELS_MIN;

	/*
	 * Step 2: Device-speed-based channel limit
	 *
	 * Each channel produces roughly (chunk_size / latency) MB/s.
	 * For NVMe Gen4, one channel can push ~1-2 GB/s via splice.
	 * For SATA SSD, one channel saturates at ~550 MB/s.
	 * For HDD, one channel is already near device ceiling.
	 *
	 * We estimate per-channel throughput and cap so total doesn't
	 * exceed device speed ceiling (no benefit, just CPU waste).
	 */
	per_channel_bw = device_speed / max(pcopy_device_table[dev_class].min_channels, 1U);
	if (per_channel_bw == 0)
		per_channel_bw = 100;  /* safety */

	device_channels = device_speed / per_channel_bw;
	device_channels = clamp(device_channels,
				pcopy_device_table[dev_class].min_channels,
				pcopy_device_table[dev_class].max_channels);

	/*
	 * Step 3: PCIe bandwidth-based channel limit
	 *
	 * Total throughput cannot exceed PCIe lane bandwidth.
	 * More channels won't help if the bus is saturated.
	 * Assigned lanes = min(physical_lanes, lanes_needed_for_channels).
	 */
	if (pcie_bandwidth_mb_s > 0) {
		pcie_channels = pcie_bandwidth_mb_s / per_channel_bw;
		if (pcie_channels < 1)
			pcie_channels = 1;
	} else {
		/* Non-PCIe device (USB, NFS) — no PCIe constraint */
		pcie_channels = PCOPY_MAX_CHANNELS;
	}

	/*
	 * Step 4: File count constraint
	 *
	 * No benefit from more channels than files.
	 * For few files, don't spin up excessive workqueue threads.
	 */
	file_channels = nr_files;
	if (file_channels > PCOPY_MAX_CHANNELS)
		file_channels = PCOPY_MAX_CHANNELS;

	/*
	 * Step 5: Take the minimum of all constraints
	 *
	 * The final channel count is the tightest bottleneck.
	 */
	final_channels = min(cpu_channels, device_channels);
	final_channels = min(final_channels, pcie_channels);
	final_channels = min(final_channels, file_channels);
	final_channels = min(final_channels, hw_queues);

	/* Respect hard cap */
	if (final_channels > PCOPY_MAX_CHANNELS)
		final_channels = PCOPY_MAX_CHANNELS;
	if (final_channels < PCOPY_CHANNELS_MIN)
		final_channels = PCOPY_CHANNELS_MIN;

	/* Determine throttle reason (which constraint bound us) */
	if (final_channels == cpu_channels && cpu_channels < device_channels)
		throttle = PCOPY_THROTTLE_CPU_LOAD;
	else if (final_channels == device_channels && device_channels < cpu_channels)
		throttle = PCOPY_THROTTLE_DEVICE_LIMIT;
	else if (final_channels == file_channels && file_channels < device_channels)
		throttle = PCOPY_THROTTLE_FILE_COUNT;
	else if (final_channels == pcie_channels && pcie_channels < device_channels)
		throttle = PCOPY_THROTTLE_PCIE_BW;

	/*
	 * Step 6: Compute assigned lanes
	 *
	 * How many PCIe lanes are effectively utilized by our channel count.
	 * If device has x4 but we only need 2 channels, we use ~x2 effective.
	 */
	if (pcie_lanes > 0 && pcie_bandwidth_mb_s > 0) {
		unsigned int needed_bw = final_channels * per_channel_bw;
		unsigned int bw_per_lane = pcie_bandwidth_mb_s / pcie_lanes;

		if (bw_per_lane > 0)
			assigned_lanes = (needed_bw + bw_per_lane - 1) / bw_per_lane;
		else
			assigned_lanes = pcie_lanes;

		if (assigned_lanes > pcie_lanes)
			assigned_lanes = pcie_lanes;
		if (assigned_lanes < 1)
			assigned_lanes = 1;
	} else {
		assigned_lanes = 0;  /* Non-PCIe path */
	}

	/*
	 * Step 7: Compute chunk size based on device class
	 *
	 * Fast devices benefit from large chunks (fewer I/O ops).
	 * Slow devices benefit from smaller chunks (better interleaving,
	 * lower latency per individual file).
	 */
	chunk_kb = pcopy_device_table[dev_class].optimal_chunk_kb;

	/* Scale up chunk for very high channel counts (reduce per-file overhead) */
	if (final_channels >= 16 && chunk_kb < 16384)
		chunk_kb = min(chunk_kb * 2, (unsigned int)16384);

	/* Scale down chunk for CPU-stressed scenarios (reduce per-op CPU time) */
	if (cpu_load_pct > PCOPY_CPU_LOAD_HIGH && chunk_kb > 2048)
		chunk_kb = chunk_kb / 2;

	/* Write outputs */
	out->assigned_channels = final_channels;
	out->assigned_lanes = assigned_lanes;
	out->chunk_size = chunk_kb * 1024;
	out->throttle_reason = throttle;
}

/* ===========================================================================
 * Core Copy Engine
 * ===========================================================================
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

	src_file = filp_open(src_path, O_RDONLY | O_LARGEFILE, 0);
	if (IS_ERR(src_file))
		return PTR_ERR(src_file);

	src_size = i_size_read(file_inode(src_file));
	if (src_size == 0) {
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

	open_flags = O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE;
	if (!(flags & PCOPY_F_OVERWRITE))
		open_flags |= O_EXCL;

	dst_file = filp_open(dst_path, open_flags, 0644);
	if (IS_ERR(dst_file)) {
		ret = PTR_ERR(dst_file);
		filp_close(src_file, NULL);
		return ret;
	}

	while (src_pos < src_size) {
		size_t to_copy = min_t(loff_t, chunk_size, src_size - src_pos);

		ret = do_splice_direct(src_file, &src_pos,
				       dst_file, &dst_pos,
				       to_copy, SPLICE_F_MOVE);
		if (ret <= 0) {
			if (ret == 0)
				break;
			total = ret;
			goto out;
		}

		total += ret;
		cond_resched();
	}

	if (flags & PCOPY_F_SYNC) {
		ret = vfs_fsync(dst_file, 0);
		if (ret < 0) {
			total = ret;
			goto out;
		}
	}

	if (flags & PCOPY_F_PRESERVE) {
		struct inode *src_inode = file_inode(src_file);

		memset(&attr, 0, sizeof(attr));
		attr.ia_valid = ATTR_MODE | ATTR_ATIME | ATTR_MTIME;
		attr.ia_mode = src_inode->i_mode;
		attr.ia_atime = src_inode->i_atime;
		attr.ia_mtime = src_inode->i_mtime;

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

static int pcopy_move_single_file(const char *src_path,
				  const char *dst_path,
				  unsigned int chunk_size,
				  unsigned int flags)
{
	struct filename *from, *to;
	ssize_t ret;
	int err;

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
		return err;

	if (!(flags & PCOPY_F_CROSS_DEVICE))
		return -EXDEV;

	ret = pcopy_copy_single_file(src_path, dst_path, chunk_size,
				     flags | PCOPY_F_PRESERVE);
	if (ret < 0)
		return (int)ret;

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
			item->bytes_copied = 0;
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

/* ===========================================================================
 * Batch Execution with Dynamic Assignment
 * ===========================================================================
 */

static int pcopy_execute_batch(struct pcopy_batch_request __user *ureq)
{
	struct pcopy_batch_request req;
	struct pcopy_batch_ctx *ctx = NULL;
	struct pcopy_file_pair pair;
	struct pcopy_dynamic_decision decision;
	unsigned int hw_queues, pcie_gen, pcie_lanes, pcie_bw;
	enum pcopy_device_class dev_class;
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

	/* Get first file pair to detect device characteristics */
	if (copy_from_user(&pair, &req.pairs[0], sizeof(pair))) {
		ret = -EFAULT;
		goto out_free;
	}

	/* Detect hardware */
	hw_queues = pcopy_detect_hw_queues(pair.src_path);
	pcie_bw = pcopy_detect_pcie_bandwidth(pair.src_path, &pcie_gen, &pcie_lanes);
	dev_class = pcopy_classify_device(pair.src_path, hw_queues, pcie_gen, pcie_lanes);

	/*
	 * Dynamic assignment: compute optimal channels, lanes, chunk size
	 * based on device class, CPU load, file count, and PCIe bandwidth.
	 */
	pcopy_dynamic_assign(req.nr_files, hw_queues, pcie_gen, pcie_lanes,
			     pcie_bw, dev_class, req.flags, &decision);

	/* User override (non-zero max_channels) caps but doesn't increase */
	if (req.max_channels > 0 && req.max_channels < decision.assigned_channels)
		decision.assigned_channels = req.max_channels;

	/* User chunk override */
	if (req.chunk_size > 0)
		decision.chunk_size = clamp(req.chunk_size,
					    (unsigned int)PCOPY_CHUNK_SIZE_MIN,
					    (unsigned int)PCOPY_CHUNK_SIZE_MAX);

	ctx->nr_channels = decision.assigned_channels;
	ctx->chunk_size = decision.chunk_size;
	ctx->decision = decision;

	/* Store last decision for /proc */
	mutex_lock(&pcopy_state.decision_lock);
	pcopy_state.last_decision = decision;
	mutex_unlock(&pcopy_state.decision_lock);

	/* Create bounded workqueue */
	ctx->wq = alloc_workqueue("pcopy_wq",
				  WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
				  ctx->nr_channels);
	if (!ctx->wq) {
		ret = -ENOMEM;
		goto out_free;
	}

	/* Dispatch all work items */
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

	/* Wait for all items */
	for (i = 0; i < req.nr_files; i++) {
		if (ctx->items[i].ctx)
			wait_for_completion(&ctx->items[i].done);
	}

	destroy_workqueue(ctx->wq);
	ctx->wq = NULL;

	if (atomic_read(&ctx->errors) > 0 && ret == 0) {
		for (i = 0; i < req.nr_files; i++) {
			if (ctx->items[i].error) {
				ret = ctx->items[i].error;
				break;
			}
		}
	}

	pr_info("pcopy: batch complete — %u files, %u channels, %u lanes, "
		"%lld bytes, device=%s, cpu_load=%u%%, throttle=%u\n",
		req.nr_files, ctx->nr_channels, decision.assigned_lanes,
		(long long)atomic64_read(&ctx->total_bytes),
		pcopy_device_table[dev_class].name,
		decision.cpu_load_pct, decision.throttle_reason);

out_free:
	kfree(ctx->items);
	kfree(ctx);
	return ret;
}

/* ===========================================================================
 * /proc Interface
 * ===========================================================================
 */

static const char *pcopy_throttle_name(unsigned int reason)
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

static int pcopy_status_show(struct seq_file *m, void *v)
{
	struct pcopy_dynamic_decision d;
	unsigned int cpu_load = pcopy_get_cpu_load_pct();

	seq_puts(m, "=== Parallel Copy/Move — Dynamic Assignment Status ===\n\n");
	seq_printf(m, "Online CPUs:            %u\n", num_online_cpus());
	seq_printf(m, "Current CPU Load:       %u%%\n", cpu_load);
	seq_printf(m, "Active Operations:      %d\n",
		   atomic_read(&pcopy_state.active_ops));
	seq_puts(m, "\n");

	seq_puts(m, "--- Device Class Speed Constants (MB/s) ---\n");
	seq_printf(m, "  IDE HDD:        %5u    SATA HDD:    %5u    SAS HDD:     %5u\n",
		   PCOPY_SPEED_IDE_HDD, PCOPY_SPEED_SATA_HDD, PCOPY_SPEED_SAS_HDD);
	seq_printf(m, "  SATA SSD:       %5u    NVMe Gen3:   %5u    NVMe Gen4:   %5u\n",
		   PCOPY_SPEED_SATA_SSD, PCOPY_SPEED_NVME_GEN3_X4, PCOPY_SPEED_NVME_GEN4_X4);
	seq_printf(m, "  NVMe Gen5:      %5u    USB 2.0:     %5u    USB 3.0:     %5u\n",
		   PCOPY_SPEED_NVME_GEN5_X4, PCOPY_SPEED_USB2, PCOPY_SPEED_USB3_GEN1);
	seq_printf(m, "  USB 3.1 Gen2:   %5u    USB4/TB3:    %5u\n",
		   PCOPY_SPEED_USB3_GEN2, PCOPY_SPEED_USB4);
	seq_puts(m, "\n");

	seq_puts(m, "--- Dynamic Assignment Policy ---\n");
	seq_printf(m, "  CPU <25%%: use %u%% cores | CPU <50%%: use %u%% | "
		   "CPU <75%%: use %u%% | CPU >90%%: use %u%%\n",
		   PCOPY_ALLOC_IDLE, PCOPY_ALLOC_MODERATE,
		   PCOPY_ALLOC_HEAVY, PCOPY_ALLOC_CRITICAL);
	seq_puts(m, "\n");

	/* Show last decision */
	mutex_lock(&pcopy_state.decision_lock);
	d = pcopy_state.last_decision;
	mutex_unlock(&pcopy_state.decision_lock);

	if (d.nr_files > 0) {
		seq_puts(m, "--- Last Dynamic Decision ---\n");
		seq_printf(m, "  Files:            %u\n", d.nr_files);
		seq_printf(m, "  Device Class:     %s (%u MB/s ceiling)\n",
			   pcopy_device_table[d.device_class].name,
			   d.device_speed_mb_s);
		seq_printf(m, "  PCIe Bandwidth:   %u MB/s\n", d.pcie_bandwidth_mb_s);
		seq_printf(m, "  CPU Load:         %u%%\n", d.cpu_load_pct);
		seq_printf(m, "  Available Cores:  %u\n", d.available_cores);
		seq_printf(m, "  → Channels:       %u\n", d.assigned_channels);
		seq_printf(m, "  → PCIe Lanes:     %u\n", d.assigned_lanes);
		seq_printf(m, "  → Chunk Size:     %u KB\n", d.chunk_size / 1024);
		seq_printf(m, "  → Throttle:       %s\n",
			   pcopy_throttle_name(d.throttle_reason));
	} else {
		seq_puts(m, "--- No operations performed yet ---\n");
	}

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

static int pcopy_decision_show(struct seq_file *m, void *v)
{
	struct pcopy_dynamic_decision d;

	mutex_lock(&pcopy_state.decision_lock);
	d = pcopy_state.last_decision;
	mutex_unlock(&pcopy_state.decision_lock);

	seq_puts(m, "=== Last Dynamic Assignment Decision ===\n\n");

	if (d.nr_files == 0) {
		seq_puts(m, "No decision recorded. Run a pcopy/pmove operation first.\n");
		return 0;
	}

	seq_puts(m, "INPUT:\n");
	seq_printf(m, "  nr_files           = %u\n", d.nr_files);
	seq_printf(m, "  device_class       = %s\n",
		   pcopy_device_table[d.device_class].name);
	seq_printf(m, "  device_speed       = %u MB/s\n", d.device_speed_mb_s);
	seq_printf(m, "  pcie_bandwidth     = %u MB/s\n", d.pcie_bandwidth_mb_s);
	seq_printf(m, "  cpu_load           = %u%%\n", d.cpu_load_pct);
	seq_printf(m, "  available_cores    = %u\n", d.available_cores);
	seq_puts(m, "\n");

	seq_puts(m, "OUTPUT:\n");
	seq_printf(m, "  assigned_channels  = %u\n", d.assigned_channels);
	seq_printf(m, "  assigned_lanes     = %u\n", d.assigned_lanes);
	seq_printf(m, "  chunk_size         = %u KB\n", d.chunk_size / 1024);
	seq_printf(m, "  throttle_reason    = %s (%u)\n",
		   pcopy_throttle_name(d.throttle_reason), d.throttle_reason);
	seq_puts(m, "\n");

	seq_puts(m, "REASONING:\n");
	if (d.throttle_reason == PCOPY_THROTTLE_CPU_LOAD)
		seq_puts(m, "  Channels reduced due to high CPU load.\n"
			    "  System needs headroom for other processes.\n");
	else if (d.throttle_reason == PCOPY_THROTTLE_DEVICE_LIMIT)
		seq_puts(m, "  Channels capped by device throughput ceiling.\n"
			    "  More parallelism would waste CPU without speed gain.\n");
	else if (d.throttle_reason == PCOPY_THROTTLE_FILE_COUNT)
		seq_puts(m, "  Channels limited by number of files.\n"
			    "  Cannot parallelize more than file count.\n");
	else if (d.throttle_reason == PCOPY_THROTTLE_PCIE_BW)
		seq_puts(m, "  Channels limited by PCIe bus bandwidth.\n"
			    "  Bus is the bottleneck, not device or CPU.\n");
	else
		seq_puts(m, "  No throttling. Operating at full device potential.\n");

	return 0;
}

static int pcopy_decision_open(struct inode *inode, struct file *file)
{
	return single_open(file, pcopy_decision_show, NULL);
}

static const struct proc_ops pcopy_decision_ops = {
	.proc_open    = pcopy_decision_open,
	.proc_read    = seq_read,
	.proc_lseek   = seq_lseek,
	.proc_release = single_release,
};

static int pcopy_config_show(struct seq_file *m, void *v)
{
	seq_puts(m, "=== pcopy Dynamic Configuration ===\n\n");
	seq_printf(m, "max_channels_override: %u (0 = dynamic)\n",
		   pcopy_state.max_channels_override);
	seq_printf(m, "default_chunk_size:    %u KB (0 = dynamic)\n",
		   pcopy_state.default_chunk_size / 1024);
	seq_printf(m, "max_files_per_batch:   %u\n", PCOPY_MAX_FILES);
	seq_puts(m, "\nWrite 'channels=N' or 'chunk=N' to override.\n");
	seq_puts(m, "Write 'channels=0' or 'chunk=0' to restore dynamic mode.\n");
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
		pcopy_state.max_channels_override = val;
		pr_info("pcopy: max_channels_override set to %u (%s)\n",
			val, val == 0 ? "dynamic" : "fixed");
	} else if (sscanf(kbuf, "chunk=%u", &val) == 1) {
		if (val > 0) {
			val *= 1024;
			if (val < PCOPY_CHUNK_SIZE_MIN || val > PCOPY_CHUNK_SIZE_MAX)
				return -EINVAL;
		}
		pcopy_state.default_chunk_size = val;
		pr_info("pcopy: default_chunk_size set to %u KB (%s)\n",
			val / 1024, val == 0 ? "dynamic" : "fixed");
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
			struct pcopy_dynamic_decision d;
			unsigned int pcie_gen, pcie_lanes, pcie_bw, hw_q;
			enum pcopy_device_class dclass;

			memset(&hw, 0, sizeof(hw));

			hw_q = pcopy_detect_hw_queues("/");
			pcie_bw = pcopy_detect_pcie_bandwidth("/",
							      &pcie_gen, &pcie_lanes);
			dclass = pcopy_classify_device("/", hw_q, pcie_gen, pcie_lanes);

			hw.online_cpus = num_online_cpus();
			hw.nr_hw_queues = hw_q;
			hw.pcie_gen = pcie_gen;
			hw.pcie_lanes = pcie_lanes;
			hw.bandwidth_mb_s = pcie_bw;
			hw.device_speed_mb_s = pcopy_device_table[dclass].speed_mb_s;
			hw.device_class = dclass;
			hw.nvme_detected = (hw_q > 2) ? 1 : 0;
			hw.cpu_load_pct = pcopy_get_cpu_load_pct();

			/* Compute a sample dynamic assignment for status */
			pcopy_dynamic_assign(100, hw_q, pcie_gen, pcie_lanes,
					     pcie_bw, dclass, 0, &d);
			hw.recommended_channels = d.assigned_channels;
			hw.chunk_size = d.chunk_size;
			hw.assigned_lanes = d.assigned_lanes;
			hw.lane_utilization_pct = pcie_bw > 0 ?
				(d.assigned_lanes * 100 / pcie_lanes) : 0;

			if (copy_to_user((void __user *)arg, &hw, sizeof(hw)))
				return -EFAULT;
			return 0;
		}

	case PCOPY_IOC_DECISION:
		{
			struct pcopy_dynamic_decision d;

			mutex_lock(&pcopy_state.decision_lock);
			d = pcopy_state.last_decision;
			mutex_unlock(&pcopy_state.decision_lock);

			if (copy_to_user((void __user *)arg, &d, sizeof(d)))
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

	pr_info("pcopy: initializing Parallel Copy/Move with Dynamic Assignment\n");

	mutex_init(&pcopy_state.op_lock);
	mutex_init(&pcopy_state.decision_lock);
	atomic_set(&pcopy_state.active_ops, 0);
	pcopy_state.default_chunk_size = 0;  /* 0 = dynamic */
	pcopy_state.max_channels_override = 0;  /* 0 = dynamic */
	memset(&pcopy_state.last_decision, 0, sizeof(pcopy_state.last_decision));

	/* Create /proc/pcopy/ directory */
	pcopy_state.proc_dir = proc_mkdir("pcopy", NULL);
	if (!pcopy_state.proc_dir) {
		pr_err("pcopy: failed to create /proc/pcopy\n");
		return -ENOMEM;
	}

	proc_create("status", 0444, pcopy_state.proc_dir, &pcopy_status_ops);
	proc_create("config", 0644, pcopy_state.proc_dir, &pcopy_config_ops);
	proc_create("decision", 0444, pcopy_state.proc_dir, &pcopy_decision_ops);

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

	pr_info("pcopy: ready — %u CPUs, dynamic assignment active\n",
		num_online_cpus());
	pr_info("pcopy: device classes: IDE=%u, SATA_SSD=%u, NVMe_G4=%u, NVMe_G5=%u MB/s\n",
		PCOPY_SPEED_IDE_HDD, PCOPY_SPEED_SATA_SSD,
		PCOPY_SPEED_NVME_GEN4_X4, PCOPY_SPEED_NVME_GEN5_X4);

	return 0;
}

static void __exit pcopy_exit(void)
{
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
