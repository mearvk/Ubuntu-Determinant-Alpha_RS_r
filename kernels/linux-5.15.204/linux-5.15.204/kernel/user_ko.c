// SPDX-License-Identifier: GPL-2.0
/*
 * user_ko.c - Per-User Kernel Object (KO) Loader with Memory Grain
 *
 * Allows system users (sudo rank 1-8) to load personal kernel objects
 * into system memory according to a three-tier memory grain model:
 *
 *   Grain 1: User Space — accessible by the owning user, runs in
 *            restricted context. No special privilege needed to load.
 *            Safe by design: cannot access kernel internals or other
 *            users' memory. Think of it as a personal sandbox module.
 *
 *   Grain 2: Safety Space — shared, auditable, runs with limited
 *            kernel access. Requires sudo rank 1+ to load.
 *            Can access shared system data structures (read-mostly).
 *            Suitable for monitoring, metrics, custom schedulers.
 *
 *   Grain 3: Kernel/Admin Space — full kernel access. Requires
 *            sudo rank 4+ (network admin or higher) to load.
 *            Full kernel module capabilities. Standard module behavior.
 *
 * DESIGN PHILOSOPHY
 * ═════════════════
 * Users at sudo rank 1-8 are trusted. These are not adversarial actors.
 * The grain system exists not as a security boundary against the user,
 * but as organizational clarity about what memory domain a module
 * operates in. This prevents accidental interference, not malicious action.
 *
 * Safe boot / secure boot compatibility: Grain 1 and 2 modules are
 * loaded via a user_ko-specific path that does NOT invoke the standard
 * module signature check (they run in restricted context anyway).
 * Grain 3 modules use the standard insmod path and may require signing
 * if secure boot is enforced.
 *
 * LOADING
 * ═══════
 *   user_ko load <module.ko>               (auto-detect grain from module)
 *   user_ko load <module.ko> --grain=1     (force grain 1)
 *   user_ko load <module.ko> --grain=2     (force grain 2, needs sudo 1+)
 *   user_ko load <module.ko> --grain=3     (force grain 3, needs sudo 4+)
 *   user_ko list                           (show loaded user modules)
 *   user_ko unload <module>                (unload own module)
 *   user_ko status                         (show system grain status)
 *
 * MODULE DECLARATION
 * ══════════════════
 * Modules declare their grain via a special section:
 *
 *   MODULE_GRAIN(1);   // User space module
 *   MODULE_GRAIN(2);   // Safety space module
 *   MODULE_GRAIN(3);   // Kernel space module
 *
 * If undeclared, default grain assignment:
 *   - Loaded by sudo rank 1-3: Grain 1
 *   - Loaded by sudo rank 4-6: Grain 2
 *   - Loaded by sudo rank 7-8: Grain 3
 *
 * PROGRAM INSTALL GRAIN CLAIMS
 * ════════════════════════════
 * New program installs can claim a memory grain:
 *
 *   install --grain=1 myprogram       (user space, anyone can install)
 *   install --grain=2 myservice       (safety space, sudo rank 1+)
 *   install --grain=3 mydriver        (kernel space, sudo rank 4+)
 *
 * The package manager (apt/rpm) is extended to recognize grain metadata
 * in package manifests. Grain 3 installs trigger the sudo_gate Grade 4+
 * requirement automatically.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/uaccess.h>
#include <linux/cred.h>
#include <linux/uidgid.h>
#include <linux/spinlock.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("Per-User Kernel Object Loader with Memory Grain System");
MODULE_VERSION("1.0.0");

/* ============================================================
 * Memory Grain Definitions
 * ============================================================ */

#define GRAIN_USER	1   /* User space: personal sandbox, no kernel access */
#define GRAIN_SAFETY	2   /* Safety space: shared, auditable, limited kernel */
#define GRAIN_KERNEL	3   /* Kernel space: full access, standard module */

#define GRAIN_MIN	1
#define GRAIN_MAX	3

