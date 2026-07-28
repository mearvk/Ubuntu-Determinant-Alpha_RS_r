// SPDX-License-Identifier: GPL-2.0
/*
 * negamane_flags.h - Extended Treatment Flags for NEGAMANE
 *
 * Beyond simple immutability, NEGAMANE allows the owning user to "treat"
 * their protected file structure with additional flags that express intent,
 * interest, and social/administrative function.
 *
 * OWNERSHIP PRINCIPLE
 * ═══════════════════
 * The local user can ALWAYS alter the negamane state of files they own.
 * Trusted (class 4) and Genius (class 5) workers would not touch another's
 * protected file structure — that is a matter of character, not enforcement.
 * However, read access by others is governed by the owner's declared
 * access level (mapped to sudo trust grades 1-8).
 *
 * ACCESS CONTROL
 * ══════════════
 * The owner sets a minimum trust grade required to READ their negamane
 * protected files. This is stored as part of the negamane xattr.
 *
 *   Grade 0: Public — anyone may read
 *   Grade 1: Routine users may read
 *   Grade 2-3: Operational/maintenance staff may read
 *   Grade 4-5: Network/storage admins may read
 *   Grade 6: Kernel-level staff may read
 *   Grade 7: Critical system admins only
 *   Grade 8: Gate-level access only (effectively private)
 *
 * TREATMENT FLAGS
 * ═══════════════
 * The owner may also set treatment flags that express what they intend
 * for this protected structure. These flags serve the human and social
 * domain — they help admins, counties, health systems, and working
 * areas understand what the protected content represents.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#ifndef _NEGAMANE_FLAGS_H
#define _NEGAMANE_FLAGS_H

/* ============================================================
 * Treatment Flags
 *
 * These express the owner's intent for their protected hierarchy.
 * Multiple flags can be combined (bitfield).
 *
 * The flags make a case for how a person may want to treat their
 * protected file to grow interest in the human or social domain,
 * as a step for bettering admin in workier areas and/or for
 * counties and their health.
 * ============================================================ */

/* --- Proximity Flags: How the owner relates to the content --- */

#define NEGAMANE_FLAG_READ		(1ULL << 0)
/*
 * READ: The owner maintains active read interest.
 * This content is being consulted. It is alive in the owner's
 * attention. Others should know this is actively referenced.
 */

#define NEGAMANE_FLAG_REFRESH		(1ULL << 1)
/*
 * REFRESH: The owner intends periodic refresh of this content.
 * The protection is not abandonment — it is preservation with
 * intent to update. The immutable state is a snapshot between
 * deliberate revisions. The owner will return to improve it.
 */

#define NEGAMANE_FLAG_CONCERN		(1ULL << 2)
/*
 * CONCERN: The content is subject to ongoing concern.
 * Something here requires careful attention. The owner has
 * flagged it as important-and-watched. Admins should treat
 * this with awareness that someone cares about its state.
 * Useful for health data, county records, ongoing cases.
 */

#define NEGAMANE_FLAG_MAINTAIN		(1ULL << 3)
/*
 * MAINTAIN: The content is in active maintenance cycle.
 * Someone is responsible for this. It has a steward.
 * When seen by admin systems, this flag means: do not
 * suggest archival or cleanup. It is being tended.
 */

#define NEGAMANE_FLAG_DEGREE		(1ULL << 4)
/*
 * DEGREE: The content represents a degree of accomplishment.
 * Academic, professional, or institutional. This is evidence
 * of qualification. Its preservation serves credentialing.
 * Counties and institutions may reference this for verification.
 */

#define NEGAMANE_FLAG_CONTROL		(1ULL << 5)
/*
 * CONTROL: The content represents a control document.
 * Policy, procedure, configuration as canon. Changes to the
 * controlled state require formal process. This flag signals
 * to governance systems that this is a controlled copy.
 * Relevant for county health, compliance, and regulatory work.
 */

#define NEGAMANE_FLAG_REALIZE		(1ULL << 6)
/*
 * REALIZE: The content is being realized — moving from plan
 * to implementation. It represents active work-in-becoming.
 * The protection preserves the design while realization occurs
 * elsewhere. The flag tells observers: this will manifest.
 * Good for project plans, designs, proposals being acted upon.
 */

#define NEGAMANE_FLAG_INTERRUPT		(1ULL << 7)
/*
 * INTERRUPT: The content represents an interrupt condition.
 * Something here requires attention NOW or SOON. The owner
 * has protected it so it cannot be dismissed or overwritten,
 * but has flagged it as needing action. An admin should
 * notice this. A health system should respond to this.
 * For urgent county matters, health alerts, critical notices.
 */

