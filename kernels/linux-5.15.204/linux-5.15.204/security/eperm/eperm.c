// SPDX-License-Identifier: GPL-2.0
/*
 * eperm.c - Extended Permission Classes: Trusted & Genius
 *
 * Adds two permission classes above the traditional owner/group/others:
 *   Class 4 (Trusted): Bypasses DAC with light audit trail
 *   Class 5 (Genius):  Bypasses DAC freely, supreme-tier logged for record
 *
 * The system trusts implicitly and wholly. These persons work for the
 * system's benefit. They do not involve down to concepts of restriction.
 * Permission gatekeeping is replaced by enablement and trust.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/list.h>
#include <linux/spinlock.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/uaccess.h>
#include <linux/cred.h>
#include <linux/sched.h>
#include <linux/ktime.h>
#include <linux/namei.h>
#include <linux/eperm.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("Extended Permission Classes - Trusted & Genius Tiers");
MODULE_VERSION("1.0.0");

/* ============================================================
 * Global State
 * ============================================================ */

static LIST_HEAD(eperm_persons);
static DEFINE_SPINLOCK(eperm_persons_lock);

static struct eperm_config eperm_cfg = {
	.enabled = true,
	.log_trusted = true,		/* Minimal: just count */
	.log_genius_high = true,	/* Log supreme-tier for auditor record */
	.genius_log_tier = EPERM_TIER_SUPREME,
};

/* Genius log ring buffer */
static struct eperm_genius_log *genius_log_ring;
static atomic_t genius_log_head = ATOMIC_INIT(0);

/* Proc directory */
static struct proc_dir_entry *eperm_proc_dir;

/* ============================================================
 * Person Registry
 *
 * Persons are registered by UID with a class designation.
 * This is the system's explicit declaration of trust.
 * ============================================================ */

struct eperm_person *eperm_lookup_person(kuid_t uid)
{
	struct eperm_person *person;

	list_for_each_entry(person, &eperm_persons, list) {
		if (uid_eq(person->uid, uid) && person->active)
			return person;
	}
	return NULL;
}

u8 eperm_get_user_class(kuid_t uid)
{
	struct eperm_person *person;
	u8 class = EPERM_CLASS_OTHERS; /* Default */

	spin_lock(&eperm_persons_lock);
	person = eperm_lookup_person(uid);
	if (person)
		class = person->class;
	spin_unlock(&eperm_persons_lock);

	return class;
}

bool eperm_is_trusted(kuid_t uid)
{
	return eperm_get_user_class(uid) >= EPERM_CLASS_TRUSTED;
}

bool eperm_is_genius(kuid_t uid)
{
	return eperm_get_user_class(uid) == EPERM_CLASS_GENIUS;
}

int eperm_register_person(kuid_t uid, u8 class, const char *name)
{
	struct eperm_person *person;

	if (class != EPERM_CLASS_TRUSTED && class != EPERM_CLASS_GENIUS)
		return -EINVAL;

	/* Check if already registered */
	spin_lock(&eperm_persons_lock);
	person = eperm_lookup_person(uid);
	if (person) {
		/* Update class if re-registering */
		person->class = class;
		strncpy(person->name, name, sizeof(person->name) - 1);
		spin_unlock(&eperm_persons_lock);
		pr_info("eperm: Updated %s (uid=%u) to class %d (%s)\n",
			name, from_kuid(&init_user_ns, uid), class,
			class == EPERM_CLASS_GENIUS ? "Genius" : "Trusted");
		return 0;
	}
	spin_unlock(&eperm_persons_lock);

	person = kzalloc(sizeof(*person), GFP_KERNEL);
	if (!person)
		return -ENOMEM;

	person->uid = uid;
	person->class = class;
	strncpy(person->name, name, sizeof(person->name) - 1);
	person->registered = jiffies;
	person->active = true;

	spin_lock(&eperm_persons_lock);
	list_add(&person->list, &eperm_persons);
	spin_unlock(&eperm_persons_lock);

	pr_info("eperm: Registered %s (uid=%u) as class %d (%s)\n",
		name, from_kuid(&init_user_ns, uid), class,
		class == EPERM_CLASS_GENIUS ? "Genius" : "Trusted");
	pr_info("eperm: This person is now trusted implicitly by the system.\n");

	return 0;
}