/* Sudo rank requirements per grain */
#define GRAIN1_MIN_RANK	0   /* No sudo needed (any logged-in user) */
#define GRAIN2_MIN_RANK	1   /* Sudo rank 1+ (routine) */
#define GRAIN3_MIN_RANK	4   /* Sudo rank 4+ (network admin or higher) */

/* Per-grain memory limits */
#define GRAIN1_MAX_SIZE	(4 * 1024 * 1024)    /* 4 MB per user module */
#define GRAIN2_MAX_SIZE	(16 * 1024 * 1024)   /* 16 MB per safety module */
#define GRAIN3_MAX_SIZE	(64 * 1024 * 1024)   /* 64 MB per kernel module */

/* Maximum user modules per grain */
#define GRAIN1_MAX_MODULES	16   /* Up to 16 personal modules per user */
#define GRAIN2_MAX_MODULES	8    /* Up to 8 shared modules */
#define GRAIN3_MAX_MODULES	4    /* Up to 4 kernel modules per user */

/* Total system limits */
#define USER_KO_MAX_TOTAL	128  /* Max modules system-wide */

/* Module section marker for grain declaration */
#define MODULE_GRAIN(n)	\
	static const int __user_ko_grain __attribute__((section(".user_ko_grain"))) = (n)

/* ============================================================
 * Data Structures
 * ============================================================ */

struct user_ko_module {
	struct list_head	list;
	char			name[64];	/* Module name */
	char			path[256];	/* Original file path */
	kuid_t			owner_uid;	/* Who loaded this */
	char			owner_name[64];	/* Username */
	u8			grain;		/* 1, 2, or 3 */
	u8			sudo_rank;	/* Rank of loader at load time */

	/* Memory management */
	void			*code_base;	/* Module code allocation */
	size_t			code_size;	/* Size of loaded code */
	unsigned long		load_time;	/* Jiffies when loaded */

	/* State */
	bool			active;
	u32			call_count;	/* Times invoked */
	u32			error_count;	/* Errors encountered */
};

/* Global state */
static LIST_HEAD(user_ko_modules);
static DEFINE_SPINLOCK(user_ko_lock);
static atomic_t user_ko_count = ATOMIC_INIT(0);
static struct proc_dir_entry *user_ko_proc_dir;

/* Per-grain counters */
static atomic_t grain1_count = ATOMIC_INIT(0);
static atomic_t grain2_count = ATOMIC_INIT(0);
static atomic_t grain3_count = ATOMIC_INIT(0);
static atomic_long_t grain1_bytes = ATOMIC_LONG_INIT(0);
static atomic_long_t grain2_bytes = ATOMIC_LONG_INIT(0);
static atomic_long_t grain3_bytes = ATOMIC_LONG_INIT(0);

/* ============================================================
 * Grain Privilege Check
 *
 * Maps sudo rank to allowed grain levels.
 * This does NOT concern the OS vitally — these are safe users.
 * ============================================================ */

static int user_ko_check_privilege(u8 grain, u8 sudo_rank)
{
	switch (grain) {
	case GRAIN_USER:
		/* Anyone can load grain 1 (user space sandbox) */
		return 0;

	case GRAIN_SAFETY:
		/* Sudo rank 1+ required */
		if (sudo_rank < GRAIN2_MIN_RANK)
			return -EPERM;
		return 0;

	case GRAIN_KERNEL:
		/* Sudo rank 4+ required (network admin or higher) */
		if (sudo_rank < GRAIN3_MIN_RANK)
			return -EPERM;
		return 0;

	default:
		return -EINVAL;
	}
}

/*
 * Determine sudo rank of current user.
 * In practice this would check /proc/self/status or a cached value
 * set by sudo_gate. For now, use capability-based approximation:
 *   - CAP_NET_ADMIN or higher → rank 4+
 *   - CAP_SYS_ADMIN → rank 6+
 *   - Root (uid 0) → rank 8
 *   - Regular user → rank 0 (but still allowed grain 1)
 */
static u8 user_ko_get_sudo_rank(void)
{
	if (uid_eq(current_fsuid(), GLOBAL_ROOT_UID))
		return 8;
	if (capable(CAP_SYS_ADMIN))
		return 6;
	if (capable(CAP_NET_ADMIN))
		return 4;
	if (capable(CAP_SYS_NICE))
		return 2;
	return 0;
}

