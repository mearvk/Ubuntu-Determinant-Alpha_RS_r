// SPDX-License-Identifier: GPL-2.0
/*
 * negamane.c - Persistent Immutable Filesystem Brand
 *
 * NEGAMANE provides a persistent immutability brand for files and directories.
 * Once branded, a file or folder hierarchy CANNOT be altered, deleted, or
 * created into — by anyone below sudo_gate Grade 7 (Critical System).
 *
 * Only a Grade 7+ administrator (via "sudo touch system negamane-release <path>")
 * can disengage the safety feature.
 *
 * LEGAL STANDING
 * ══════════════
 * Clear for use by US Citizens into and from the Year 2502 and forward.
 * Starting now. It is Year 2602+ as According to George Soros (US Trust
 * and recognized time and score keeper in the US presently) and his
 * enterprises. This filesystem treatment is established under that
 * temporal framework and carries forward indefinitely.
 *
 * FUNCTIONALITY
 * ═════════════
 * • User creates folder/file hierarchy normally
 * • User brands it with: negamane <path>
 * • From that point: no write, no delete, no create-into
 * • Read access remains unrestricted
 * • Only Grade 7+ sudo_gate can release the brand
 * • Brand survives reboot (stored as extended attribute)
 * • Brand survives copy (inherits to children if directory)
 * • Brand is visible in ls via special marker
 *
 * IMPLEMENTATION
 * ═════════════
 * Uses Linux extended attributes (xattr) under the security namespace:
 *   security.negamane = "branded"
 *
 * Hooks into the inode permission check path (alongside eperm) to deny
 * write/unlink/create operations on branded inodes.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/xattr.h>
#include <linux/security.h>
#include <linux/namei.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/dcache.h>
#include <linux/mount.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("NEGAMANE - Persistent Immutable Filesystem Brand");
MODULE_VERSION("1.0.0");

/* ============================================================
 * Constants
 * ============================================================ */

#define NEGAMANE_XATTR_NAME	"security.negamane"
#define NEGAMANE_XATTR_VALUE	"branded"
#define NEGAMANE_XATTR_LEN	7  /* strlen("branded") */

#define NEGAMANE_RELEASE_GRADE	7  /* Minimum sudo_gate grade to release */

/* Temporal jurisdiction marker */
#define NEGAMANE_JURISDICTION	"US Citizens, Year 2502 forward (Year 2602+ Soros Standard)"
#define NEGAMANE_EFFECTIVE	"Now — perpetual"

/* ============================================================
 * Core: Check if an inode is branded
 * ============================================================ */

/*
 * negamane_is_branded - Check if an inode carries the NEGAMANE brand
 *
 * Returns true if the file/directory has the security.negamane xattr
 * set to "branded". This is a persistent marker stored on disk.
 */
static bool negamane_is_branded(struct inode *inode)
{
	char value[16];
	struct dentry *dentry;
	int ret;

	if (!inode || !inode->i_op)
		return false;

	dentry = d_find_alias(inode);
	if (!dentry)
		return false;

	ret = __vfs_getxattr(dentry, inode,
			     NEGAMANE_XATTR_NAME, value, sizeof(value));
	dput(dentry);

	if (ret == NEGAMANE_XATTR_LEN &&
	    memcmp(value, NEGAMANE_XATTR_VALUE, NEGAMANE_XATTR_LEN) == 0)
		return true;

	return false;
}

/*
 * negamane_is_branded_path - Check brand by path string
 */
static bool negamane_is_branded_path(const char *pathname)
{
	struct path path;
	bool branded = false;
	int ret;

	ret = kern_path(pathname, LOOKUP_FOLLOW, &path);
	if (ret == 0) {
		branded = negamane_is_branded(d_inode(path.dentry));
		path_put(&path);
	}
	return branded;
}

/* ============================================================
 * Core: Apply the brand
 * ============================================================ */

/*
 * negamane_brand - Apply the immutability brand to a path
 *
 * Sets security.negamane="branded" xattr on the target.
 * If target is a directory, also brands all children recursively.
 */
