// SPDX-License-Identifier: GPL-2.0
/*
 * ntuple.c — N-way Redundant File Table with Wear, Pressure & Health
 *
 * Maintains three coordinated tables over an N-layer ("multitude") redundant
 * file table (default 10):
 *
 *   Table 1 (FILE)   - file entries replicated across N layers.
 *   Table 2 (HEALTH) - per-layer/per-region read/write/press/wear + disk health.
 *   Table 3 (ADMIN)  - administrative/state properties (facts + opaque values).
 *
 * Each read derives a QUALITY (how well it met the device spec) and a PRESSURE
 * (instantaneous load appealed to the device). Re-reading a region raises its
 * read-heat; heavy/jarring access records extra impact spread across the N
 * layers. Layer and file-table health are monitored using a green/white/yellow
 * model (no red-alarm), consistent with aptitude/health.
 *
 * ETHICS: Table 3 stores administrative facts and OPERATOR-SUPPLIED opaque
 * values only. The kernel does NOT compute, infer, or judge any person's
 * intelligence, worth, feelings, learning, friendships, or standing.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/spinlock.h>
#include <linux/ktime.h>
#include <linux/miscdevice.h>
#include <linux/uaccess.h>
#include "ntuple.h"

static u32 multitude = NTUPLE_MULT_DEFAULT;
module_param(multitude, uint, 0644);
MODULE_PARM_DESC(multitude, "File-table redundancy factor (1,3,5,10..; default 10)");

static u32 device_class = NTUPLE_DEV_NVME_GEN4;
module_param(device_class, uint, 0644);
MODULE_PARM_DESC(device_class, "Backing storage device class (enum ntuple_device_class)");

static DEFINE_SPINLOCK(ntuple_lock);
static struct ntuple_layer_health *layers;   /* [multitude] Table 2 */
static struct ntuple_admin_state admin;       /* Table 3 */

/* Device spec ceiling (MB/s) for the configured class. */
static u32 ntuple_speed_ceiling(u32 cls)
{
	switch (cls) {
	case NTUPLE_DEV_IDE_HDD:   return NTUPLE_SPEED_IDE_HDD;
	case NTUPLE_DEV_SATA_HDD:  return NTUPLE_SPEED_SATA_HDD;
	case NTUPLE_DEV_SAS_HDD:   return NTUPLE_SPEED_SAS_HDD;
	case NTUPLE_DEV_SATA_SSD:  return NTUPLE_SPEED_SATA_SSD;
	case NTUPLE_DEV_NVME_GEN3: return NTUPLE_SPEED_NVME_GEN3;
	case NTUPLE_DEV_NVME_GEN4: return NTUPLE_SPEED_NVME_GEN4;
	case NTUPLE_DEV_NVME_GEN5: return NTUPLE_SPEED_NVME_GEN5;
	case NTUPLE_DEV_USB2:      return NTUPLE_SPEED_USB2;
	case NTUPLE_DEV_USB3:      return NTUPLE_SPEED_USB3;
	case NTUPLE_DEV_USB4:      return NTUPLE_SPEED_USB4;
	default:                   return NTUPLE_SPEED_SATA_SSD;
	}
}

/*
 * Compute read QUALITY (‰) — how well the observed throughput met the device
 * spec. observed_mbps is the measured MB/s for this read; ceiling is the spec.
 * quality = min(1000, observed*1000/ceiling).
 */
static u32 ntuple_quality(u32 observed_mbps)
{
	u32 ceil = ntuple_speed_ceiling(device_class);
	u64 q;

	if (!ceil)
		return 0;
	q = (u64)observed_mbps * 1000ULL;
	do_div(q, ceil);
	return (q > 1000) ? 1000 : (u32)q;
}

/*
 * Compute read PRESSURE (‰) — instantaneous load appealed to the device,
 * rising with region read-heat and falling with spec headroom. Bounded 0..1000.
 */