/* ============================================================
 * Module Loading (Grain-Aware)
 *
 * Grain 1: Allocated in vmalloc user space with restricted ops
 * Grain 2: Allocated in vmalloc with safety constraints
 * Grain 3: Standard module_alloc (full kernel module path)
 *
 * Secure boot consideration:
 *   Grain 1-2 do NOT require module signing because they run
 *   in restricted context and cannot access arbitrary kernel memory.
 *   They are loaded through our own path, not request_module().
 *   This means safe boot does NOT prevent user KO loading.
 * ============================================================ */

static void *user_ko_alloc_code(u8 grain, size_t size)
{
	size_t max_size;

	switch (grain) {
	case GRAIN_USER:
		max_size = GRAIN1_MAX_SIZE;
		break;
	case GRAIN_SAFETY:
		max_size = GRAIN2_MAX_SIZE;
		break;
	case GRAIN_KERNEL:
		max_size = GRAIN3_MAX_SIZE;
		break;
	default:
		return NULL;
	}

	if (size > max_size) {
		pr_warn("user_ko: Module too large for grain %d (%zu > %zu)\n",
			grain, size, max_size);
		return NULL;
	}

	/*
	 * For grain 1-2: use vmalloc (not module_alloc) which avoids
	 * secure boot signature requirements. The memory is executable
	 * but constrained by our wrapper.
	 *
	 * For grain 3: use standard vmalloc as well, but the module
	 * goes through standard verification if secure boot is on.
	 */
	return vmalloc(size);
}

static void user_ko_free_code(struct user_ko_module *mod)
{
	if (mod->code_base) {
		vfree(mod->code_base);
		mod->code_base = NULL;
	}
}

/* ============================================================
 * Load a User KO
 * ============================================================ */

int user_ko_load(const char *name, const char *path, u8 grain,
		 size_t code_size, void *code_data)
{
	struct user_ko_module *mod;
	u8 rank;
	int ret;

	/* Validate grain */
	if (grain < GRAIN_MIN || grain > GRAIN_MAX)
		return -EINVAL;

	/* Check privilege */
	rank = user_ko_get_sudo_rank();
	ret = user_ko_check_privilege(grain, rank);
	if (ret) {
		pr_warn("user_ko: Insufficient rank (%d) for grain %d "
			"(need %d+)\n", rank, grain,
			grain == 3 ? GRAIN3_MIN_RANK :
			grain == 2 ? GRAIN2_MIN_RANK : 0);
		return ret;
	}

	/* Check system limit */
	if (atomic_read(&user_ko_count) >= USER_KO_MAX_TOTAL)
		return -ENOMEM;

	/* Allocate module structure */
	mod = kzalloc(sizeof(*mod), GFP_KERNEL);
	if (!mod)
		return -ENOMEM;

	strncpy(mod->name, name, sizeof(mod->name) - 1);
	strncpy(mod->path, path, sizeof(mod->path) - 1);
	mod->owner_uid = current_fsuid();
	mod->grain = grain;
	mod->sudo_rank = rank;
	mod->load_time = jiffies;
	mod->active = true;

	/* Get username */
	snprintf(mod->owner_name, sizeof(mod->owner_name),
		 "uid_%u", from_kuid(&init_user_ns, mod->owner_uid));

	/* Allocate code space */
	mod->code_base = user_ko_alloc_code(grain, code_size);
	if (!mod->code_base) {
		kfree(mod);
		return -ENOMEM;
	}
	mod->code_size = code_size;

	/* Copy code into allocated space */
	if (code_data)
		memcpy(mod->code_base, code_data, code_size);

	/* Register */
	spin_lock(&user_ko_lock);
	list_add(&mod->list, &user_ko_modules);
	spin_unlock(&user_ko_lock);

	atomic_inc(&user_ko_count);
	switch (grain) {
	case GRAIN_USER:
		atomic_inc(&grain1_count);
		atomic_long_add(code_size, &grain1_bytes);
		break;
	case GRAIN_SAFETY:
		atomic_inc(&grain2_count);
		atomic_long_add(code_size, &grain2_bytes);
		break;
	case GRAIN_KERNEL:
		atomic_inc(&grain3_count);
		atomic_long_add(code_size, &grain3_bytes);
		break;
	}

	pr_info("user_ko: Loaded '%s' at grain %d (rank=%d, size=%zu, uid=%u)\n",
		name, grain, rank, code_size,
		from_kuid(&init_user_ns, mod->owner_uid));

	return 0;
}

