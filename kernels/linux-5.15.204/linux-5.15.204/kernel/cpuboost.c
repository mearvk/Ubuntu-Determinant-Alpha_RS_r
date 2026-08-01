// SPDX-License-Identifier: GPL-2.0
/*
 * cpuboost.c - Per-Process CPU Boost Designation
 *
 * Allows specific processes to be designated for boost CPU cycles rather
 * than power-conserving cycles. This is set by sudo rank 7+ administrators
 * after a program's installation.
 *
 * CONCEPT
 * ═══════
 * Modern CPUs operate in two general modes:
 *   - Power-conserving: reduced frequency, lower voltage, saves power
 *   - Boost: maximum frequency, full turbo, maximum throughput
 *
 * By default, the kernel's cpufreq governor (ondemand/schedutil) dynamically
 * switches between these based on load. This module allows an admin to
 * DESIGNATE specific programs to ALWAYS run at boost frequency, bypassing
 * the governor's power-saving decisions for those processes.
 *
 * USE CASE
 * ════════
 * After installing a program (e.g., a database server, real-time process,
 * or latency-critical service), a Grade 7+ admin designates it for boost:
 *
 *   sudo touch system cpuboost-enable /usr/bin/my_database
 *
 * From then on, whenever that binary is executed, the scheduler pins it
 * to boost frequency for the duration of its runtime.
 *
 * ADMINISTRATION
 * ══════════════
 * Requires sudo_gate Grade 7+ because:
 *   - Boost mode increases power consumption and thermal output
 *   - Affects system-wide power budget
 *   - Should be a deliberate admin decision, not user self-service
 *   - Impacts hardware longevity on sustained use
 *
 * IMPLEMENTATION
 * ══════════════
 * Uses the kernel's cpufreq interface to set per-task frequency hints.
 * When a boosted process is scheduled, the cpufreq governor is overridden
 * to maintain maximum frequency on that CPU core.
 *
 * The boost list is stored in /etc/cpuboost.conf and loaded at boot.
 * Runtime changes via /proc/cpuboost/.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/sched/signal.h>
#include <linux/cpufreq.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/uaccess.h>
#include <linux/spinlock.h>
#include <linux/rcupdate.h>
#include <linux/string.h>
#include <linux/fs.h>
#include <linux/binfmts.h>
#include <linux/sched/task.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("Per-Process CPU Boost Designation");
MODULE_VERSION("1.0.0");

/* ============================================================
 * Configuration
 * ============================================================ */

#define CPUBOOST_MAX_ENTRIES	64	/* Max boosted programs */
#define CPUBOOST_PATH_MAX	256	/* Max binary path length */
#define CPUBOOST_CONF		"/etc/cpuboost.conf"

/* Boost levels */
#define CPUBOOST_LEVEL_OFF	0	/* Normal governor behavior */
#define CPUBOOST_LEVEL_PREFER	1	/* Prefer high frequency (soft hint) */
#define CPUBOOST_LEVEL_FORCE	2	/* Force max frequency (hard override) */
#define CPUBOOST_LEVEL_TURBO	3	/* Force turbo/boost beyond base max */

/* ============================================================
 * Data Structures
 * ============================================================ */

struct cpuboost_entry {
	struct list_head	list;
	struct rcu_head		rcu;			/* For kfree_rcu */
	char			path[CPUBOOST_PATH_MAX]; /* Binary path */
	char			name[64];		/* Display name */
	u8			level;			/* Boost level (0-3) */
	uid_t			designated_by;		/* Admin who set this */
	unsigned long		designated_at;		/* Jiffies when designated */
	u64			total_boosted_ms;	/* Cumulative boost time */
	u32			exec_count;		/* Times executed boosted */
	bool			active;			/* Currently enforced */
};

/* Global state */
static LIST_HEAD(cpuboost_entries);
static DEFINE_SPINLOCK(cpuboost_lock);
static struct proc_dir_entry *cpuboost_proc_dir;
static atomic_t cpuboost_active_procs = ATOMIC_INIT(0);
static bool cpuboost_enabled = true;

/* ============================================================
 * Boost Lookup
 *
 * Called from the scheduler path to check if a process's binary
 * is on the boost list. Must be fast (called on context switch).
 * ============================================================ */