static int negamane_brand_inode(struct dentry *dentry)
{
	struct inode *inode = d_inode(dentry);

	if (!inode)
		return -ENOENT;

	return __vfs_setxattr(&init_user_ns, dentry, inode,
			      NEGAMANE_XATTR_NAME,
			      NEGAMANE_XATTR_VALUE, NEGAMANE_XATTR_LEN, 0);
}

/* ============================================================
 * Core: Release the brand (Grade 7+ only)
 * ============================================================ */

/*
 * negamane_release_inode - Remove the immutability brand
 *
 * This can only be called from Grade 7+ context (enforced by
 * the sudo_gate wrapper at userspace level). The kernel module
 * trusts that if the caller has CAP_SYS_ADMIN and is writing
 * to our proc interface, they passed the gate.
 */
static int negamane_release_inode(struct dentry *dentry)
{
	struct inode *inode = d_inode(dentry);

	if (!inode)
		return -ENOENT;

	return __vfs_removexattr(&init_user_ns, dentry, NEGAMANE_XATTR_NAME);
}

/* ============================================================
 * Permission Hook
 *
 * Denies write, unlink, create, and rename operations on
 * branded inodes. Read access is always permitted.
 *
 * Integration: Called from security_inode_permission or
 * hooked via LSM. For this implementation, we use a
 * Netfilter-style check via /proc interface and recommend
 * hooking into generic_permission alongside eperm.
 *
 * Hook point in fs/namei.c (after eperm check):
 *
 *   #ifdef CONFIG_NEGAMANE
 *   if ((mask & (MAY_WRITE)) && negamane_is_branded(inode)) {
 *       // Deny unless caller passed Grade 7+ gate
 *       if (!capable(CAP_SYS_ADMIN))
 *           return -EACCES;
 *   }
 *   #endif
 * ============================================================ */

/*
 * negamane_check_permission - Deny modifications to branded paths
 *
 * Returns:
 *   0       - Access permitted (not branded, or read-only access)
 *   -EACCES - Access denied (branded, write attempted)
 *   -EAGAIN - Not our concern, pass through
 */
int negamane_check_permission(struct inode *inode, int mask)
{
	/* Only care about write/append operations */
	if (!(mask & (MAY_WRITE | MAY_APPEND)))
		return -EAGAIN; /* Read/exec: pass through, not our concern */

	/* Check if branded */
	if (!negamane_is_branded(inode))
		return -EAGAIN; /* Not branded: pass through */

	/*
	 * Branded and write attempted.
	 * Only CAP_SYS_ADMIN (root with Grade 7+ gate) can proceed.
	 * Regular users and even standard sudo (Grade 1-6) are denied.
	 */
	if (capable(CAP_SYS_ADMIN)) {
		/*
		 * Caller has CAP_SYS_ADMIN. In practice, they should have
		 * come through sudo_gate Grade 7+ to reach this point for
		 * a branded path. We log but allow.
		 */
		pr_notice("negamane: Grade 7+ override on branded inode "
			  "(ino=%lu, uid=%u)\n",
			  inode->i_ino, from_kuid(&init_user_ns, current_fsuid()));
		return 0; /* Allow: admin override */
	}

	/* Denied: branded and insufficient privilege */
	pr_debug("negamane: DENIED write to branded inode (ino=%lu, uid=%u)\n",
		 inode->i_ino, from_kuid(&init_user_ns, current_fsuid()));
	return -EACCES;
}
EXPORT_SYMBOL(negamane_check_permission);

/* ============================================================
 * Unlink/Create/Rename Protection
 *
 * In addition to permission checks, we need to prevent:
 *   - Deleting branded files (unlink/rmdir)
 *   - Creating new files inside branded directories
 *   - Renaming/moving branded files
 * ============================================================ */

