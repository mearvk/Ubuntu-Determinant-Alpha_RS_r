/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pcopy.h — Parallel Copy/Move kernel interface
 *
 * This header provides the ioctl definitions and data structures for
 * the pcopy kernel module. Used by both the kernel module and userspace
 * tools (via /dev/pcopy).
 *
 * Copyright (C) 2026 MEARVK LLC
 */
#ifndef _LINUX_PCOPY_H
#define _LINUX_PCOPY_H

#include <linux/types.h>
#include <linux/ioctl.h>
#include <linux/limits.h>

/*
 * PCOPY_IOCTL_MAGIC — unique ioctl type for pcopy operations
 */
#define PCOPY_IOCTL_MAGIC       0xPC

/*
 * Maximum limits
 */
#define PCOPY_MAX_CHANNELS      64      /* Max parallel I/O channels */
#define PCOPY_MAX_FILES         4096    /* Max files per batch */
#define PCOPY_CHUNK_SIZE_MIN    (64 * 1024)         /* 64 KB */
#define PCOPY_CHUNK_SIZE_MAX    (64 * 1024 * 1024)  /* 64 MB */

/*
 * Batch operation flags (PCOPY_F_*)
 */
#define PCOPY_F_SYNC            (1 << 0)  /* fsync after each file copy */
#define PCOPY_F_PRESERVE        (1 << 1)  /* Preserve mode, atime, mtime */
#define PCOPY_F_OVERWRITE       (1 << 2)  /* Overwrite existing destinations */
#define PCOPY_F_MOVE            (1 << 3)  /* Move semantics (copy + unlink) */
#define PCOPY_F_CROSS_DEVICE    (1 << 4)  /* Allow cross-device move (copy fallback) */
#define PCOPY_F_VERBOSE         (1 << 5)  /* Enable per-file progress tracking */

/*
 * struct pcopy_file_pair — one source→destination mapping
 */
struct pcopy_file_pair {
	char src_path[PATH_MAX];    /* Source file path */
	char dst_path[PATH_MAX];    /* Destination file path */
};

/*
 * struct pcopy_batch_request — batch copy/move submission
 *
 * @nr_files:       Number of file pairs in the batch
 * @flags:          Combination of PCOPY_F_* flags
 * @max_channels:   Override for channel count (0 = auto-detect)
 * @chunk_size:     Override for I/O chunk size (0 = auto-tune)
 * @pairs:          Userspace pointer to array of pcopy_file_pair
 *
 * The kernel module will:
 *   1. Detect NVMe hw queues, PCIe bandwidth, and CPU count
 *   2. Compute optimal parallelism: min(cpus, hw_queues, nr_files)
 *   3. Create a bounded workqueue with that many active workers
 *   4. Dispatch all file pairs across the workers
 *   5. Each worker performs splice-based zero-copy I/O
 *   6. Return when all files are complete (or first error if failing)
 */
struct pcopy_batch_request {
	__u32 nr_files;
	__u32 flags;
	__u32 max_channels;
	__u32 chunk_size;
	struct pcopy_file_pair __user *pairs;
};

/*
 * struct pcopy_hw_status — hardware detection report
 *
 * Populated by PCOPY_IOC_STATUS or readable from /proc/pcopy/status.
 * Tells userspace what hardware is available so it can make informed
 * decisions about parallelism.
 */
struct pcopy_hw_status {
	__u32 online_cpus;           /* num_online_cpus() */
	__u32 nr_hw_queues;          /* Block device hardware queue count */
	__u32 pcie_gen;              /* PCIe generation (1-5) */
	__u32 pcie_lanes;            /* PCIe lane width (1,2,4,8,16) */
	__u32 bandwidth_mb_s;        /* Estimated bandwidth in MB/s */
	__u32 recommended_channels;  /* Computed optimal channel count */
	__u32 chunk_size;            /* Recommended chunk size in bytes */
	__u32 nvme_detected;         /* 1 if NVMe device detected */
};

/*
 * ioctl commands
 *
 * PCOPY_IOC_COPY   — Execute parallel copy batch
 * PCOPY_IOC_MOVE   — Execute parallel move batch
 * PCOPY_IOC_STATUS — Query hardware capabilities
 * PCOPY_IOC_CANCEL — Cancel running batch (future use)
 */
#define PCOPY_IOC_COPY    _IOW(PCOPY_IOCTL_MAGIC, 1, struct pcopy_batch_request)
#define PCOPY_IOC_MOVE    _IOW(PCOPY_IOCTL_MAGIC, 2, struct pcopy_batch_request)
#define PCOPY_IOC_STATUS  _IOR(PCOPY_IOCTL_MAGIC, 3, struct pcopy_hw_status)
#define PCOPY_IOC_CANCEL  _IO(PCOPY_IOCTL_MAGIC, 4)

/*
 * PCIe bandwidth per lane (MB/s, unidirectional)
 *
 * These are the usable data rates after encoding overhead:
 *   Gen1: 8b/10b → 250 MB/s per lane
 *   Gen2: 8b/10b → 500 MB/s per lane
 *   Gen3: 128b/130b → 985 MB/s per lane
 *   Gen4: 128b/130b → 1969 MB/s per lane
 *   Gen5: 128b/130b → 3938 MB/s per lane
 *
 * NVMe devices are typically x4:
 *   Gen3 x4 = 3940 MB/s (~3.8 GB/s)
 *   Gen4 x4 = 7876 MB/s (~7.5 GB/s)
 *   Gen5 x4 = 15752 MB/s (~15 GB/s)
 *
 * Channel formula:
 *   channels = min(online_cpus, nr_hw_queues, nr_files)
 *
 * Rationale:
 *   - More channels than CPUs = context switch overhead > benefit
 *   - More channels than HW queues = software queuing only (no HW parallelism)
 *   - More channels than files = idle channels (waste)
 *   - PCIe bandwidth is the hard cap regardless of queue/CPU count
 */

#endif /* _LINUX_PCOPY_H */