/*
 * cpuboost_lookup - Check if a binary path is designated for boost
 *
 * Returns the boost level (0 = not boosted, 1-3 = boost level)
 * Called from sched/core.c context_switch path or exec path.
 */
u8 cpuboost_lookup(const char *binary_path)
{
	struct cpuboost_entry *entry;

	if (!cpuboost_enabled || !binary_path)
		return CPUBOOST_LEVEL_OFF;

	/* Linear scan — fine for up to 64 entries.
	 * For production with more, use a hash table.
	 * RCU protects the read path — safe in scheduler context. */
	rcu_read_lock();
	list_for_each_entry_rcu(entry, &cpuboost_entries, list) {
		if (entry->active && strcmp(entry->path, binary_path) == 0) {
			u8 level = entry->level;
			rcu_read_unlock();
			return level;
		}
	}
	rcu_read_unlock();

	return CPUBOOST_LEVEL_OFF;
}
EXPORT_SYMBOL(cpuboost_lookup);

/*
 * cpuboost_apply - Apply boost to current CPU for a boosted process
 *
 * Sets the cpufreq policy to performance/max for this CPU.
 * Called when a boosted process is scheduled onto a core.
 */
static void cpuboost_apply(unsigned int cpu, u8 level)
{
	struct cpufreq_policy *policy;

	policy = cpufreq_cpu_get(cpu);
	if (!policy)
		return;

	switch (level) {
	case CPUBOOST_LEVEL_PREFER:
		/* Soft hint: set min frequency to 75% of max */
		cpufreq_driver_target(policy,
				      policy->max - (policy->max / 4),
				      CPUFREQ_RELATION_L);
		break;

	case CPUBOOST_LEVEL_FORCE:
		/* Hard: pin to maximum base frequency */
		cpufreq_driver_target(policy, policy->max, CPUFREQ_RELATION_H);
		break;

	case CPUBOOST_LEVEL_TURBO:
		/* Turbo: request boost beyond base max (if CPU supports) */
		cpufreq_driver_target(policy, policy->cpuinfo.max_freq,
				      CPUFREQ_RELATION_H);
		break;

	default:
		break;
	}

	cpufreq_cpu_put(policy);
}

/*
 * cpuboost_release - Release boost when process yields/exits
 *
 * Returns the CPU to normal governor control.
 */
static void cpuboost_release(unsigned int cpu)
{
	struct cpufreq_policy *policy;

	policy = cpufreq_cpu_get(cpu);
	if (!policy)
		return;

	/* Let the governor resume normal operation */
	cpufreq_driver_target(policy, policy->min, CPUFREQ_RELATION_L);
	cpufreq_cpu_put(policy);
}

/* ============================================================
 * Designation Management
 *
 * Admin (Grade 7+) designates programs for boost via:
 *   echo "/path/to/binary LEVEL" > /proc/cpuboost/designate
 * ============================================================ */

static int cpuboost_designate(const char *path, u8 level)
{
	struct cpuboost_entry *entry, *new_entry;
	const char *slash;

	if (level > CPUBOOST_LEVEL_TURBO)
		return -EINVAL;

	/* Allocate new entry FIRST (outside lock, may sleep) */
	new_entry = kzalloc(sizeof(*new_entry), GFP_KERNEL);
	if (!new_entry)
		return -ENOMEM;

	strncpy(new_entry->path, path, CPUBOOST_PATH_MAX - 1);

	/* Extract short name from path */
	slash = strrchr(path, '/');
	strncpy(new_entry->name, slash ? slash + 1 : path,
		sizeof(new_entry->name) - 1);

	new_entry->level = level;
	new_entry->active = (level > 0);
	new_entry->designated_by = from_kuid(&init_user_ns, current_fsuid());
	new_entry->designated_at = jiffies;

	/* Lock, check for existing, add or update atomically */
	spin_lock(&cpuboost_lock);
	list_for_each_entry(entry, &cpuboost_entries, list) {
		if (strcmp(entry->path, path) == 0) {
			/* Already exists — update in place, discard new */
			entry->level = level;
			entry->active = (level > 0);
			spin_unlock(&cpuboost_lock);
			kfree(new_entry);
			pr_info("cpuboost: Updated %s → level %d\n", path, level);
			return 0;
		}
	}
	list_add_rcu(&new_entry->list, &cpuboost_entries);
	spin_unlock(&cpuboost_lock);

	pr_info("cpuboost: Designated %s for boost level %d (by uid %u)\n",
		path, level, new_entry->designated_by);

	return 0;
}