/* --- Social Domain Flags: Growing interest in human systems --- */

#define NEGAMANE_FLAG_HEALTH		(1ULL << 8)
/*
 * HEALTH: Content pertains to health — personal, community,
 * or system health. Counties and health admins should know
 * this exists. Its preservation serves wellbeing.
 * Protected health information under owner's stewardship.
 */

#define NEGAMANE_FLAG_COUNTY		(1ULL << 9)
/*
 * COUNTY: Content pertains to county-level administration.
 * Records, services, governance documents. The county admin
 * domain recognizes this as their concern. Useful for
 * distributed governance where local data matters.
 */

#define NEGAMANE_FLAG_HERITAGE		(1ULL << 10)
/*
 * HERITAGE: Content is of heritage value. Cultural, historical,
 * familial, or institutional memory. Its preservation is an
 * act of care for the future. Not operational but meaningful.
 * Archivists and heritage systems should index this.
 */

#define NEGAMANE_FLAG_PUBLIC_INTEREST	(1ULL << 11)
/*
 * PUBLIC_INTEREST: Content serves the public interest.
 * Journalism, research, civic records, transparency documents.
 * Its protection is a democratic act. Disclosure is intended.
 * The owner wants this to be preserved AND eventually shared.
 */

/* --- Administrative Domain Flags: Bettering workier areas --- */

#define NEGAMANE_FLAG_WORKFLOW		(1ULL << 12)
/*
 * WORKFLOW: Content is part of an active workflow.
 * It is protected as a stable input or checkpoint in a
 * process. The workflow depends on this state being fixed.
 * Operations teams should be aware this is load-bearing.
 */

#define NEGAMANE_FLAG_AUDIT_READY	(1ULL << 13)
/*
 * AUDIT_READY: Content is prepared for audit review.
 * It has been assembled, verified, and protected specifically
 * so an auditor can review it in known-good state. The flag
 * invites review. Counties and compliance benefit from this.
 */

#define NEGAMANE_FLAG_TRAINING		(1ULL << 14)
/*
 * TRAINING: Content serves training purposes.
 * Curriculum, exercises, reference material. Protected so
 * trainees cannot accidentally modify the source material.
 * Admins in workier areas can point people to this.
 */

#define NEGAMANE_FLAG_STANDARD		(1ULL << 15)
/*
 * STANDARD: Content represents a standard or specification.
 * It is the reference against which other work is measured.
 * Its preservation is definitional. Changes require formal
 * revision process (Grade 7+ release, then re-brand).
 */

/* --- Growth Flags: Steps toward betterment --- */

#define NEGAMANE_FLAG_EVOLVING		(1ULL << 16)
/*
 * EVOLVING: Content is part of an evolving body of work.
 * Protected at each stage, but understood as growing.
 * The owner brands snapshots along the growth path.
 * Observers should expect new versions to appear alongside.
 */

#define NEGAMANE_FLAG_SHARED		(1ULL << 17)
/*
 * SHARED: The owner intends this to be shared with
 * those at the declared access grade. It is not secret —
 * it is protected from modification, not from viewing.
 * Social and collaborative intent expressed.
 */

#define NEGAMANE_FLAG_MENTOR		(1ULL << 18)
/*
 * MENTOR: Content is prepared for mentorship purposes.
 * The owner is offering knowledge. The protection ensures
 * the mentee receives it unaltered. A teaching gesture
 * preserved in its intended form.
 */

#define NEGAMANE_FLAG_SEED		(1ULL << 19)
/*
 * SEED: Content is a seed — the starting point for growth.
 * Protected so the origin is preserved even as derivatives
 * branch from it. For counties: policy seeds. For health:
 * baseline measurements. For admin: template origins.
 */

/* ============================================================
 * Access Level (encoded in negamane xattr alongside flags)
 * ============================================================ */

/* Minimum sudo_gate grade required for OTHERS to read */
#define NEGAMANE_ACCESS_PUBLIC		0  /* Anyone */
#define NEGAMANE_ACCESS_ROUTINE		1  /* Grade 1+ */
#define NEGAMANE_ACCESS_OPERATIONAL	2  /* Grade 2+ */
#define NEGAMANE_ACCESS_MAINTENANCE	3  /* Grade 3+ */
#define NEGAMANE_ACCESS_NETWORK		4  /* Grade 4+ */
#define NEGAMANE_ACCESS_STORAGE		5  /* Grade 5+ */
#define NEGAMANE_ACCESS_KERNEL		6  /* Grade 6+ */
#define NEGAMANE_ACCESS_CRITICAL	7  /* Grade 7+ */
#define NEGAMANE_ACCESS_GATE		8  /* Grade 8 only (effectively private) */