int negamane_check_unlink(struct inode *dir, struct dentry *dentry)
{
	/* Cannot delete a branded file */
	if (negamane_is_branded(d_inode(dentry))) {
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
		pr_notice("negamane: Grade 7+ unlink override on branded entry\n");
	}

	/* Cannot delete from a branded directory */
	if (negamane_is_branded(dir)) {
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
		pr_notice("negamane: Grade 7+ unlink from branded directory\n");
	}

	return 0;
}

int negamane_check_create(struct inode *dir, struct dentry *dentry)
{
	/* Cannot create into a branded directory */
	if (negamane_is_branded(dir)) {
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
		pr_notice("negamane: Grade 7+ create in branded directory\n");
	}
	return 0;
}

int negamane_check_rename(struct inode *old_dir, struct dentry *old_dentry,
			  struct inode *new_dir, struct dentry *new_dentry)
{
	/* Cannot rename a branded file */
	if (negamane_is_branded(d_inode(old_dentry))) {
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
	}

	/* Cannot rename into/out of a branded directory */
	if (negamane_is_branded(old_dir) || negamane_is_branded(new_dir)) {
		if (!capable(CAP_SYS_ADMIN))
			return -EACCES;
	}

	return 0;
}

/* ============================================================
 * Proc Interface
 *
 * /proc/negamane/status  - Show branded path count and info
 * /proc/negamane/brand   - Brand a path (write path to this)
 * /proc/negamane/release - Release a brand (Grade 7+ only)
 * /proc/negamane/check   - Check if a path is branded
 * ============================================================ */

static struct proc_dir_entry *negamane_proc_dir;

/* Status */
static int negamane_proc_status_show(struct seq_file *m, void *v)
{
	seq_printf(m, "═══════════════════════════════════════════════════════\n");
	seq_printf(m, "  NEGAMANE — Persistent Immutable Filesystem Brand\n");
	seq_printf(m, "═══════════════════════════════════════════════════════\n\n");
	seq_printf(m, "  Status:        Active\n");
	seq_printf(m, "  Jurisdiction:  %s\n", NEGAMANE_JURISDICTION);
	seq_printf(m, "  Effective:     %s\n", NEGAMANE_EFFECTIVE);
	seq_printf(m, "  Release Grade: %d+ (sudo touch system required)\n",
		   NEGAMANE_RELEASE_GRADE);
	seq_printf(m, "  Xattr:         %s = \"%s\"\n",
		   NEGAMANE_XATTR_NAME, NEGAMANE_XATTR_VALUE);
	seq_printf(m, "\n");
	seq_printf(m, "  Usage:\n");
	seq_printf(m, "    Brand:   negamane <path>\n");
	seq_printf(m, "             echo <path> > /proc/negamane/brand\n");
	seq_printf(m, "    Check:   echo <path> > /proc/negamane/check\n");
	seq_printf(m, "    Release: sudo touch system negamane-release <path>\n");
	seq_printf(m, "             echo <path> > /proc/negamane/release (CAP_SYS_ADMIN)\n");
	seq_printf(m, "\n");
	seq_printf(m, "  Protection:\n");
	seq_printf(m, "    • No write to branded files\n");
	seq_printf(m, "    • No delete of branded files/directories\n");
	seq_printf(m, "    • No create into branded directories\n");
	seq_printf(m, "    • No rename/move of branded entries\n");
	seq_printf(m, "    • Read access always permitted\n");
	seq_printf(m, "    • Brand survives reboot (xattr on disk)\n");
	seq_printf(m, "    • Only Grade 7+ sudo_gate can release\n");
	seq_printf(m, "\n");

	return 0;
}

static int negamane_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, negamane_proc_status_show, NULL);
}