static u32 ntuple_pressure(u64 read_heat)
{
	/* Saturating log-ish curve without floats: pressure grows with heat. */
	u32 p = 0;
	u64 h = read_heat;
	while (h && p < 1000) { p += 50; h >>= 1; }   /* +50 per doubling */
	return p;
}

/* Derive a layer's green/white/yellow state from its health value. */
static enum ntuple_health_state ntuple_state_of(u32 disk_health, u32 errors)
{
	if (errors > 0 || disk_health < 600)
		return NTUPLE_YELLOW;          /* attention recommended */
	if (disk_health < 850)
		return NTUPLE_WHITE;           /* informational / normal */
	return NTUPLE_GREEN;               /* healthy / verified */
}

/*
 * Record one access against (layer, region). op: 0=read, 1=write.
 * jarring != 0 marks heavy/abrupt access -> extra impact spread across layers.
 * observed_mbps is the measured throughput for a read (ignored for writes).
 */
void ntuple_record_access(u32 layer, u32 region, int op,
			  u32 observed_mbps, int jarring)
{
	struct ntuple_layer_health *L;
	struct ntuple_region_wear *R;
	unsigned long flags;
	u32 quality, pressure, i;

	if (layer >= multitude || region >= NTUPLE_MAX_REGIONS)
		return;

	spin_lock_irqsave(&ntuple_lock, flags);
	L = &layers[layer];
	R = &L->region[region];

	if (op == 0) {                     /* read */
		R->reads++; L->total_reads++;
		R->read_heat++; L->total_read_heat++;
		quality  = ntuple_quality(observed_mbps);
		pressure = ntuple_pressure(R->read_heat);
		R->last_quality = quality;
		R->last_pressure = pressure;
		if (pressure > R->peak_pressure) R->peak_pressure = pressure;
		/* rolling averages (simple EWMA, shift by 3) */
		L->avg_quality  += (quality  - L->avg_quality)  >> 3;
		L->avg_pressure += (pressure - L->avg_pressure) >> 3;
	} else {                           /* write */
		R->writes++; L->total_writes++;
		R->write_wear++; L->total_write_wear++;
	}

	if (jarring) {
		R->jarring_events++;
		L->total_jarring++;
		/* heavy wear: appeal extra impact across ALL N layers */
		for (i = 0; i < multitude; i++)
			layers[i].total_jarring++;
	}

	/* Derive disk_health: starts 1000, decays with wear + jarring + errors. */
	{
		u64 penalty = (L->total_write_wear >> 6)
			    + (L->total_jarring >> 2)
			    + (u64)L->error_count * 20ULL;
		L->disk_health = (penalty >= 1000) ? 0 : (u32)(1000 - penalty);
		L->state = ntuple_state_of(L->disk_health, L->error_count);
	}

	admin.updated_unix = ktime_get_real_seconds();
	spin_unlock_irqrestore(&ntuple_lock, flags);
}
EXPORT_SYMBOL_GPL(ntuple_record_access);

/* Aggregate file-table health across layers (min of layer healths). */
static u32 ntuple_file_table_health(void)
{
	u32 i, m = 1000;
	for (i = 0; i < multitude; i++)
		if (layers[i].disk_health < m)
			m = layers[i].disk_health;
	return m;
}

static const char *state_str(enum ntuple_health_state s)
{
	switch (s) {
	case NTUPLE_GREEN:  return "GREEN";
	case NTUPLE_WHITE:  return "WHITE";
	case NTUPLE_YELLOW: return "YELLOW";
	default:            return "?";
	}
}