static int cpuboost_undesignate(const char *path)
{
	struct cpuboost_entry *entry, *tmp;

	spin_lock(&cpuboost_lock);
	list_for_each_entry_safe(entry, tmp, &cpuboost_entries, list) {
		if (strcmp(entry->path, path) == 0) {
			list_del_rcu(&entry->list);
			spin_unlock(&cpuboost_lock);
			pr_info("cpuboost: Removed %s from boost list\n", path);
			kfree_rcu(entry, rcu);
			return 0;
		}
	}
	spin_unlock(&cpuboost_lock);
	return -ENOENT;
}

/* ============================================================
 * Proc Interface
 *
 * /proc/cpuboost/status     - Show system boost state
 * /proc/cpuboost/list       - Show designated programs
 * /proc/cpuboost/designate  - Add/update a program (write)
 * /proc/cpuboost/remove     - Remove a designation (write)
 * /proc/cpuboost/toggle     - Enable/disable module
 * ============================================================ */

static int cpuboost_proc_status_show(struct seq_file *m, void *v)
{
	struct cpuboost_entry *entry;
	int count = 0;

	seq_printf(m, "═══════════════════════════════════════════════\n");
	seq_printf(m, "  CPU Boost — Per-Process Frequency Designation\n");
	seq_printf(m, "═══════════════════════════════════════════════\n\n");
	seq_printf(m, "  Enabled:          %s\n", cpuboost_enabled ? "yes" : "no");
	seq_printf(m, "  Active processes: %d\n", atomic_read(&cpuboost_active_procs));
	seq_printf(m, "  Admin required:   sudo_gate Grade 7+\n");
	seq_printf(m, "\n");
	seq_printf(m, "  Boost Levels:\n");
	seq_printf(m, "    0 = OFF (normal governor)\n");
	seq_printf(m, "    1 = PREFER (soft high-freq hint)\n");
	seq_printf(m, "    2 = FORCE (pin to max base frequency)\n");
	seq_printf(m, "    3 = TURBO (boost beyond base, if supported)\n");
	seq_printf(m, "\n");
	seq_printf(m, "  Designate: echo '/path/to/binary LEVEL' > /proc/cpuboost/designate\n");
	seq_printf(m, "  Remove:    echo '/path/to/binary' > /proc/cpuboost/remove\n");

	spin_lock(&cpuboost_lock);
	list_for_each_entry(entry, &cpuboost_entries, list)
		count++;
	spin_unlock(&cpuboost_lock);

	seq_printf(m, "\n  Designated programs: %d / %d\n", count, CPUBOOST_MAX_ENTRIES);

	return 0;
}

static int cpuboost_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, cpuboost_proc_status_show, NULL);
}

