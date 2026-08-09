/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pcopy.h — Parallel Copy/Move with NVMe Multi-Queue & PCIe Lane Awareness
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef __LINUX_PCOPY_H
#define __LINUX_PCOPY_H

#include <linux/types.h>
#include <linux/limits.h>
#include <linux/ioctl.h>

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

/* Flags for batch request */
#define PCOPY_F_SYNC            (1 << 0)    /* fsync after each file */
#define PCOPY_F_PRESERVE        (1 << 1)    /* Preserve permissions/timestamps */
#define PCOPY_F_OVERWRITE       (1 << 2)    /* Overwrite existing destinations */
#define PCOPY_F_MOVE            (1 << 3)    /* Move (copy + unlink source) */
#define PCOPY_F_CROSS_DEVICE    (1 << 4)    /* Allow cross-device copy for move */
#define PCOPY_F_VERBOSE         (1 << 5)    /* Track per-file progress */

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

/* ===========================================================================
 * ioctl Commands
 * ===========================================================================
 */

#define PCOPY_IOC_COPY          _IOW(PCOPY_IOCTL_MAGIC, 1, struct pcopy_batch_request)
#define PCOPY_IOC_MOVE          _IOW(PCOPY_IOCTL_MAGIC, 2, struct pcopy_batch_request)
#define PCOPY_IOC_STATUS        _IOR(PCOPY_IOCTL_MAGIC, 3, struct pcopy_hw_status)
#define PCOPY_IOC_CANCEL        _IO(PCOPY_IOCTL_MAGIC, 4)

#endif /* __LINUX_PCOPY_H */