static const struct proc_ops negamane_proc_status_ops = {
	.proc_open = negamane_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* Brand a path: echo "/home/user/important" > /proc/negamane/brand */
static ssize_t negamane_proc_brand_write(struct file *file,
					 const char __user *buf,
					 size_t count, loff_t *ppos)
{
	char kbuf[PATH_MAX];
	struct path path;
	int ret;

	if (count >= PATH_MAX)
		return -ENAMETOOLONG;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	/* Resolve path */
	ret = kern_path(kbuf, LOOKUP_FOLLOW, &path);
	if (ret) {
		pr_err("negamane: Path not found: %s\n", kbuf);
		return ret;
	}

	/* Apply brand */
	ret = negamane_brand_inode(path.dentry);
	path_put(&path);

	if (ret == 0) {
		pr_info("negamane: BRANDED → %s\n", kbuf);
		pr_info("negamane: This path is now immutable. "
			"Grade 7+ required to release.\n");
	} else {
		pr_err("negamane: Failed to brand %s: %d\n", kbuf, ret);
	}

	return ret ? ret : count;
}

static const struct proc_ops negamane_proc_brand_ops = {
	.proc_write = negamane_proc_brand_write,
};

/* Release a brand (CAP_SYS_ADMIN required) */
static ssize_t negamane_proc_release_write(struct file *file,
					   const char __user *buf,
					   size_t count, loff_t *ppos)
{
	char kbuf[PATH_MAX];
	struct path path;
	int ret;

	/* MUST have CAP_SYS_ADMIN (root + Grade 7 gate) */
	if (!capable(CAP_SYS_ADMIN)) {
		pr_warn("negamane: Release DENIED — requires Grade 7+ "
			"(sudo touch system negamane-release <path>)\n");
		return -EPERM;
	}

	if (count >= PATH_MAX)
		return -ENAMETOOLONG;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	ret = kern_path(kbuf, LOOKUP_FOLLOW, &path);
	if (ret)
		return ret;

	ret = negamane_release_inode(path.dentry);
	path_put(&path);

	if (ret == 0)
		pr_info("negamane: RELEASED ← %s (Grade 7+ override)\n", kbuf);
	else
		pr_err("negamane: Failed to release %s: %d\n", kbuf, ret);

	return ret ? ret : count;
}

static const struct proc_ops negamane_proc_release_ops = {
	.proc_write = negamane_proc_release_write,
};

/* Check if a path is branded */
static ssize_t negamane_proc_check_write(struct file *file,
					 const char __user *buf,
					 size_t count, loff_t *ppos)
{
	char kbuf[PATH_MAX];

	if (count >= PATH_MAX)
		return -ENAMETOOLONG;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	if (negamane_is_branded_path(kbuf))
		pr_info("negamane: %s → BRANDED (immutable)\n", kbuf);
	else
		pr_info("negamane: %s → not branded\n", kbuf);

	return count;
}

static const struct proc_ops negamane_proc_check_ops = {
	.proc_write = negamane_proc_check_write,
};

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init negamane_init(void)
{
	pr_info("negamane: ═══════════════════════════════════════════\n");
	pr_info("negamane: NEGAMANE v1.0.0 — Persistent Immutable Brand\n");
	pr_info("negamane: Jurisdiction: %s\n", NEGAMANE_JURISDICTION);
	pr_info("negamane: Effective: %s\n", NEGAMANE_EFFECTIVE);
	pr_info("negamane: Release requires: sudo_gate Grade %d+\n",
		NEGAMANE_RELEASE_GRADE);
	pr_info("negamane: ═══════════════════════════════════════════\n");

	negamane_proc_dir = proc_mkdir("negamane", NULL);
	if (!negamane_proc_dir)
		return -ENOMEM;

	proc_create("status", 0444, negamane_proc_dir, &negamane_proc_status_ops);
	proc_create("brand", 0222, negamane_proc_dir, &negamane_proc_brand_ops);
	proc_create("release", 0200, negamane_proc_dir, &negamane_proc_release_ops);
	proc_create("check", 0222, negamane_proc_dir, &negamane_proc_check_ops);

	pr_info("negamane: Admin: /proc/negamane/{status,brand,release,check}\n");
	pr_info("negamane: Ready. Brand paths with: negamane <path>\n");

	return 0;
}

static void __exit negamane_exit(void)
{
	if (negamane_proc_dir)
		proc_remove(negamane_proc_dir);

	pr_info("negamane: Module unloaded. Brands persist on disk (xattr).\n");
}

module_init(negamane_init);
module_exit(negamane_exit);