/* ---- /proc/ntuple/status ------------------------------------------------ */
static int status_show(struct seq_file *m, void *v)
{
	u32 fth = ntuple_file_table_health();
	seq_puts(m, "NTUPLE — N-way Redundant File Table\n");
	seq_printf(m, "multitude (redundancy)   : %u layers\n", multitude);
	seq_printf(m, "device speed ceiling     : %u MB/s (class %u)\n",
		   ntuple_speed_ceiling(device_class), device_class);
	seq_printf(m, "file-table health        : %u/1000 (%s)\n",
		   fth, state_str(ntuple_state_of(fth, 0)));
	seq_printf(m, "monitor health           : %s\n", state_str(admin.monitor_health));
	seq_puts(m, "tables                   : 1=FILE  2=HEALTH  3=ADMIN\n");
	return 0;
}

/* ---- /proc/ntuple/health  (Table 2) ------------------------------------- */
static int health_show(struct seq_file *m, void *v)
{
	u32 i;
	seq_puts(m, "layer  state   reads      writes     read_heat  write_wear jarring   quality‰ pressure‰ health‰\n");
	for (i = 0; i < multitude; i++) {
		struct ntuple_layer_health *L = &layers[i];
		seq_printf(m, "%-5u  %-6s  %-9llu  %-9llu  %-9llu  %-9llu  %-8llu  %-8u %-9u %u\n",
			   i, state_str(L->state), L->total_reads, L->total_writes,
			   L->total_read_heat, L->total_write_wear, L->total_jarring,
			   L->avg_quality, L->avg_pressure, L->disk_health);
	}
	return 0;
}

/* ---- /proc/ntuple/admin   (Table 3) ------------------------------------- */
static int admin_show(struct seq_file *m, void *v)
{
	int i;
	seq_puts(m, "NTUPLE Table 3 — Administrative / State\n");
	seq_printf(m, "tech_id                  : %llu\n", admin.tech_id);
	seq_printf(m, "monitor_health           : %s\n", state_str(admin.monitor_health));
	seq_printf(m, "table_multitude          : %u\n", admin.table_multitude);
	seq_printf(m, "file_table_health        : %u/1000\n", ntuple_file_table_health());
	seq_printf(m, "admin_table_revision     : %u\n", admin.admin_table_revision);
	seq_printf(m, "created_unix             : %llu\n", admin.created_unix);
	seq_printf(m, "updated_unix             : %llu\n", admin.updated_unix);
	seq_printf(m, "special_use_permit_mask  : 0x%08x\n", admin.special_use_permit_mask);
	seq_puts(m, "operator reference slots (opaque; operator-defined, no kernel meaning):\n");
	for (i = 0; i < 8; i++)
		seq_printf(m, "  slot[%d] %-24s = %d\n", i,
			   admin.operator_ref_label[i][0] ? admin.operator_ref_label[i] : "(unset)",
			   admin.operator_ref[i]);
	return 0;
}

static int status_open(struct inode *i, struct file *f){ return single_open(f, status_show, NULL);} 
static int health_open(struct inode *i, struct file *f){ return single_open(f, health_show, NULL);} 
static int admin_open(struct inode *i, struct file *f){ return single_open(f, admin_show, NULL);} 

static const struct proc_ops status_ops = { .proc_open=status_open, .proc_read=seq_read, .proc_lseek=seq_lseek, .proc_release=single_release };
static const struct proc_ops health_ops = { .proc_open=health_open, .proc_read=seq_read, .proc_lseek=seq_lseek, .proc_release=single_release };
static const struct proc_ops admin_ops  = { .proc_open=admin_open,  .proc_read=seq_read, .proc_lseek=seq_lseek, .proc_release=single_release };