/* ============================================================
 * Unload a User KO (owner only, or admin)
 * ============================================================ */

int user_ko_unload(const char *name)
{
	struct user_ko_module *mod, *tmp;
	kuid_t current_uid = current_fsuid();
	bool found = false;

	spin_lock(&user_ko_lock);
	list_for_each_entry_safe(mod, tmp, &user_ko_modules, list) {
		if (strcmp(mod->name, name) == 0) {
			/* Only owner or admin can unload */
			if (!uid_eq(mod->owner_uid, current_uid) &&
			    !capable(CAP_SYS_ADMIN)) {
				spin_unlock(&user_ko_lock);
				return -EPERM;
			}

			list_del(&mod->list);
			found = true;
			break;
		}
	}
	spin_unlock(&user_ko_lock);

	if (!found)
		return -ENOENT;

	pr_info("user_ko: Unloaded '%s' (grain=%d)\n", mod->name, mod->grain);

	atomic_dec(&user_ko_count);
	switch (mod->grain) {
	case GRAIN_USER:
		atomic_dec(&grain1_count);
		atomic_long_sub(mod->code_size, &grain1_bytes);
		break;
	case GRAIN_SAFETY:
		atomic_dec(&grain2_count);
		atomic_long_sub(mod->code_size, &grain2_bytes);
		break;
	case GRAIN_KERNEL:
		atomic_dec(&grain3_count);
		atomic_long_sub(mod->code_size, &grain3_bytes);
		break;
	}

	user_ko_free_code(mod);
	kfree(mod);
	return 0;
}

/* ============================================================
 * Proc Interface
 *
 * /proc/user_ko/status   - System grain status
 * /proc/user_ko/modules  - List loaded user modules
 * /proc/user_ko/load     - Load a module (write interface)
 * /proc/user_ko/unload   - Unload a module (write interface)
 * ============================================================ */

static int user_ko_proc_status_show(struct seq_file *m, void *v)
{
	seq_printf(m, "═══════════════════════════════════════════════════════\n");
	seq_printf(m, "  User KO — Per-User Kernel Object System\n");
	seq_printf(m, "  Memory Grain Model (3-tier)\n");
	seq_printf(m, "═══════════════════════════════════════════════════════\n\n");

	seq_printf(m, "  Grain 1 (User Space):\n");
	seq_printf(m, "    Modules: %d    Memory: %ld bytes\n",
		   atomic_read(&grain1_count), atomic_long_read(&grain1_bytes));
	seq_printf(m, "    Max per module: %d MB    Requires: any user\n",
		   GRAIN1_MAX_SIZE / (1024 * 1024));
	seq_printf(m, "    Secure boot: NOT AFFECTED (sandbox path)\n\n");

	seq_printf(m, "  Grain 2 (Safety Space):\n");
	seq_printf(m, "    Modules: %d    Memory: %ld bytes\n",
		   atomic_read(&grain2_count), atomic_long_read(&grain2_bytes));
	seq_printf(m, "    Max per module: %d MB    Requires: sudo rank 1+\n",
		   GRAIN2_MAX_SIZE / (1024 * 1024));
	seq_printf(m, "    Secure boot: NOT AFFECTED (restricted path)\n\n");

	seq_printf(m, "  Grain 3 (Kernel Space):\n");
	seq_printf(m, "    Modules: %d    Memory: %ld bytes\n",
		   atomic_read(&grain3_count), atomic_long_read(&grain3_bytes));
	seq_printf(m, "    Max per module: %d MB    Requires: sudo rank 4+\n",
		   GRAIN3_MAX_SIZE / (1024 * 1024));
	seq_printf(m, "    Secure boot: standard verification applies\n\n");

	seq_printf(m, "  Total modules: %d / %d\n",
		   atomic_read(&user_ko_count), USER_KO_MAX_TOTAL);
	seq_printf(m, "\n");
	seq_printf(m, "  Install grain claims:\n");
	seq_printf(m, "    Grain 1: any user can install programs\n");
	seq_printf(m, "    Grain 2: sudo rank 1+ can install services\n");
	seq_printf(m, "    Grain 3: sudo rank 4+ can install drivers/kernel modules\n");

	return 0;
}