int eperm_unregister_person(kuid_t uid)
{
	struct eperm_person *person, *tmp;

	spin_lock(&eperm_persons_lock);
	list_for_each_entry_safe(person, tmp, &eperm_persons, list) {
		if (uid_eq(person->uid, uid)) {
			pr_info("eperm: Unregistered %s (uid=%u) from class %d\n",
				person->name,
				from_kuid(&init_user_ns, uid),
				person->class);
			list_del(&person->list);
			kfree(person);
			spin_unlock(&eperm_persons_lock);
			return 0;
		}
	}
	spin_unlock(&eperm_persons_lock);
	return -ENOENT;
}

int eperm_set_active(kuid_t uid, bool active)
{
	struct eperm_person *person;

	spin_lock(&eperm_persons_lock);
	list_for_each_entry(person, &eperm_persons, list) {
		if (uid_eq(person->uid, uid)) {
			person->active = active;
			spin_unlock(&eperm_persons_lock);
			return 0;
		}
	}
	spin_unlock(&eperm_persons_lock);
	return -ENOENT;
}

/* ============================================================
 * Access Tier Classification
 *
 * Determines what "level" of resource is being accessed.
 * Used to decide whether to log Genius access.
 *
 * Tier 0 (Routine): Normal user files, tmp, home directories
 * Tier 1 (Elevated): /etc config files, service directories
 * Tier 2 (High): /etc/shadow, auth configs, network rules
 * Tier 3 (Supreme): Kernel modules, crypto keys, boot, CA certs
 *                   This is the ">180 IQ" tier - logged for auditor
 * ============================================================ */

static const char *supreme_tier_paths[] = {
	"/boot/",
	"/lib/modules/",
	"/etc/ssl/private/",
	"/etc/ssh/ssh_host_",
	"/etc/pki/",
	"/proc/sys/kernel/",
	"/sys/kernel/",
	"/etc/selinux/",
	"/etc/apparmor/",
	"/etc/crypttab",
	"/root/.ssh/",
	"/etc/ca-certificates/",
	NULL
};

static const char *high_tier_paths[] = {
	"/etc/shadow",
	"/etc/gshadow",
	"/etc/sudoers",
	"/etc/passwd",
	"/etc/iptables/",
	"/etc/nftables/",
	"/etc/firewalld/",
	"/etc/pam.d/",
	NULL
};

static const char *elevated_tier_paths[] = {
	"/etc/",
	"/var/lib/",
	"/srv/",
	"/opt/",
	NULL
};

u8 eperm_classify_access_tier(struct inode *inode, const char *path)
{
	int i;

	if (!path)
		return EPERM_TIER_ROUTINE;

	/* Check supreme tier first */
	for (i = 0; supreme_tier_paths[i]; i++) {
		if (strncmp(path, supreme_tier_paths[i],
			    strlen(supreme_tier_paths[i])) == 0)
			return EPERM_TIER_SUPREME;
	}

	/* High tier */
	for (i = 0; high_tier_paths[i]; i++) {
		if (strncmp(path, high_tier_paths[i],
			    strlen(high_tier_paths[i])) == 0)
			return EPERM_TIER_HIGH;
	}

	/* Elevated tier */
	for (i = 0; elevated_tier_paths[i]; i++) {
		if (strncmp(path, elevated_tier_paths[i],
			    strlen(elevated_tier_paths[i])) == 0)
			return EPERM_TIER_ELEVATED;
	}

	return EPERM_TIER_ROUTINE;
}

/* ============================================================
 * Genius Log
 *
 * When a Genius-class person accesses supreme-tier resources,
 * a log entry is created. This is not suspicion — it is
 * institutional record-keeping. The Genius has graduated from
 * audit; this log serves the institution's memory.
 *
 * A good auditor reviews these entries to understand system
 * evolution, not to question the Genius's actions.
 * ============================================================ */

void eperm_genius_log_access(kuid_t uid, const char *path,
			     u8 tier, u8 operation)
{
	struct eperm_genius_log *entry;
	int head;

	if (!genius_log_ring)
		return;

	head = atomic_inc_return(&genius_log_head) % EPERM_GENIUS_LOG_SIZE;
	entry = &genius_log_ring[head];

	entry->timestamp = ktime_get_real();
	entry->uid = uid;
	entry->tier = tier;
	entry->operation = operation;
	strncpy(entry->path, path ? path : "(unknown)",
		sizeof(entry->path) - 1);
	snprintf(entry->note, sizeof(entry->note),
		 "Genius-class access recorded for institutional record. "
		 "Tier %d. Not an investigation item.",
		 tier);
}

/* ============================================================
 * Core Permission Check
 *
 * This is the heart of the extension. Called BEFORE standard
 * DAC checks in the permission path. If the user is class 4
 * or class 5, access is granted immediately.
 *
 * Return values:
 *   0       = access granted (trusted/genius bypass)
 *   -EAGAIN = not a trusted/genius user, fall through to normal DAC
 *   -EACCES = access denied (e.g., suspended person)
 * ============================================================ */

