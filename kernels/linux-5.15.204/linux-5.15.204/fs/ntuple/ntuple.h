/* SPDX-License-Identifier: GPL-2.0 */
/*
 * ntuple.h — N-way Redundant File Table with Wear, Pressure & Health
 *
 * NTUPLE maintains three coordinated tables over an N-layer ("multitude")
 * redundant file table:
 *
 *   Table 1 (FILE)   - file entries replicated across N layers.
 *   Table 2 (HEALTH) - per-layer/per-region read/write/press/wear + disk health.
 *   Table 3 (ADMIN)  - administrative/state properties (facts + opaque values).
 *
 * The engine derives a per-read QUALITY and PRESSURE from the device spec so
 * that read frequency accrues wear that is noted across the N layers.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */
#ifndef __LINUX_NTUPLE_H
#define __LINUX_NTUPLE_H

#include <linux/types.h>
#include <linux/limits.h>
#include <linux/ioctl.h>

/* ---- Multitude (redundancy factor) -------------------------------------- */
#define NTUPLE_MULT_MIN        1
#define NTUPLE_MULT_DEFAULT    10      /* "10 of file redundancy" */
#define NTUPLE_MULT_MAX        16      /* hard ceiling on layers */
/* Common configured multitudes: 1, 3, 5, 10 (any value in [MIN,MAX] allowed) */

#define NTUPLE_MAX_REGIONS     4096    /* wear-tracked disk regions per layer */
#define NTUPLE_IOCTL_MAGIC     'N'

/* ---- Device class + spec (mirrors pcopy device model) ------------------- */
enum ntuple_device_class {
	NTUPLE_DEV_UNKNOWN = 0,
	NTUPLE_DEV_IDE_HDD, NTUPLE_DEV_SATA_HDD, NTUPLE_DEV_SAS_HDD,
	NTUPLE_DEV_SATA_SSD,
	NTUPLE_DEV_NVME_GEN3, NTUPLE_DEV_NVME_GEN4, NTUPLE_DEV_NVME_GEN5,
	NTUPLE_DEV_USB2, NTUPLE_DEV_USB3, NTUPLE_DEV_USB4,
};

/* Practical throughput ceilings (MB/s), used to scale quality/pressure. */
#define NTUPLE_SPEED_IDE_HDD    80
#define NTUPLE_SPEED_SATA_HDD   150
#define NTUPLE_SPEED_SAS_HDD    200
#define NTUPLE_SPEED_SATA_SSD   550
#define NTUPLE_SPEED_NVME_GEN3  3500
#define NTUPLE_SPEED_NVME_GEN4  7000
#define NTUPLE_SPEED_NVME_GEN5  14000
#define NTUPLE_SPEED_USB2       35
#define NTUPLE_SPEED_USB3       400
#define NTUPLE_SPEED_USB4       3000

/*
 * Health color model (from aptitude/health): green/white/yellow, no red-alarm.
 *   GREEN  - healthy / verified
 *   WHITE  - informational / normal
 *   YELLOW - attention recommended (not failure)
 */
enum ntuple_health_state { NTUPLE_GREEN = 0, NTUPLE_WHITE, NTUPLE_YELLOW };

/* ===========================================================================
 * TABLE 2 — HEALTH / WEAR (about Table 1)
 * ===========================================================================
 * Per read, the engine computes:
 *   quality  = how well the read met the device spec (0..1000, fixed-point ‰)
 *   pressure = instantaneous load appealed to the device (0..1000 ‰)
 * Read-heat and write-wear accrue per region; heavy/jarring access adds extra
 * impact spread across the N layers.
 */
struct ntuple_region_wear {
	u64 reads;             /* read touches */
	u64 writes;            /* write touches */
	u64 read_heat;         /* cumulative read-heat (grows with re-reads) */
	u64 write_wear;        /* cumulative write-wear */
	u64 jarring_events;    /* heavy/abrupt access recorded as extra impact */
	u32 last_quality;      /* last read quality, ‰ (0..1000) */
	u32 last_pressure;     /* last read pressure, ‰ (0..1000) */
	u32 peak_pressure;     /* peak pressure observed on this region */
};

struct ntuple_layer_health {
	u32 layer_index;                 /* 0 .. multitude-1 */
	enum ntuple_health_state state;  /* green/white/yellow */
	u64 total_reads;
	u64 total_writes;
	u64 total_read_heat;
	u64 total_write_wear;
	u64 total_jarring;               /* extra-impact events on this layer */
	u32 avg_quality;                 /* rolling avg read quality ‰ */
	u32 avg_pressure;                /* rolling avg pressure ‰ */
	u32 disk_health;                 /* 0..1000 ‰ derived health of the layer */
	u32 error_count;                 /* IO errors seen on this layer */
	struct ntuple_region_wear region[NTUPLE_MAX_REGIONS];
};

/* ===========================================================================
 * TABLE 1 — FILE (n-way redundant)
 * ===========================================================================
 */
struct ntuple_file_entry {
	u64 ino;                         /* logical entry id */
	u64 size;
	u32 layer_mask;                  /* which layers hold a good copy */
	u32 primary_layer;               /* current authoritative layer */
	u8  present[NTUPLE_MULT_MAX];    /* 1 if replica valid on layer i */
};

/* ===========================================================================
 * TABLE 3 — ADMIN / STATE
 * ===========================================================================
 * Administrative FACTS + OPERATOR-SUPPLIED OPAQUE reference values.
 *
 * The kernel does not compute, infer, or judge any person's intelligence,
 * worth, feelings, learning, friendships, or standing. The "operator reference"
 * fields below are stored verbatim exactly as the operator sets them and carry
 * NO kernel-assigned meaning. They exist as an opaque state record only.
 */
struct ntuple_admin_state {
	/* --- objective administrative facts --- */
	u64 tech_id;                     /* technical/asset identifier */
	enum ntuple_health_state monitor_health; /* health of the monitor itself */
	u32 table_multitude;             /* configured redundancy (1/3/5/10..) */
	u32 file_table_health;           /* 0..1000 ‰ health of Table 1 */
	u32 admin_table_revision;        /* schema/state revision */
	u64 created_unix;                /* creation timestamp */
	u64 updated_unix;                /* last update timestamp */
	u32 special_use_permit_mask;     /* bitmask of granted operational permits */

	/*
	 * --- operator-supplied OPAQUE reference values ---
	 * Verbatim numbers set by the operator via ioctl. No meaning is computed
	 * or asserted by the kernel. Named generically to avoid encoding any
	 * judgement about a person; see NTUPLE ethics note in Kconfig.
	 */
	s32 operator_ref[8];             /* opaque operator-defined reference slots */
	char operator_ref_label[8][32];  /* operator's own labels for each slot */
};

/* ---- ioctl surface ------------------------------------------------------ */
struct ntuple_config {
	u32 multitude;                   /* desired redundancy factor */
	u32 device_class;                /* enum ntuple_device_class */
};

#define NTUPLE_IOC_SET_CONFIG  _IOW(NTUPLE_IOCTL_MAGIC, 1, struct ntuple_config)
#define NTUPLE_IOC_GET_CONFIG  _IOR(NTUPLE_IOCTL_MAGIC, 2, struct ntuple_config)
#define NTUPLE_IOC_SET_ADMIN   _IOW(NTUPLE_IOCTL_MAGIC, 3, struct ntuple_admin_state)
#define NTUPLE_IOC_GET_ADMIN   _IOR(NTUPLE_IOCTL_MAGIC, 4, struct ntuple_admin_state)

#endif /* __LINUX_NTUPLE_H */