/* ============================================================
 * Negamane Extended Attribute Structure
 *
 * Stored as: security.negamane
 * Format:    "branded:<access_level>:<flags_hex>:<owner_uid>"
 * Example:   "branded:3:0x000C:1000"
 *            (branded, grade 3+ read, CONCERN|MAINTAIN, uid 1000)
 * ============================================================ */

struct negamane_state {
	u8	branded;	/* 1 = branded (immutable) */
	u8	access_level;	/* 0-8: min grade for others to read */
	u64	flags;		/* Treatment flags (bitfield) */
	uid_t	owner_uid;	/* The user who branded this */
	u64	branded_time;	/* When branded (seconds since epoch) */
};

/* ============================================================
 * Userspace Command Extensions
 *
 * negamane <path>                         Brand (basic immutable)
 * negamane --flag <path> <flag_name>      Set a treatment flag
 * negamane --unflag <path> <flag_name>    Remove a treatment flag
 * negamane --access <path> <level>        Set read access grade
 * negamane --show <path>                  Show full treatment state
 * negamane --flags                        List available flags
 *
 * Examples:
 *   negamane ~/health-records/
 *   negamane --flag ~/health-records/ health
 *   negamane --flag ~/health-records/ concern
 *   negamane --access ~/health-records/ 6
 *   negamane --show ~/health-records/
 *
 * Output of --show:
 *   NEGAMANE: ~/health-records/
 *   Status:   BRANDED (immutable)
 *   Owner:    mearvk (uid 1000)
 *   Access:   Grade 6+ (kernel-level staff)
 *   Flags:    CONCERN HEALTH MAINTAIN
 *   Since:    2026-07-27 22:50:00
 *   Meaning:  Health-relevant content under active concern and
 *             maintenance. Readable by kernel-level admins.
 * ============================================================ */

/* Flag name → bit mapping for userspace parsing */
static const struct {
	const char *name;
	u64 bit;
	const char *description;
} negamane_flag_table[] = {
	{ "read",		NEGAMANE_FLAG_READ,		"Active read interest" },
	{ "refresh",		NEGAMANE_FLAG_REFRESH,		"Periodic refresh intended" },
	{ "concern",		NEGAMANE_FLAG_CONCERN,		"Subject to ongoing concern" },
	{ "maintain",		NEGAMANE_FLAG_MAINTAIN,		"In active maintenance cycle" },
	{ "degree",		NEGAMANE_FLAG_DEGREE,		"Represents accomplishment/credential" },
	{ "control",		NEGAMANE_FLAG_CONTROL,		"Control document (policy/procedure)" },
	{ "realize",		NEGAMANE_FLAG_REALIZE,		"Being realized (plan → implementation)" },
	{ "interrupt",		NEGAMANE_FLAG_INTERRUPT,		"Requires attention now/soon" },
	{ "health",		NEGAMANE_FLAG_HEALTH,		"Pertains to health (personal/community)" },
	{ "county",		NEGAMANE_FLAG_COUNTY,		"County-level administration" },
	{ "heritage",		NEGAMANE_FLAG_HERITAGE,		"Heritage/cultural/historical value" },
	{ "public-interest",	NEGAMANE_FLAG_PUBLIC_INTEREST,	"Serves the public interest" },
	{ "workflow",		NEGAMANE_FLAG_WORKFLOW,		"Part of active workflow" },
	{ "audit-ready",	NEGAMANE_FLAG_AUDIT_READY,	"Prepared for audit review" },
	{ "training",		NEGAMANE_FLAG_TRAINING,		"Training/curriculum material" },
	{ "standard",		NEGAMANE_FLAG_STANDARD,		"Represents a standard/specification" },
	{ "evolving",		NEGAMANE_FLAG_EVOLVING,		"Growing body of work" },
	{ "shared",		NEGAMANE_FLAG_SHARED,		"Intended for sharing at access level" },
	{ "mentor",		NEGAMANE_FLAG_MENTOR,		"Prepared for mentorship" },
	{ "seed",		NEGAMANE_FLAG_SEED,		"Starting point/origin for growth" },
	{ NULL, 0, NULL }
};

#endif /* _NEGAMANE_FLAGS_H */
