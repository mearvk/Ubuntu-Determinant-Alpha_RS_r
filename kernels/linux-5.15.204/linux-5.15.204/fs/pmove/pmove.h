/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pmove.h — Parallel Move Engine with Dynamic Lane & Channel Assignment
 *
 * Shares device class speed constants and dynamic assignment policy with pcopy.
 * Dedicated move engine with independent telemetry, abort capability, and
 * move-specific optimizations (atomic rename fast path).
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef __LINUX_PMOVE_H
#define __LINUX_PMOVE_H

#include <linux/types.h>
#include <linux/limits.h>
#include <linux/ioctl.h>

/* Import shared constants from pcopy.h */
#include "../pcopy/pcopy.h"

/* ===========================================================================
 * pmove-specific constants
 * ===========================================================================
 */

#define PMOVE_MAX_CHANNELS      PCOPY_MAX_CHANNELS
#define PMOVE_MAX_FILES         PCOPY_MAX_FILES
#define PMOVE_IOCTL_MAGIC       0xPM

/* Tunable performance bounds */
#define PMOVE_CHUNK_MIN         PCOPY_CHUNK_SIZE_MIN
#define PMOVE_CHUNK_DEFAULT     PCOPY_CHUNK_SIZE
#define PMOVE_CHUNK_MAX         PCOPY_CHUNK_SIZE_MAX

/* ===========================================================================
 * pmove-specific flags (superset of pcopy flags)
 * ===========================================================================
 */

#define PMOVE_F_SYNC            PCOPY_F_SYNC
#define PMOVE_F_PRESERVE        PCOPY_F_PRESERVE
#define PMOVE_F_OVERWRITE       PCOPY_F_OVERWRITE
#define PMOVE_F_FORCE_COPY      (1 << 3)  /* Bypass atomic rename path testing */
#define PMOVE_F_VERBOSE         (1 << 4)  /* Log progress information to dmesg */
#define PMOVE_F_LOW_PRIORITY    PCOPY_F_LOW_PRIORITY
#define PMOVE_F_HIGH_PRIORITY   PCOPY_F_HIGH_PRIORITY

/* ===========================================================================
 * Data Structures
 * ===========================================================================
 */

/**
 * struct pmove_file_pair - Singular path definition packet
 */
struct pmove_file_pair {
	char src_path[PATH_MAX];
	char dst_path[PATH_MAX];
};

/**
 * struct pmove_batch_request - Context specification parameter for mass operations
 */
struct pmove_batch_request {
	__u32 nr_files;                          /* Number of operational payloads */
	__u32 flags;                             /* Combination of PMOVE_F_* flags */
	__u32 max_channels;                      /* Thread throttling (0 = dynamic) */
	__u32 chunk_size;                        /* Buffer chunk bounds (0 = dynamic) */
	struct pmove_file_pair __user *pairs;    /* Pointer to continuous userspace array */
};

/**
 * struct pmove_hw_telemetry - Target hardware environment analysis block
 */
struct pmove_hw_telemetry {
	__u32 online_cpus;
	__u32 nr_hw_queues;
	__u32 pcie_gen;
	__u32 pcie_lanes;
	__u32 estimated_bw_mb_s;
	__u32 device_speed_mb_s;       /* Effective device throughput ceiling */
	__u32 device_class;            /* enum pcopy_device_class */
	__u32 optimal_channels;
	__u32 calculated_chunk_size;
	__u32 is_nvme;
	__u32 cpu_load_pct;            /* Current CPU load at measurement time */
	__u32 assigned_lanes;          /* PCIe lanes assigned for this transfer */
	__u32 throttle_reason;         /* Why channels were limited */
};

/**
 * struct pmove_dynamic_decision - Move-specific assignment decision
 *
 * Includes move optimization metrics: how many files used atomic rename
 * (instant, zero data copy) vs. splice fallback (cross-device).
 */
struct pmove_dynamic_decision {
	__u32 nr_files;
	__u32 device_class;
	__u32 device_speed_mb_s;
	__u32 pcie_bandwidth_mb_s;
	__u32 cpu_load_pct;
	__u32 available_cores;
	__u32 assigned_channels;
	__u32 assigned_lanes;
	__u32 chunk_size;
	__u32 throttle_reason;
	__u32 atomic_renames;          /* Files moved via rename (instant) */
	__u32 splice_fallbacks;        /* Files moved via copy+unlink (cross-device) */
};

/* ===========================================================================
 * IOCTL Mappings
 * ===========================================================================
 */

#define PMOVE_IOC_EXEC_BATCH    _IOW(PMOVE_IOCTL_MAGIC, 1, struct pmove_batch_request)
#define PMOVE_IOC_GET_TELEMETRY _IOR(PMOVE_IOCTL_MAGIC, 2, struct pmove_hw_telemetry)
#define PMOVE_IOC_ABORT_ALL     _IO(PMOVE_IOCTL_MAGIC, 3)
#define PMOVE_IOC_GET_DECISION  _IOR(PMOVE_IOCTL_MAGIC, 4, struct pmove_dynamic_decision)

#endif /* __LINUX_PMOVE_H */