int eperm_check_access(struct user_namespace *mnt_userns,
		       struct inode *inode, int mask)
{
	kuid_t current_uid;
	struct eperm_person *person;
	u8 tier;

	if (!eperm_cfg.enabled)
		return -EAGAIN; /* Fall through to normal DAC */

	current_uid = current_fsuid();

	spin_lock(&eperm_persons_lock);
	person = eperm_lookup_person(current_uid);

	if (!person) {
		spin_unlock(&eperm_persons_lock);
		return -EAGAIN; /* Not in extended classes, use normal DAC */
	}

	if (!person->active) {
		spin_unlock(&eperm_persons_lock);
		return -EAGAIN; /* Suspended, use normal DAC */
	}

	/* ---- CLASS 5: GENIUS ---- */
	if (person->class == EPERM_CLASS_GENIUS) {
		person->access_count++;

		/*
		 * Genius works freely for the system's mutual profit.
		 * Not an audit item. However, supreme-tier access is
		 * logged for institutional record — goes to a good
		 * auditor for review, not as investigation.
		 */
		tier = EPERM_TIER_ROUTINE; /* Default: no log */

		/* We can't easily get path here in all contexts,
		 * but for inode-based checks we classify by mode/ownership */
		if (inode) {
			/* Kernel-owned inodes or system-critical */
			if (uid_eq(inode->i_uid, GLOBAL_ROOT_UID) &&
			    (inode->i_mode & S_ISUID))
				tier = EPERM_TIER_SUPREME;
			else if (uid_eq(inode->i_uid, GLOBAL_ROOT_UID) &&
				 !(inode->i_mode & S_IROTH))
				tier = EPERM_TIER_HIGH;
		}

		if (tier >= eperm_cfg.genius_log_tier) {
			person->high_tier_count++;
			eperm_genius_log_access(current_uid, NULL,
						tier, mask & 0x07);
		}

		spin_unlock(&eperm_persons_lock);
		return 0; /* ACCESS GRANTED - Genius bypasses all DAC */
	}

	/* ---- CLASS 4: TRUSTED ---- */
	if (person->class == EPERM_CLASS_TRUSTED) {
		person->access_count++;

		/*
		 * Trusted person works implicitly without permission barriers.
		 * Simple to audit. Light trail only.
		 */
		if (eperm_cfg.log_trusted) {
			/* Just increment counter - minimal overhead.
			 * The audit is simple because the person is simple
			 * to trace: clear work, clear communication, clear delivery. */
		}

		spin_unlock(&eperm_persons_lock);
		return 0; /* ACCESS GRANTED - Trusted bypasses all DAC */
	}

	spin_unlock(&eperm_persons_lock);
	return -EAGAIN; /* Unknown class, fall through */
}
EXPORT_SYMBOL(eperm_check_access);

/* ============================================================
 * Proc Interface
 *
 * /proc/eperm/persons  - List registered trusted/genius persons
 * /proc/eperm/config   - View/modify configuration
 * /proc/eperm/register - Add a person (write: "uid class name")
 * /proc/eperm/genius_log - Auditor view of genius supreme-tier access
 * ============================================================ */

/* --- /proc/eperm/persons --- */
static int eperm_proc_persons_show(struct seq_file *m, void *v)
{
	struct eperm_person *person;

	seq_printf(m, "=== Extended Permission Registry ===\n");
	seq_printf(m, "%-8s %-10s %-32s %-8s %-12s %-12s\n",
		   "UID", "Class", "Name", "Active", "Accesses", "HighTier");
	seq_printf(m, "──────── ────────── ──────────────────────────────── "
		   "──────── ──────────── ────────────\n");

	spin_lock(&eperm_persons_lock);
	list_for_each_entry(person, &eperm_persons, list) {
		seq_printf(m, "%-8u %-10s %-32s %-8s %-12llu %-12llu\n",
			   from_kuid(&init_user_ns, person->uid),
			   person->class == EPERM_CLASS_GENIUS ? "GENIUS" : "TRUSTED",
			   person->name,
			   person->active ? "yes" : "suspended",
			   person->access_count,
			   person->high_tier_count);
	}
	spin_unlock(&eperm_persons_lock);

	seq_printf(m, "\nNote: Trusted persons are simple to audit. "
		   "Genius persons are graduates of auditor class.\n");
	seq_printf(m, "Neither class involves down to concepts of restriction.\n");

	return 0;
}

