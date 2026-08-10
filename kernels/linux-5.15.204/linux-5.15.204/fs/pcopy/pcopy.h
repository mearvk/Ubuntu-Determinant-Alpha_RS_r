/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pcopy.h — Parallel Copy/Move with Dynamic Lane & Channel Assignment
 *
 * Dynamic assignment of PCIe lanes and NVMe parallelization based on:
 *   - Overall processor usage (CPU load average)
 *   - Total number of files being copied
 *   - Relative speed constants for storage device classes
 *   - Available PCIe bandwidth vs. device throughput ceiling
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
#define PCOPY_CHUNK_SIZE        (4 * 1024 * 1024)  /* 4MB default chunk */
#define PCOPY_CHUNK_SIZE_MIN    (64 * 1024)        /* 64KB minimum */
#define PCOPY_CHUNK_SIZE_MAX    (64 * 1024 * 1024) /* 64MB maximum */
#define PCOPY_PIPE_BUFS         16      /* Splice pipe buffer count */
#define PCOPY_IOCTL_MAGIC       0xPC

/* ===========================================================================
 * Storage Device Class Speed Constants (MB/s)
 *
 * These relative speed constants represent the practical throughput ceiling
 * for each device class. They are used to judge how many CPU cores and
 * PCIe lanes should be allocated for optimal transfer.
 *
 * The optimizer will not assign more parallelism than the device can absorb.
 * ===========================================================================
 */

/* Rotational storage */
#define PCOPY_SPEED_IDE_HDD           80     /* IDE/PATA hard drive (ATA-133) */
#define PCOPY_SPEED_SATA_HDD          150    /* SATA 7200 RPM spinning disk */
#define PCOPY_SPEED_SAS_HDD           200    /* SAS 10K/15K RPM enterprise */

/* Flash storage — SATA interface */
#define PCOPY_SPEED_SATA_SSD          550    /* SATA III SSD (6 Gbps bus limit) */

/* Flash storage — NVMe interface */
#define PCOPY_SPEED_NVME_GEN3_X4      3500   /* NVMe Gen3 x4 (theoretical ~3940) */
#define PCOPY_SPEED_NVME_GEN4_X4      7000   /* NVMe Gen4 x4 (theoretical ~7880) */
#define PCOPY_SPEED_NVME_GEN5_X4      14000  /* NVMe Gen5 x4 (theoretical ~15760) */

/* External / removable */
#define PCOPY_SPEED_USB2              35     /* USB 2.0 Hi-Speed */
#define PCOPY_SPEED_USB3_GEN1         400    /* USB 3.0 / 3.1 Gen1 (5 Gbps) */
#define PCOPY_SPEED_USB3_GEN2         900    /* USB 3.1 Gen2 / 3.2 Gen2 (10 Gbps) */
#define PCOPY_SPEED_USB4              3000   /* USB4 / Thunderbolt 3 (40 Gbps) */

/* Network-attached (for reference) */
#define PCOPY_SPEED_NFS_1GBE          110    /* NFS over 1GbE */
#define PCOPY_SPEED_NFS_10GBE         1100   /* NFS over 10GbE */

/* PCIe generation bandwidth per lane (MB/s, approximate usable) */
#define PCIE_GEN1_LANE_BW       250
#define PCIE_GEN2_LANE_BW       500
#define PCIE_GEN3_LANE_BW       985
#define PCIE_GEN4_LANE_BW       1969
#define PCIE_GEN5_LANE_BW       3938

/* ===========================================================================
 * Dynamic Assignment Policy Constants
 *
 * These govern how aggressively the engine consumes system resources
 * based on current CPU load and file count.
 * ===========================================================================
 */

/* CPU load thresholds (percentage of total system capacity) */
#define PCOPY_CPU_LOAD_LOW       25    /* System idle: use up to 80% of cores */
#define PCOPY_CPU_LOAD_MEDIUM    50    /* Moderate load: use up to 50% of cores */
#define PCOPY_CPU_LOAD_HIGH      75    /* Heavy load: use up to 25% of cores */
#define PCOPY_CPU_LOAD_CRITICAL  90    /* System stressed: use 1-2 cores only */

/* File count scaling thresholds */
#define PCOPY_FILES_FEW          10    /* Below this: channels = nr_files */
#define PCOPY_FILES_MODERATE     100   /* Ramp channels proportionally */
#define PCOPY_FILES_MANY         1000  /* Full parallelism available */

/* Channel allocation fractions (percentage of available cores) */
#define PCOPY_ALLOC_IDLE         80    /* 80% of cores when system idle */
#define PCOPY_ALLOC_MODERATE     50    /* 50% of cores at moderate load */
#define PCOPY_ALLOC_HEAVY        25    /* 25% of cores at heavy load */
#define PCOPY_ALLOC_CRITICAL     5     /* ~1-2 cores when critical */

/* Minimum/maximum channels regardless of policy */
#define PCOPY_CHANNELS_MIN       1     /* Always at least 1 channel */
#define PCOPY_CHANNELS_FLOOR     2     /* Prefer at least 2 for benefit */

/* ===========================================================================
 * Device Class Enumeration
 * ===========================================================================
 */

