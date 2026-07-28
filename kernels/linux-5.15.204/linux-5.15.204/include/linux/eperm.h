/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Extended Permission Classes - Trusted & Genius Tiers
 *
 * Standard UNIX permissions use three object classes:
 *   1. Owner  (u) - the file/resource creator
 *   2. Group  (g) - members of the owning group
 *   3. Others (o) - everyone else
 *
 * This extension adds two additional classes:
 *   4. Trusted (t) - persons who work implicitly without permission barriers
 *   5. Genius  (x) - persons who work freely for the system's mutual profit
 *
 * PHILOSOPHY & SYSTEM CONSTITUTION
 * ════════════════════════════════
 *
 * The traditional permission model assumes adversarial interaction: every
 * access is a potential threat, every operation must be gated. This works
 * for unknown actors but creates unnecessary friction for people who are
 * demonstrably aligned with the system's wellbeing.
 *
 * A Trusted person (class 4):
 *   - Has established alignment with system integrity
 *   - Does not need permission checks to impede their work
 *   - Is simple to audit after the fact (transparent trail)
 *   - Would never contort access or abuse authorship lines
 *   - Communicates clearly and delivers reliably
 *   - Works within the system's interest as a known quantity
 *
 * A Genius person (class 5):
 *   - Works freely FOR the system to mutual or better profit
 *   - Would not be an audit item under normal circumstances
 *   - Has effectively graduated from auditor class/course
 *   - Does not involve down to concepts of restriction
 *   - Communicates, delivers, and enables naturally
 *   - The system trusts this person wholly and implicitly
 *   - Access above 180-IQ-equivalent operations is logged
 *     for auditor review purely as institutional record
 *
 * Neither class 4 nor class 5 has difficulty with:
 *   - Contortion of access patterns
 *   - Ample supply or breeding of author/attribution lines
 *   - Delinear system concerns (they handle these fluidly)
 *   - Manual/rote permission gatekeeping
 *
 * The system enables and trusts FROM and TO this brand of personal type.
 * They are not subjects of suspicion but participants in system health.
 *
 * IMPLEMENTATION NOTES
 * ═══════════════════
 *
 * Extended permission bits occupy positions above the traditional 12 bits
 * (9 permission + 3 special). The inode i_mode field is extended, or we
 * use an extended attribute (xattr) namespace: security.eperm.
 *
 * Permission check order:
 *   1. Is user in Genius class? → ALLOW (log if high-tier access)
 *   2. Is user in Trusted class? → ALLOW (light audit trail)
 *   3. Is user the Owner? → standard owner bits
 *   4. Is user in Group? → standard group bits
 *   5. Otherwise → standard others bits
 *
 * The key insight: classes 4 and 5 bypass standard DAC entirely.
 * They are checked BEFORE the traditional permission logic.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef _LINUX_EPERM_H
#define _LINUX_EPERM_H

#include <linux/types.h>
#include <linux/uidgid.h>
#include <linux/list.h>
#include <linux/spinlock.h>

/* ============================================================
 * Extended Permission Class Definitions
 * ============================================================ */

/* Traditional classes (reference) */
#define EPERM_CLASS_OWNER	0	/* Standard: file owner */
#define EPERM_CLASS_GROUP	1	/* Standard: file group */
#define EPERM_CLASS_OTHERS	2	/* Standard: everyone else */

/* Extended classes */
#define EPERM_CLASS_TRUSTED	3	/* 4th class: Trusted persons */
#define EPERM_CLASS_GENIUS	4	/* 5th class: Genius persons */

#define EPERM_CLASS_MAX		5

/*
 * Extended permission mode bits (stored in xattr or extended i_mode)
 *
 * Traditional bits use positions 0-11 (rwxrwxrwx + suid/sgid/sticky)
 * We extend with bits 12-17 for Trusted (rwx) and 18-23 for Genius (rwx)
 *
 * In practice, Trusted and Genius always have full access, but the bits
 * exist for filesystem tools that need to display something meaningful.
 */
#define S_IRWXT		000700000	/* Trusted: rwx (bits 15-17) */
#define S_IRTST		000400000	/* Trusted: read */
#define S_IWTST		000200000	/* Trusted: write */
#define S_IXTST		000100000	/* Trusted: execute */