static int eperm_proc_persons_open(struct inode *inode, struct file *file)
{
	return single_open(file, eperm_proc_persons_show, NULL);
}

static const struct proc_ops eperm_proc_persons_ops = {
	.proc_open = eperm_proc_persons_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* --- /proc/eperm/register --- */
/*
 * Write format: "<uid> <class> <name>"
 * class: 4 = Trusted, 5 = Genius
 *
 * Example: echo "1000 5 Alice" > /proc/eperm/register
 */
static ssize_t eperm_proc_register_write(struct file *file,
					 const char __user *buf,
					 size_t count, loff_t *ppos)
{
	char kbuf[128];
	unsigned int uid_val;
	unsigned int class_val;
	char name[64] = {0};
	kuid_t uid;
	int ret;

	if (count >= sizeof(kbuf))
		return -EINVAL;

	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';

	ret = sscanf(kbuf, "%u %u %63s", &uid_val, &class_val, name);
	if (ret < 2)
		return -EINVAL;

	if (class_val != EPERM_CLASS_TRUSTED && class_val != EPERM_CLASS_GENIUS)
		return -EINVAL;

	uid = make_kuid(&init_user_ns, uid_val);
	if (!uid_valid(uid))
		return -EINVAL;

	if (name[0] == '\0')
		snprintf(name, sizeof(name), "uid_%u", uid_val);

	ret = eperm_register_person(uid, (u8)class_val, name);
	if (ret < 0)
		return ret;

	return count;
}

static const struct proc_ops eperm_proc_register_ops = {
	.proc_write = eperm_proc_register_write,
};

/* --- /proc/eperm/unregister --- */
static ssize_t eperm_proc_unregister_write(struct file *file,
					   const char __user *buf,
					   size_t count, loff_t *ppos)
{
	char kbuf[32];
	unsigned int uid_val;
	kuid_t uid;

	if (count >= sizeof(kbuf))
		return -EINVAL;

	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';

	if (kstrtouint(kbuf, 10, &uid_val))
		return -EINVAL;

	uid = make_kuid(&init_user_ns, uid_val);
	if (eperm_unregister_person(uid) < 0)
		return -ENOENT;

	return count;
}

static const struct proc_ops eperm_proc_unregister_ops = {
	.proc_write = eperm_proc_unregister_write,
};

/* --- /proc/eperm/genius_log --- */
/*
 * Auditor interface for reviewing Genius supreme-tier access records.
 *
 * Note to auditor: These entries are NOT investigation items. They are
 * institutional records of a person who has graduated from your class.
 * Review for system understanding, not suspicion.
 */
static int eperm_proc_genius_log_show(struct seq_file *m, void *v)
{
	int i, head;
	struct eperm_genius_log *entry;

	seq_printf(m, "=== Genius-Class Access Log (Institutional Record) ===\n");
	seq_printf(m, "This log is for auditor review as institutional memory.\n");
	seq_printf(m, "These are NOT investigation items. The persons logged here\n");
	seq_printf(m, "are graduates of auditor class and work freely for the system.\n");
	seq_printf(m, "════════════════════════════════════════════════════════════\n\n");

	head = atomic_read(&genius_log_head);
	if (head == 0) {
		seq_printf(m, "(No supreme-tier access recorded yet.)\n");
		return 0;
	}

	seq_printf(m, "%-20s %-8s %-4s %-4s %s\n",
		   "Timestamp", "UID", "Tier", "Op", "Path");

	/* Show last 64 entries */
	int start = head > 64 ? head - 64 : 0;
	for (i = start; i < head; i++) {
		entry = &genius_log_ring[i % EPERM_GENIUS_LOG_SIZE];
		seq_printf(m, "%-20lld %-8u %-4d %-4d %s\n",
			   ktime_to_ns(entry->timestamp),
			   from_kuid(&init_user_ns, entry->uid),
			   entry->tier, entry->operation,
			   entry->path);
	}

	seq_printf(m, "\n[%s]\n", "End of institutional record");
	return 0;
}

static int eperm_proc_genius_log_open(struct inode *inode, struct file *file)
{
	return single_open(file, eperm_proc_genius_log_show, NULL);
}

static const struct proc_ops eperm_proc_genius_log_ops = {
	.proc_open = eperm_proc_genius_log_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* --- /proc/eperm/config --- */
static int eperm_proc_config_show(struct seq_file *m, void *v)
{
	seq_printf(m, "=== Extended Permission Configuration ===\n\n");
	seq_printf(m, "enabled          = %s\n", eperm_cfg.enabled ? "yes" : "no");
	seq_printf(m, "log_trusted      = %s\n", eperm_cfg.log_trusted ? "yes" : "no");
	seq_printf(m, "log_genius_high  = %s\n", eperm_cfg.log_genius_high ? "yes" : "no");
	seq_printf(m, "genius_log_tier  = %u (0=routine, 1=elevated, 2=high, 3=supreme)\n",
		   eperm_cfg.genius_log_tier);
	seq_printf(m, "\n");
	seq_printf(m, "PERMISSION CLASS MODEL:\n");
	seq_printf(m, "  Class 1: Owner  (standard UNIX)\n");
	seq_printf(m, "  Class 2: Group  (standard UNIX)\n");
	seq_printf(m, "  Class 3: Others (standard UNIX)\n");
	seq_printf(m, "  Class 4: TRUSTED - implicit access, light audit\n");
	seq_printf(m, "  Class 5: GENIUS  - free access, supreme-tier logged\n");
	seq_printf(m, "\n");
	seq_printf(m, "PHILOSOPHY:\n");
	seq_printf(m, "  Classes 4 and 5 do not involve down to concepts.\n");
	seq_printf(m, "  They communicate and deliver. The system enables\n");
	seq_printf(m, "  and trusts from and to this brand of personal type.\n");
	seq_printf(m, "  They would not contort access or breed author lines.\n");
	seq_printf(m, "  Trust is implicit and whole.\n");

	return 0;
}

static int eperm_proc_config_open(struct inode *inode, struct file *file)
{
	return single_open(file, eperm_proc_config_show, NULL);
}

static const struct proc_ops eperm_proc_config_ops = {
	.proc_open = eperm_proc_config_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* ============================================================
 * Integration Point: Patch to generic_permission()
 *
 * The following demonstrates how eperm_check_access() hooks into
 * the existing permission check path. In fs/namei.c, the call to
 * acl_permission_check() would be preceded by:
 *
 *   ret = eperm_check_access(mnt_userns, inode, mask);
 *   if (ret == 0)
 *       return 0;  // Trusted/Genius: granted immediately
 *   // Otherwise fall through to normal DAC...
 *
 * This leaves the standard permission system entirely intact for
 * classes 1-3 (owner/group/others). Only classes 4-5 bypass.
 * ============================================================ */

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init eperm_module_init(void)
{
	pr_info("eperm: Initializing Extended Permission Classes v1.0.0\n");
	pr_info("eperm: Class 4 (Trusted) + Class 5 (Genius) enabled\n");
	pr_info("eperm: Standard owner/group/others (1-3) unchanged\n");

	/* Allocate genius log ring */
	genius_log_ring = kzalloc(
		sizeof(struct eperm_genius_log) * EPERM_GENIUS_LOG_SIZE,
		GFP_KERNEL);
	if (!genius_log_ring)
		return -ENOMEM;

	/* Create /proc/eperm/ */
	eperm_proc_dir = proc_mkdir("eperm", NULL);
	if (!eperm_proc_dir) {
		kfree(genius_log_ring);
		return -ENOMEM;
	}

	proc_create("persons", 0444, eperm_proc_dir, &eperm_proc_persons_ops);
	proc_create("register", 0200, eperm_proc_dir, &eperm_proc_register_ops);
	proc_create("unregister", 0200, eperm_proc_dir, &eperm_proc_unregister_ops);
	proc_create("genius_log", 0440, eperm_proc_dir, &eperm_proc_genius_log_ops);
	proc_create("config", 0444, eperm_proc_dir, &eperm_proc_config_ops);

	pr_info("eperm: Admin interface at /proc/eperm/\n");
	pr_info("eperm: Register: echo '<uid> <class> <name>' > /proc/eperm/register\n");
	pr_info("eperm:   Class 4 = Trusted (implicit access, simple audit)\n");
	pr_info("eperm:   Class 5 = Genius (free access, graduate of auditor)\n");

	return 0;
}

static void __exit eperm_module_exit(void)
{
	struct eperm_person *person, *tmp;

	pr_info("eperm: Shutting down Extended Permission Classes\n");

	/* Remove proc entries */
	if (eperm_proc_dir)
		proc_remove(eperm_proc_dir);

	/* Free person list */
	spin_lock(&eperm_persons_lock);
	list_for_each_entry_safe(person, tmp, &eperm_persons, list) {
		list_del(&person->list);
		kfree(person);
	}
	spin_unlock(&eperm_persons_lock);

	/* Free genius log */
	kfree(genius_log_ring);

	pr_info("eperm: Shutdown complete\n");
}

module_init(eperm_module_init);
module_exit(eperm_module_exit);