enum pcopy_device_class {
	PCOPY_DEV_UNKNOWN = 0,
	PCOPY_DEV_IDE_HDD,
	PCOPY_DEV_SATA_HDD,
	PCOPY_DEV_SAS_HDD,
	PCOPY_DEV_SATA_SSD,
	PCOPY_DEV_NVME_GEN3,
	PCOPY_DEV_NVME_GEN4,
	PCOPY_DEV_NVME_GEN5,
	PCOPY_DEV_USB2,
	PCOPY_DEV_USB3_GEN1,
	PCOPY_DEV_USB3_GEN2,
	PCOPY_DEV_USB4,
	PCOPY_DEV_NFS_1GBE,
	PCOPY_DEV_NFS_10GBE,
	PCOPY_DEV_CLASS_COUNT
};

/* ===========================================================================
 * Flags for batch request
 * ===========================================================================
 */

#define PCOPY_F_SYNC            (1 << 0)    /* fsync after each file */
#define PCOPY_F_PRESERVE        (1 << 1)    /* Preserve permissions/timestamps */
#define PCOPY_F_OVERWRITE       (1 << 2)    /* Overwrite existing destinations */
#define PCOPY_F_MOVE            (1 << 3)    /* Move (copy + unlink source) */
#define PCOPY_F_CROSS_DEVICE    (1 << 4)    /* Allow cross-device copy for move */
#define PCOPY_F_VERBOSE         (1 << 5)    /* Track per-file progress */
#define PCOPY_F_LOW_PRIORITY    (1 << 6)    /* Yield more CPU to other tasks */
#define PCOPY_F_HIGH_PRIORITY   (1 << 7)    /* Minimize transfer time (use more CPU) */

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
	__u32 max_channels;                     /* 0 = auto-detect (dynamic) */
	__u32 chunk_size;                       /* 0 = auto-tune */
	struct pcopy_file_pair __user *pairs;   /* Array of src/dst pairs */
};

/* Hardware and dynamic assignment status report */
struct pcopy_hw_status {
	__u32 online_cpus;
	__u32 nr_hw_queues;            /* From block device */
	__u32 pcie_gen;                /* 1-5 */
	__u32 pcie_lanes;              /* x1, x2, x4, x8, x16 */
	__u32 bandwidth_mb_s;          /* Estimated total PCIe bandwidth */
	__u32 device_speed_mb_s;       /* Effective device throughput ceiling */
	__u32 device_class;            /* enum pcopy_device_class */
	__u32 recommended_channels;    /* Dynamically computed optimal channels */
	__u32 chunk_size;              /* Recommended chunk size */
	__u32 nvme_detected;           /* 1 if NVMe device found on path */
	__u32 cpu_load_pct;            /* Current system CPU load (0-100) */
	__u32 assigned_lanes;          /* PCIe lanes assigned for this transfer */
	__u32 lane_utilization_pct;    /* Estimated lane utilization (0-100) */
};

/* Dynamic assignment decision (internal, also exposed via /proc) */
struct pcopy_dynamic_decision {
	__u32 nr_files;                /* Input: total files in batch */
	__u32 device_class;            /* Detected device class */
	__u32 device_speed_mb_s;       /* Device throughput ceiling */
	__u32 pcie_bandwidth_mb_s;     /* Available PCIe bandwidth */
	__u32 cpu_load_pct;            /* System CPU load at decision time */
	__u32 available_cores;         /* Online CPUs */
	__u32 assigned_channels;       /* Output: channels allocated */
	__u32 assigned_lanes;          /* Output: effective PCIe lanes used */
	__u32 chunk_size;              /* Output: chunk size selected */
	__u32 throttle_reason;         /* 0=none, 1=cpu_load, 2=device_limit, 3=file_count, 4=pcie_bw */
};

/* Throttle reason codes */
#define PCOPY_THROTTLE_NONE          0
#define PCOPY_THROTTLE_CPU_LOAD      1  /* Reduced channels due to CPU pressure */
#define PCOPY_THROTTLE_DEVICE_LIMIT  2  /* Device can't absorb more parallelism */
#define PCOPY_THROTTLE_FILE_COUNT    3  /* Fewer files than potential channels */
#define PCOPY_THROTTLE_PCIE_BW       4  /* PCIe bandwidth is the bottleneck */

/* ===========================================================================
 * ioctl Commands
 * ===========================================================================
 */

#define PCOPY_IOC_COPY          _IOW(PCOPY_IOCTL_MAGIC, 1, struct pcopy_batch_request)
#define PCOPY_IOC_MOVE          _IOW(PCOPY_IOCTL_MAGIC, 2, struct pcopy_batch_request)
#define PCOPY_IOC_STATUS        _IOR(PCOPY_IOCTL_MAGIC, 3, struct pcopy_hw_status)
#define PCOPY_IOC_CANCEL        _IO(PCOPY_IOCTL_MAGIC, 4)
#define PCOPY_IOC_DECISION      _IOR(PCOPY_IOCTL_MAGIC, 5, struct pcopy_dynamic_decision)

#endif /* __LINUX_PCOPY_H */