/* ---- /dev/ntuple ioctl (config + admin set/get) ------------------------- */
static long ntuple_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
	void __user *p = (void __user *)arg;
	struct ntuple_config cfg;
	unsigned long flags;

	switch (cmd) {
	case NTUPLE_IOC_SET_CONFIG:
		if (copy_from_user(&cfg, p, sizeof(cfg))) return -EFAULT;
		if (cfg.multitude < NTUPLE_MULT_MIN || cfg.multitude > NTUPLE_MULT_MAX)
			return -EINVAL;
		/* Reconfiguring layer count at runtime requires realloc; kept simple:
		 * only accept a multitude <= the allocated ceiling. */
		spin_lock_irqsave(&ntuple_lock, flags);
		if (cfg.multitude <= NTUPLE_MULT_MAX) {
			multitude = cfg.multitude;
			admin.table_multitude = cfg.multitude;
		}
		device_class = cfg.device_class;
		admin.updated_unix = ktime_get_real_seconds();
		spin_unlock_irqrestore(&ntuple_lock, flags);
		return 0;
	case NTUPLE_IOC_GET_CONFIG:
		cfg.multitude = multitude; cfg.device_class = device_class;
		return copy_to_user(p, &cfg, sizeof(cfg)) ? -EFAULT : 0;
	case NTUPLE_IOC_SET_ADMIN:
		/* Operator sets Table 3 verbatim; kernel assigns no meaning. */
		spin_lock_irqsave(&ntuple_lock, flags);
		if (copy_from_user(&admin, p, sizeof(admin))) {
			spin_unlock_irqrestore(&ntuple_lock, flags);
			return -EFAULT;
		}
		admin.admin_table_revision++;
		admin.updated_unix = ktime_get_real_seconds();
		spin_unlock_irqrestore(&ntuple_lock, flags);
		return 0;
	case NTUPLE_IOC_GET_ADMIN:
		return copy_to_user(p, &admin, sizeof(admin)) ? -EFAULT : 0;
	default:
		return -ENOTTY;
	}
}

static const struct file_operations ntuple_fops = {
	.owner = THIS_MODULE,
	.unlocked_ioctl = ntuple_ioctl,
};
static struct miscdevice ntuple_dev = {
	.minor = MISC_DYNAMIC_MINOR, .name = "ntuple", .fops = &ntuple_fops,
};

static struct proc_dir_entry *ntuple_proc;

static int __init ntuple_init(void)
{
	u32 i;

	if (multitude < NTUPLE_MULT_MIN) multitude = NTUPLE_MULT_MIN;
	if (multitude > NTUPLE_MULT_MAX) multitude = NTUPLE_MULT_MAX;

	layers = kcalloc(NTUPLE_MULT_MAX, sizeof(*layers), GFP_KERNEL);
	if (!layers)
		return -ENOMEM;
	for (i = 0; i < NTUPLE_MULT_MAX; i++) {
		layers[i].layer_index = i;
		layers[i].disk_health = 1000;
		layers[i].state = NTUPLE_GREEN;
		layers[i].avg_quality = 1000;
	}

	memset(&admin, 0, sizeof(admin));
	admin.table_multitude = multitude;
	admin.monitor_health = NTUPLE_GREEN;
	admin.file_table_health = 1000;
	admin.created_unix = admin.updated_unix = ktime_get_real_seconds();

	ntuple_proc = proc_mkdir("ntuple", NULL);
	if (ntuple_proc) {
		proc_create("status", 0444, ntuple_proc, &status_ops);
		proc_create("health", 0444, ntuple_proc, &health_ops);
		proc_create("admin",  0444, ntuple_proc, &admin_ops);
	}
	misc_register(&ntuple_dev);

	pr_info("ntuple: %u-way redundant file table; device ceiling %u MB/s\n",
		multitude, ntuple_speed_ceiling(device_class));
	return 0;
}

static void __exit ntuple_exit(void)
{
	misc_deregister(&ntuple_dev);
	if (ntuple_proc) {
		remove_proc_entry("status", ntuple_proc);
		remove_proc_entry("health", ntuple_proc);
		remove_proc_entry("admin",  ntuple_proc);
		remove_proc_entry("ntuple", NULL);
	}
	kfree(layers);
	pr_info("ntuple: unloaded\n");
}

module_init(ntuple_init);
module_exit(ntuple_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Maximilian Eric Alexander Rupplin von Keffikon / MEARVK LLC");
MODULE_DESCRIPTION("N-way redundant file table with wear, pressure and health (Tables 1/2/3)");