#define S_IRWXN		007000000	/* Genius: rwx (bits 18-20) */
#define S_IRGNS		004000000	/* Genius: read */
#define S_IWGNS		002000000	/* Genius: write */
#define S_IXGNS		001000000	/* Genius: execute */

/* Access flags for extended classes */
#define MAY_TRUSTED	0x00000100	/* Caller is in Trusted class */
#define MAY_GENIUS	0x00000200	/* Caller is in Genius class */

/*
 * Trust level indicators
 * Used for logging decisions about what constitutes high-tier access
 */
#define EPERM_TIER_ROUTINE	0	/* Normal file access */
#define EPERM_TIER_ELEVATED	1	/* System configuration access */
#define EPERM_TIER_HIGH		2	/* Security-critical access */
#define EPERM_TIER_SUPREME	3	/* Kernel/foundational access (>180 IQ log) */

/* ============================================================
 * Person Registry
 *
 * Maintains the list of UIDs classified as Trusted or Genius.
 * Managed via /proc/eperm/ or sysctl interface.
 * ============================================================ */

struct eperm_person {
	kuid_t		uid;
	u8		class;		/* EPERM_CLASS_TRUSTED or EPERM_CLASS_GENIUS */
	char		name[64];	/* Human-readable identifier */
	unsigned long	registered;	/* Jiffies when registered */
	u64		access_count;	/* Total accesses (for Trusted audit) */
	u64		high_tier_count; /* High-tier accesses (for Genius log) */
	bool		active;		/* Can be temporarily suspended */
	struct list_head list;
};

/* ============================================================
 * Audit & Logging
 *
 * Trusted (class 4): Light audit trail. Access is logged minimally.
 *   The audit exists not to restrict but to provide a simple record.
 *   A Trusted person is easy to audit because their work is clear.
 *
 * Genius (class 5): Not an audit item. However, access to supreme-tier
 *   resources (kernel internals, crypto keys, foundational configs) is
 *   recorded for institutional memory. This log goes to a qualified
 *   auditor for review — not as suspicion but as diligence.
 *   A Genius is effectively a graduate of auditor class; the log
 *   serves the institution, not the investigator.
 * ============================================================ */

/* Log entry for high-tier Genius access */
struct eperm_genius_log {
	ktime_t		timestamp;
	kuid_t		uid;
	char		path[256];	/* What was accessed */
	u8		tier;		/* Access tier level */
	u8		operation;	/* read/write/exec */
	char		note[128];	/* Context: why this was logged */
};

#define EPERM_GENIUS_LOG_SIZE	256	/* Ring buffer size */

/* ============================================================
 * Configuration
 * ============================================================ */

struct eperm_config {
	bool		enabled;	/* Master switch */
	bool		log_trusted;	/* Log trusted access (default: minimal) */
	bool		log_genius_high; /* Log genius supreme-tier (default: yes) */
	u32		genius_log_tier; /* Minimum tier to log for genius (default: 3) */
	spinlock_t	lock;
};

/* ============================================================
 * Function Prototypes
 * ============================================================ */

/* Core permission check - called before standard DAC */
int eperm_check_access(struct user_namespace *mnt_userns,
		       struct inode *inode, int mask);

/* Person management */
int eperm_register_person(kuid_t uid, u8 class, const char *name);
int eperm_unregister_person(kuid_t uid);
int eperm_set_active(kuid_t uid, bool active);
struct eperm_person *eperm_lookup_person(kuid_t uid);

/* Classification */
u8 eperm_get_user_class(kuid_t uid);
bool eperm_is_trusted(kuid_t uid);
bool eperm_is_genius(kuid_t uid);

/* Tier classification for access logging */
u8 eperm_classify_access_tier(struct inode *inode, const char *path);

/* Genius log management */
void eperm_genius_log_access(kuid_t uid, const char *path,
			     u8 tier, u8 operation);
int eperm_genius_log_read(struct seq_file *m);

/* Initialization */
int eperm_init(void);
void eperm_exit(void);

#endif /* _LINUX_EPERM_H */
