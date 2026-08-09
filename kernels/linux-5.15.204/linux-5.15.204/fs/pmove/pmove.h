/* SPDX-License-Identifier: GPL-2.0 */
/*
 * pmove.h — Parallel Move Engine with NVMe MQ & PCIe Topology Awareness
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef __LINUX_PMOVE_H
#define __LINUX_PMOVE_H

#include <linux/types.h>
#include <linux/limits.h>
#include <linux/ioctl.h>

#define PMOVE_MAX_CHANNELS      64      /* Cap concurrency channels */
#define PMOVE_MAX_FILES         4096    /* Upper limit of multi-file pairs */
#define PMOVE_IOCTL_MAGIC       0xPM

/* Tunable performance bounds */
#define PMOVE_CHUNK_MIN         (64 * 1024)         /* 64 KB */
#define PMOVE_CHUNK_DEFAULT     (4 * 1024 * 1024)   /* 4 MB */
#define PMOVE_CHUNK_MAX         (64 * 1024 * 1024)  /* 64 MB */

/* Batch Configuration Flags */
#define PMOVE_F_SYNC            (1 << 0)  /* fsync target before cleaning source */
#define PMOVE_F_PRESERVE        (1 << 1)  /* Retain stat permissions/timestamps */
#define PMOVE_F_OVERWRITE       (1 << 2)  /* Allow overwriting destination nodes */
#define PMOVE_F_FORCE_COPY      (1 << 3)  /* Bypass atomic rename path testing */
#define PMOVE_F_VERBOSE         (1 << 4)  /* Log progress information to dmesg */

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
	__u32 max_channels;                      /* Thread throttling (0 = auto-tune) */
	__u32 chunk_size;                        /* Buffer chunk bounds (0 = auto) */
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
	__u32 optimal_channels;
	__u32 calculated_chunk_size;
	__u32 is_nvme;
};

/* IOCTL Mappings */
#define PMOVE_IOC_EXEC_BATCH    _IOW(PMOVE_IOCTL_MAGIC, 1, struct pmove_batch_request)
#define PMOVE_IOC_GET_TELEMETRY _IOR(PMOVE_IOCTL_MAGIC, 2, struct pmove_hw_telemetry)
#define PMOVE_IOC_ABORT_ALL     _IO(PMOVE_IOCTL_MAGIC, 3)

#endif /* __LINUX_PMOVE_H */