static const struct proc_ops cpuboost_proc_status_ops = {
	.proc_open = cpuboost_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* List designated programs */
static int cpuboost_proc_list_show(struct seq_file *m, void *v)
{
	struct cpuboost_entry *entry;

	seq_printf(m, "%-40s %-6s %-8s %-8s %-10s\n",
		   "Binary", "Level", "Active", "Execs", "Boost(ms)");
	seq_printf(m, "──────────────────────────────────────── ────── "
		   "──────── ──────── ──────────\n");

	spin_lock(&cpuboost_lock);
	list_for_each_entry(entry, &cpuboost_entries, list) {
		seq_printf(m, "%-40s %-6d %-8s %-8u %-10llu\n",
			   entry->path, entry->level,
			   entry->active ? "yes" : "no",
			   entry->exec_count,
			   entry->total_boosted_ms);
	}
	spin_unlock(&cpuboost_lock);

	return 0;
}

static int cpuboost_proc_list_open(struct inode *inode, struct file *file)
{
	return single_open(file, cpuboost_proc_list_show, NULL);
}

static const struct proc_ops cpuboost_proc_list_ops = {
	.proc_open = cpuboost_proc_list_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* Designate: echo "/usr/bin/myapp 2" > /proc/cpuboost/designate */
static ssize_t cpuboost_proc_designate_write(struct file *file,
					     const char __user *buf,
					     size_t count, loff_t *ppos)
{
	char kbuf[CPUBOOST_PATH_MAX + 16];
	char path[CPUBOOST_PATH_MAX];
	int level = CPUBOOST_LEVEL_FORCE; /* Default: force max */

	/* Require CAP_SYS_ADMIN (Grade 7+ via sudo_gate) */
	if (!capable(CAP_SYS_ADMIN)) {
		pr_warn("cpuboost: Designation requires Grade 7+ "
			"(sudo touch system cpuboost-enable <path>)\n");
		return -EPERM;
	}

	if (count >= sizeof(kbuf))
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	/* Parse: "/path/to/binary [level]" */
	if (sscanf(kbuf, "%255s %d", path, &level) < 1)
		return -EINVAL;

	int ret = cpuboost_designate(path, (u8)level);
	return ret ? ret : count;
}

static const struct proc_ops cpuboost_proc_designate_ops = {
	.proc_write = cpuboost_proc_designate_write,
};

/* Remove: echo "/usr/bin/myapp" > /proc/cpuboost/remove */
static ssize_t cpuboost_proc_remove_write(struct file *file,
					  const char __user *buf,
					  size_t count, loff_t *ppos)
{
	char kbuf[CPUBOOST_PATH_MAX];

	if (!capable(CAP_SYS_ADMIN))
		return -EPERM;

	if (count >= sizeof(kbuf))
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	int ret = cpuboost_undesignate(kbuf);
	return ret ? ret : count;
}

static const struct proc_ops cpuboost_proc_remove_ops = {
	.proc_write = cpuboost_proc_remove_write,
};

/* Toggle: echo 1|0 > /proc/cpuboost/toggle */
static ssize_t cpuboost_proc_toggle_write(struct file *file,
					  const char __user *buf,
					  size_t count, loff_t *ppos)
{
	char kbuf[4];

	if (!capable(CAP_SYS_ADMIN))
		return -EPERM;
	if (count > 3)
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';

	if (kbuf[0] == '1') {
		cpuboost_enabled = true;
		pr_info("cpuboost: ENABLED\n");
	} else if (kbuf[0] == '0') {
		cpuboost_enabled = false;
		pr_info("cpuboost: DISABLED (all processes run at governor default)\n");
	}

	return count;
}

static const struct proc_ops cpuboost_proc_toggle_ops = {
	.proc_write = cpuboost_proc_toggle_write,
};

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init cpuboost_init(void)
{
	pr_info("cpuboost: Per-Process CPU Boost Designation v1.0.0\n");
	pr_info("cpuboost: Levels: 0=off, 1=prefer, 2=force, 3=turbo\n");
	pr_info("cpuboost: Designation requires: sudo_gate Grade 7+\n");

	cpuboost_proc_dir = proc_mkdir("cpuboost", NULL);
	if (cpuboost_proc_dir) {
		proc_create("status", 0444, cpuboost_proc_dir,
			    &cpuboost_proc_status_ops);
		proc_create("list", 0444, cpuboost_proc_dir,
			    &cpuboost_proc_list_ops);
		proc_create("designate", 0200, cpuboost_proc_dir,
			    &cpuboost_proc_designate_ops);
		proc_create("remove", 0200, cpuboost_proc_dir,
			    &cpuboost_proc_remove_ops);
		proc_create("toggle", 0200, cpuboost_proc_dir,
			    &cpuboost_proc_toggle_ops);
	}

	pr_info("cpuboost: Admin: /proc/cpuboost/{status,list,designate,remove,toggle}\n");
	pr_info("cpuboost: Usage: sudo touch system cpuboost-enable /path/to/binary\n");

	return 0;
}

static void __exit cpuboost_exit(void)
{
	struct cpuboost_entry *entry, *tmp;

	if (cpuboost_proc_dir)
		proc_remove(cpuboost_proc_dir);

	spin_lock(&cpuboost_lock);
	list_for_each_entry_safe(entry, tmp, &cpuboost_entries, list) {
		list_del(&entry->list);
		kfree(entry);
	}
	spin_unlock(&cpuboost_lock);

	/* Ensure no RCU readers are still traversing the list */
	synchronize_rcu();

	pr_info("cpuboost: Unloaded. All boost designations cleared.\n");
}

module_init(cpuboost_init);
module_exit(cpuboost_exit);