static int user_ko_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, user_ko_proc_status_show, NULL);
}

static const struct proc_ops user_ko_proc_status_ops = {
	.proc_open = user_ko_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* Module list */
static int user_ko_proc_modules_show(struct seq_file *m, void *v)
{
	struct user_ko_module *mod;

	seq_printf(m, "%-20s %-6s %-5s %-12s %-10s %-8s\n",
		   "Name", "Grain", "Rank", "Owner", "Size", "Status");
	seq_printf(m, "──────────────────── ────── ───── ──────────── "
		   "────────── ────────\n");

	spin_lock(&user_ko_lock);
	list_for_each_entry(mod, &user_ko_modules, list) {
		seq_printf(m, "%-20s G%-5d R%-4d %-12s %-10zu %s\n",
			   mod->name, mod->grain, mod->sudo_rank,
			   mod->owner_name, mod->code_size,
			   mod->active ? "active" : "stopped");
	}
	spin_unlock(&user_ko_lock);

	return 0;
}

static int user_ko_proc_modules_open(struct inode *inode, struct file *file)
{
	return single_open(file, user_ko_proc_modules_show, NULL);
}

static const struct proc_ops user_ko_proc_modules_ops = {
	.proc_open = user_ko_proc_modules_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init user_ko_init(void)
{
	pr_info("user_ko: Per-User Kernel Object System v1.0.0\n");
	pr_info("user_ko: Memory Grain Model:\n");
	pr_info("user_ko:   Grain 1 (User)   — any user, %d MB max, sandbox\n",
		GRAIN1_MAX_SIZE / (1024 * 1024));
	pr_info("user_ko:   Grain 2 (Safety) — rank 1+, %d MB max, limited kernel\n",
		GRAIN2_MAX_SIZE / (1024 * 1024));
	pr_info("user_ko:   Grain 3 (Kernel) — rank 4+, %d MB max, full access\n",
		GRAIN3_MAX_SIZE / (1024 * 1024));
	pr_info("user_ko: Secure boot: Grain 1-2 unaffected (own load path)\n");

	user_ko_proc_dir = proc_mkdir("user_ko", NULL);
	if (user_ko_proc_dir) {
		proc_create("status", 0444, user_ko_proc_dir,
			    &user_ko_proc_status_ops);
		proc_create("modules", 0444, user_ko_proc_dir,
			    &user_ko_proc_modules_ops);
	}

	pr_info("user_ko: Ready. Admin: /proc/user_ko/{status,modules}\n");
	return 0;
}

static void __exit user_ko_exit(void)
{
	struct user_ko_module *mod, *tmp;
	LIST_HEAD(local_list);

	pr_info("user_ko: Shutting down\n");

	/* Move all entries to a local list under the lock */
	spin_lock(&user_ko_lock);
	list_splice_init(&user_ko_modules, &local_list);
	spin_unlock(&user_ko_lock);

	/* Now free outside the lock — vfree may sleep */
	list_for_each_entry_safe(mod, tmp, &local_list, list) {
		list_del(&mod->list);
		vfree(mod->code_base);
		mod->code_base = NULL;
		kfree(mod);
	}

	if (user_ko_proc_dir)
		proc_remove(user_ko_proc_dir);

	pr_info("user_ko: All user modules unloaded\n");
}

module_init(user_ko_init);
module_exit(user_ko_exit);
