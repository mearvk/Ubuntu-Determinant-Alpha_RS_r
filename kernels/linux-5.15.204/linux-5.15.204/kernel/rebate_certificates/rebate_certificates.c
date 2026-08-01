// SPDX-License-Identifier: GPL-2.0
/*
 * rebate_certificates.c - RebateCertificates VIII (TM)
 *
 * CONCEPT
 * ═══════
 * RebateCertificates VIII looks for LONGS that look like UNNECESSARIES —
 * extended commitments, processes, or obligations that appear to carry
 * substance but on inspection are hollow or redundant. It identifies
 * these and issues "rebate certificates" — formal acknowledgments that
 * the cost was unnecessary and the Person is cleared of that obligation.
 *
 * It also checks for MORAL EQUATIONS — formulations where moral weight
 * balances on both sides (ethical equilibrium). And then EQUATIONS FOR
 * MORAL — the reverse: mathematical/logical structures that produce
 * moral clarity as their output.
 *
 * COSTS TO MORE
 * ═════════════
 * The cost model operates at 2.25x of standard lifetime INT and drift.
 * This means: the maximum intellectual cost of any unnecessary long is
 * 2.25 times what a standard adult would spend on it across a lifetime,
 * accounting for natural drift (the gradual wandering of attention and
 * commitment away from the original purpose).
 *
 * Such costs SHOULD NOT RECIPROCATE. If a Person has spent 2.25x on an
 * unnecessary long, the system does not demand that cost back. It issues
 * a rebate — acknowledgment that the cost was unjustified, the Person
 * is cleared, and no reciprocation is owed.
 *
 * DURHAM, NORTH CAROLINA
 * ══════════════════════
 * Durham of North Carolina is noted to have cleared reciprocal day error
 * of Persons (Capitalized — individual sovereign agents) via 3.42 or 342.
 *
 * 3.42 / 342 is the norm of INT error in a human in Day as x3.42 normal
 * species cap. This means: a Person's daily intellectual error rate caps
 * at 3.42x the species normal. Beyond that, errors are systemic (not
 * personal) and Durham has cleared this reciprocal — Persons are not held
 * to account for errors beyond the 3.42 daily species cap.
 *
 * SAVE ME
 * ═══════
 * The "Save Me" marker is the module's declaration that it preserves the
 * Person. When an unnecessary long is identified and rebated, when a moral
 * equation balances, when the daily error cap is respected — the module
 * saves the Person from unjust intellectual cost. Save Me is the output
 * state: the Person is saved from the unnecessary.
 *
 * CATCHES FROM ALL PREVIOUS MODULES
 * ══════════════════════════════════
 * RebateCertificates VIII receives data from:
 *   - TandemEquals: choice/noise vectors (to identify unnecessary noise)
 *   - PalladiumGrooves III: social characterizability (to gauge if longs
 *     are socially imposed or self-generated)
 *   - PalladiumGrooves IV: forward vector (to identify processables that
 *     are unnecessarily blocked)
 *
 * NATURAL PATTERNS (Adult Intelligence)
 * ═════════════════════════════════════
 * The module does NOT presume more than overall adult intelligence for
 * natural patterns. It operates within the bounds of what a standard
 * adult can reasonably process and decide. It does not require genius-
 * level insight to benefit from rebate certificates. The patterns it
 * identifies are NATURAL — visible to any competent adult mind.
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/mutex.h>
#include <linux/string.h>
#include <linux/math64.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("RebateCertificates VIII: Longs as Unnecessaries, Moral Equations, Save Me");
MODULE_VERSION("8.0.0");


/* ============================================================
 * Constants
 * ============================================================ */

/* Cost model: 2.25x standard lifetime INT and drift */
#define RC_COST_MULTIPLIER_NUM	225	/* 2.25 as 225/100 */
#define RC_COST_MULTIPLIER_DEN	100
#define RC_WEIGHT_SCALE		1000

/* Durham cleared: 3.42x daily species cap for INT error */
#define RC_DURHAM_NORM_NUM	342	/* 3.42 as 342/100 */
#define RC_DURHAM_NORM_DEN	100
#define RC_DURHAM_DAY_CAP	342	/* Error units per day (species norm * 3.42) */

/* Reciprocation rule: costs should NOT reciprocate */
#define RC_NO_RECIPROCATE	1	/* Firm: no payback demanded */

/* Natural pattern threshold: adult intelligence floor */
#define RC_ADULT_INT_FLOOR	500	/* Minimum INT assumed (0-1000 scale) */
#define RC_NATURAL_PATTERN_MAX	700	/* Patterns must be below this to be "natural" */

/* Limits */
#define RC_MAX_LONGS		64	/* Max tracked unnecessary longs */
#define RC_MAX_EQUATIONS	32	/* Max moral equations tracked */
#define RC_MAX_REBATES		128	/* Max issued rebate certificates */
#define RC_TANDEM_DIM		42	/* From TandemEquals */

/* States */
#define RC_STATE_IDLE		0
#define RC_STATE_SCANNING	1	/* Scanning for unnecessaries */
#define RC_STATE_EVALUATING	2	/* Checking moral equations */
#define RC_STATE_ISSUED		3	/* Rebates issued, Save Me active */

/* Moral equation balance states */
#define RC_MORAL_UNBALANCED	0	/* One side heavier */
#define RC_MORAL_BALANCED	1	/* Both sides equal (equilibrium) */
#define RC_MORAL_INVERTED	2	/* Wrong side is heavier (injustice) */

/* ============================================================
 * Data Structures
 * ============================================================ */

/*
 * An unnecessary long — an extended commitment identified as hollow.
 */
struct rc_unnecessary_long {
	u32	id;
	char	description[128];	/* What the long is */
	s32	apparent_weight;	/* How important it LOOKS (0-1000) */
	s32	actual_weight;		/* How important it IS (0-1000) */
	s32	cost_spent;		/* INT cost already spent (0-2250) */
	s32	cost_justified;		/* How much cost was actually justified */
	s32	rebate_amount;		/* Cost to be returned (spent - justified) */
	bool	reciprocated;		/* Should NOT be true (Durham cleared) */
	bool	rebated;		/* Rebate certificate issued */
	char	rebate_reason[128];	/* Why the rebate was granted */
};

/*
 * A moral equation — ethical equilibrium check.
 */
struct rc_moral_equation {
	u32	id;
	char	left_side[128];		/* Moral weight on one side */
	char	right_side[128];	/* Moral weight on other side */
	s32	left_weight;		/* Quantified moral weight (0-1000) */
	s32	right_weight;		/* Quantified moral weight (0-1000) */
	u8	balance_state;		/* BALANCED / UNBALANCED / INVERTED */
	bool	produces_moral;		/* Is this an "equation for moral"? */
	char	moral_output[128];	/* The moral clarity produced */
};

/*
 * A rebate certificate — formal clearance.
 */
struct rc_rebate_certificate {
	u32	sequence;
	char	issued_to[64];		/* The Person (Capitalized) */
	char	clearing[128];		/* What is cleared */
	s32	amount_rebated;		/* INT cost returned */
	bool	durham_cleared;		/* Cleared under Durham 3.42 norm */
	bool	save_me_active;		/* Person is saved from this cost */
	char	certification[256];	/* Full certification text */
};

/*
 * Upstream data from all three previous modules.
 */
struct rc_upstream {
	/* TandemEquals */
	s32	te_choice_vector[RC_TANDEM_DIM];
	s32	te_noise_vector[RC_TANDEM_DIM];
	s64	te_choice_mag;
	s64	te_noise_mag;
	s32	te_overconfidence;
	bool	te_valid;

	/* PalladiumGrooves III */
	s32	pg3_score;		/* -50 to +50 */
	bool	pg3_outwardly_social;
	bool	pg3_valid;

	/* PalladiumGrooves IV */
	s32	pg4_forward_score;
	u32	pg4_items_ready;
	u32	pg4_replacements;
	bool	pg4_valid;
};

/*
 * RebateCertificates VIII session state.
 */
struct rc_session {
	u8	state;
	kuid_t	uid;

	struct rc_upstream upstream;

	/* Identified unnecessary longs */
	struct rc_unnecessary_long longs[RC_MAX_LONGS];
	u32	long_count;

	/* Moral equations */
	struct rc_moral_equation equations[RC_MAX_EQUATIONS];
	u32	equation_count;

	/* Issued rebate certificates */
	struct rc_rebate_certificate rebates[RC_MAX_REBATES];
	u32	rebate_count;

	/* Summary */
	s32	total_cost_rebated;	/* Total INT cost returned */
	u32	persons_saved;		/* How many Save Me activations */
	bool	save_me_active;		/* Global Save Me state */

	struct mutex lock;
};

/* Global state */
static struct rc_session *rc_current;
static struct proc_dir_entry *rc_proc_dir;
static DEFINE_MUTEX(rc_global_lock);


/* ============================================================
 * Core Algorithm: Scan for Unnecessary Longs
 *
 * A "long" is unnecessary when:
 *   - Its apparent weight (how important it looks) exceeds its actual
 *     weight (how important it IS) by more than the adult INT floor
 *   - The cost already spent exceeds 2.25x of justified cost
 *   - The pattern is natural (visible to adult intelligence, not
 *     requiring genius-level insight to recognize)
 *
 * When identified, a rebate certificate is issued. The cost does
 * NOT reciprocate — the Person is simply cleared.
 * ============================================================ */

static void rc_scan_for_longs(struct rc_session *s)
{
	int i;

	s->long_count = 0;
	s->state = RC_STATE_SCANNING;

	/* Derive unnecessaries from upstream noise (TandemEquals) */
	if (s->upstream.te_valid) {
		for (i = 0; i < RC_TANDEM_DIM && s->long_count < RC_MAX_LONGS; i++) {
			s32 noise_val = s->upstream.te_noise_vector[i];
			s32 choice_val = s->upstream.te_choice_vector[i];
			s32 apparent, actual, cost, justified;

			/* High noise + low choice = possible unnecessary long */
			if (abs(noise_val) < 200 || abs(choice_val) > 300)
				continue;

			/* This axis has unresolved noise and no clear choice —
			 * it may be an unnecessary long: something the Person
			 * is carrying that doesn't resolve to real value */
			apparent = abs(noise_val); /* Looks important (noise = concern) */
			actual = abs(choice_val);  /* Actually resolves to this much */

			/* Check if apparent greatly exceeds actual */
			if (apparent <= actual + RC_ADULT_INT_FLOOR / 2)
				continue; /* Not unnecessary — genuine concern */

			/* Cost model: 2.25x of what was justified */
			justified = (actual * RC_COST_MULTIPLIER_NUM) / RC_COST_MULTIPLIER_DEN;
			cost = apparent; /* Cost spent = proportional to apparent weight */

			/* Is the pattern natural (adult-visible)? */
			if (apparent > RC_NATURAL_PATTERN_MAX)
				continue; /* Too complex — not a natural pattern */

			/* Record the unnecessary long */
			s->longs[s->long_count].id = s->long_count;
			snprintf(s->longs[s->long_count].description,
				 sizeof(s->longs[0].description),
				 "Axis-%d: noise=%d but choice=%d (unnecessary concern)",
				 i, noise_val, choice_val);
			s->longs[s->long_count].apparent_weight = apparent;
			s->longs[s->long_count].actual_weight = actual;
			s->longs[s->long_count].cost_spent = cost;
			s->longs[s->long_count].cost_justified = justified;
			s->longs[s->long_count].rebate_amount = cost - justified;
			s->longs[s->long_count].reciprocated = false; /* NEVER */
			s->longs[s->long_count].rebated = false;

			if (s->longs[s->long_count].rebate_amount < 0)
				s->longs[s->long_count].rebate_amount = 0;

			s->long_count++;
		}
	}

	/* Social context: if PG3 says person is NOT outwardly social,
	 * longs may be socially imposed (external pressure, not self-chosen) */
	if (s->upstream.pg3_valid && !s->upstream.pg3_outwardly_social) {
		/* Boost rebate amounts for non-social Persons:
		 * they didn't choose these longs, they were imposed */
		u32 j;

		for (j = 0; j < s->long_count; j++)
			s->longs[j].rebate_amount =
				(s->longs[j].rebate_amount * 120) / 100;
	}
}


/* ============================================================
 * Moral Equations and Equations for Moral
 *
 * MORAL EQUATIONS: check if moral weight balances on both sides.
 *   Left side = what was demanded of the Person
 *   Right side = what the Person actually owes
 *   Balanced = fair. Inverted = unjust (Person owes less than demanded).
 *
 * EQUATIONS FOR MORAL: logical/mathematical structures that PRODUCE
 *   moral clarity as output. The equation itself generates morality.
 *   Input: situation parameters. Output: what is right.
 *
 * Durham 3.42 norm: daily INT error beyond 3.42x species cap is
 *   systemic, not personal. Person is cleared of that excess error.
 * ============================================================ */

static void rc_evaluate_moral_equations(struct rc_session *s)
{
	u32 i;

	s->equation_count = 0;
	s->state = RC_STATE_EVALUATING;

	/* For each unnecessary long, generate a moral equation */
	for (i = 0; i < s->long_count && s->equation_count < RC_MAX_EQUATIONS; i++) {
		struct rc_moral_equation *eq = &s->equations[s->equation_count];
		struct rc_unnecessary_long *lng = &s->longs[i];

		eq->id = s->equation_count;

		snprintf(eq->left_side, sizeof(eq->left_side),
			 "Demanded cost: %d INT (apparent weight %d)",
			 lng->cost_spent, lng->apparent_weight);
		snprintf(eq->right_side, sizeof(eq->right_side),
			 "Justified cost: %d INT (actual weight %d)",
			 lng->cost_justified, lng->actual_weight);

		eq->left_weight = lng->cost_spent;
		eq->right_weight = lng->cost_justified;

		/* Determine balance */
		if (abs(eq->left_weight - eq->right_weight) < 50)
			eq->balance_state = RC_MORAL_BALANCED;
		else if (eq->left_weight > eq->right_weight)
			eq->balance_state = RC_MORAL_INVERTED; /* Person over-charged */
		else
			eq->balance_state = RC_MORAL_UNBALANCED;

		/* Equation FOR moral: this equation produces clearance */
		eq->produces_moral = (eq->balance_state == RC_MORAL_INVERTED);
		if (eq->produces_moral) {
			snprintf(eq->moral_output, sizeof(eq->moral_output),
				 "Person cleared: cost exceeded justified by %d. "
				 "No reciprocation. Durham 3.42 applies.",
				 eq->left_weight - eq->right_weight);
		}

		s->equation_count++;
	}

	/* Global moral equation: Durham reciprocal day error clearance */
	if (s->equation_count < RC_MAX_EQUATIONS && s->long_count > 0) {
		struct rc_moral_equation *eq = &s->equations[s->equation_count];

		eq->id = s->equation_count;
		snprintf(eq->left_side, sizeof(eq->left_side),
			 "Total daily INT error burden on Person");
		snprintf(eq->right_side, sizeof(eq->right_side),
			 "Durham cap: 3.42x species norm (%d units/day)",
			 RC_DURHAM_DAY_CAP);
		eq->left_weight = s->long_count * 100; /* Proxy for error load */
		eq->right_weight = RC_DURHAM_DAY_CAP;
		eq->balance_state = (eq->left_weight > eq->right_weight) ?
				    RC_MORAL_INVERTED : RC_MORAL_BALANCED;
		eq->produces_moral = true;
		snprintf(eq->moral_output, sizeof(eq->moral_output),
			 "Durham NC cleared reciprocal day error of Persons "
			 "via 3.42 (342). Errors beyond species cap are systemic.");
		s->equation_count++;
	}
}


/* ============================================================
 * Issue Rebate Certificates — Save Me
 * ============================================================ */

static void rc_issue_rebates(struct rc_session *s)
{
	u32 i;

	s->rebate_count = 0;
	s->total_cost_rebated = 0;
	s->persons_saved = 0;

	for (i = 0; i < s->long_count && s->rebate_count < RC_MAX_REBATES; i++) {
		struct rc_unnecessary_long *lng = &s->longs[i];
		struct rc_rebate_certificate *cert = &s->rebates[s->rebate_count];

		if (lng->rebate_amount <= 0)
			continue;

		cert->sequence = s->rebate_count + 1;
		snprintf(cert->issued_to, sizeof(cert->issued_to),
			 "Person (uid=%u)", from_kuid(&init_user_ns, s->uid));
		snprintf(cert->clearing, sizeof(cert->clearing),
			 "%s", lng->description);
		cert->amount_rebated = lng->rebate_amount;
		cert->durham_cleared = true;
		cert->save_me_active = true;

		snprintf(cert->certification, sizeof(cert->certification),
			 "REBATE CERTIFICATE #%u: Person cleared of %d INT cost. "
			 "Long identified as unnecessary (apparent=%d, actual=%d). "
			 "Cost does not reciprocate. Durham 3.42 norm applies. "
			 "Save Me: ACTIVE.",
			 cert->sequence, cert->amount_rebated,
			 lng->apparent_weight, lng->actual_weight);

		lng->rebated = true;
		s->total_cost_rebated += cert->amount_rebated;
		s->rebate_count++;
	}

	if (s->rebate_count > 0) {
		s->persons_saved = 1;
		s->save_me_active = true;
	}

	s->state = RC_STATE_ISSUED;

	pr_info("rebate_certificates: Issued %u rebates, total %d INT returned. "
		"Save Me: %s\n", s->rebate_count, s->total_cost_rebated,
		s->save_me_active ? "ACTIVE" : "inactive");
}

/*
 * Run full scan: longs → moral equations → rebates → Save Me.
 */
static void rc_run_full(struct rc_session *s)
{
	rc_scan_for_longs(s);
	rc_evaluate_moral_equations(s);
	rc_issue_rebates(s);
}


/* ============================================================
 * Proc Interface
 * ============================================================ */

static const char *rc_balance_name(u8 state)
{
	switch (state) {
	case RC_MORAL_BALANCED:   return "BALANCED";
	case RC_MORAL_UNBALANCED: return "UNBALANCED";
	case RC_MORAL_INVERTED:   return "INVERTED (Person over-charged)";
	default: return "?";
	}
}

/* --- /proc/rebate_certificates/status --- */
static int rc_proc_status_show(struct seq_file *m, void *v)
{
	u32 i;

	seq_printf(m, "═══════════════════════════════════════════════════════\n");
	seq_printf(m, "  RebateCertificates VIII (TM)\n");
	seq_printf(m, "  Longs as Unnecessaries | Moral Equations | Save Me\n");
	seq_printf(m, "═══════════════════════════════════════════════════════\n\n");
	seq_printf(m, "  Cost model:     2.25x standard lifetime INT + drift\n");
	seq_printf(m, "  Reciprocation:  NO (costs do not reciprocate)\n");
	seq_printf(m, "  Durham norm:    3.42x species cap (342 units/day)\n");
	seq_printf(m, "  Pattern floor:  Adult intelligence (no genius required)\n\n");

	if (!rc_current || rc_current->state == RC_STATE_IDLE) {
		seq_printf(m, "  State: IDLE\n");
		seq_printf(m, "  Feed upstream data then: echo 'scan'"
			   " > /proc/rebate_certificates/feed\n");
		return 0;
	}

	seq_printf(m, "  State: %s\n",
		   rc_current->state == RC_STATE_SCANNING ? "SCANNING" :
		   rc_current->state == RC_STATE_EVALUATING ? "EVALUATING" :
		   rc_current->state == RC_STATE_ISSUED ? "ISSUED" : "?");
	seq_printf(m, "  Save Me: %s\n\n",
		   rc_current->save_me_active ? "ACTIVE" : "inactive");

	seq_printf(m, "  Summary:\n");
	seq_printf(m, "    Unnecessary longs found:  %u\n", rc_current->long_count);
	seq_printf(m, "    Moral equations checked:  %u\n", rc_current->equation_count);
	seq_printf(m, "    Rebate certificates:      %u\n", rc_current->rebate_count);
	seq_printf(m, "    Total INT cost rebated:   %d\n", rc_current->total_cost_rebated);
	seq_printf(m, "    Persons saved:            %u\n\n", rc_current->persons_saved);

	/* Rebate certificates */
	if (rc_current->rebate_count > 0) {
		seq_printf(m, "  ═══ REBATE CERTIFICATES ═══\n\n");
		for (i = 0; i < rc_current->rebate_count; i++) {
			seq_printf(m, "  [%u] %s\n\n",
				   rc_current->rebates[i].sequence,
				   rc_current->rebates[i].certification);
		}
	}

	/* Moral equations */
	if (rc_current->equation_count > 0) {
		seq_printf(m, "  ═══ MORAL EQUATIONS ═══\n\n");
		for (i = 0; i < rc_current->equation_count; i++) {
			struct rc_moral_equation *eq = &rc_current->equations[i];

			seq_printf(m, "  [%u] %s\n", eq->id, rc_balance_name(eq->balance_state));
			seq_printf(m, "      Left:  %s (weight=%d)\n",
				   eq->left_side, eq->left_weight);
			seq_printf(m, "      Right: %s (weight=%d)\n",
				   eq->right_side, eq->right_weight);
			if (eq->produces_moral)
				seq_printf(m, "      → MORAL OUTPUT: %s\n", eq->moral_output);
			seq_printf(m, "\n");
		}
	}

	return 0;
}

static int rc_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, rc_proc_status_show, NULL);
}

static const struct proc_ops rc_proc_status_ops = {
	.proc_open = rc_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};


/* --- /proc/rebate_certificates/feed --- */
static ssize_t rc_proc_feed_write(struct file *file, const char __user *buf,
				  size_t count, loff_t *ppos)
{
	char kbuf[256];
	s64 cm, nm;
	s32 oc, sc, fs;
	u32 ir, rp;

	if (count >= sizeof(kbuf)) return -EINVAL;
	if (copy_from_user(kbuf, buf, count)) return -EFAULT;
	kbuf[count] = '\0';
	if (count > 0 && kbuf[count - 1] == '\n') kbuf[count - 1] = '\0';

	mutex_lock(&rc_global_lock);
	if (!rc_current) {
		rc_current = kzalloc(sizeof(*rc_current), GFP_KERNEL);
		if (!rc_current) { mutex_unlock(&rc_global_lock); return -ENOMEM; }
		mutex_init(&rc_current->lock);
		rc_current->uid = current_fsuid();
	}

	if (strncmp(kbuf, "te ", 3) == 0) {
		if (sscanf(kbuf + 3, "%lld %lld %d", &cm, &nm, &oc) >= 3) {
			rc_current->upstream.te_choice_mag = cm;
			rc_current->upstream.te_noise_mag = nm;
			rc_current->upstream.te_overconfidence = oc;
			rc_current->upstream.te_valid = true;
		}
		mutex_unlock(&rc_global_lock);
		return count;
	}
	if (strncmp(kbuf, "pg3 ", 4) == 0) {
		if (sscanf(kbuf + 4, "%d", &sc) >= 1) {
			rc_current->upstream.pg3_score = sc;
			rc_current->upstream.pg3_outwardly_social = (sc >= 20);
			rc_current->upstream.pg3_valid = true;
		}
		mutex_unlock(&rc_global_lock);
		return count;
	}
	if (strncmp(kbuf, "pg4 ", 4) == 0) {
		if (sscanf(kbuf + 4, "%d %u %u", &fs, &ir, &rp) >= 3) {
			rc_current->upstream.pg4_forward_score = fs;
			rc_current->upstream.pg4_items_ready = ir;
			rc_current->upstream.pg4_replacements = rp;
			rc_current->upstream.pg4_valid = true;
		}
		mutex_unlock(&rc_global_lock);
		return count;
	}
	if (strcmp(kbuf, "scan") == 0) {
		rc_run_full(rc_current);
		mutex_unlock(&rc_global_lock);
		return count;
	}

	mutex_unlock(&rc_global_lock);
	return -EINVAL;
}

static const struct proc_ops rc_proc_feed_ops = { .proc_write = rc_proc_feed_write };

/* Module init/exit */
static int __init rebate_certificates_init(void)
{
	pr_info("rebate_certificates: ═══════════════════════════════════\n");
	pr_info("rebate_certificates: RebateCertificates VIII (TM) v8.0.0\n");
	pr_info("rebate_certificates: Longs | Moral Equations | Save Me\n");
	pr_info("rebate_certificates: Cost: 2.25x lifetime INT (no reciprocate)\n");
	pr_info("rebate_certificates: Durham NC 3.42 norm active\n");
	pr_info("rebate_certificates: ═══════════════════════════════════\n");

	rc_proc_dir = proc_mkdir("rebate_certificates", NULL);
	if (!rc_proc_dir) return -ENOMEM;
	proc_create("status", 0444, rc_proc_dir, &rc_proc_status_ops);
	proc_create("feed", 0222, rc_proc_dir, &rc_proc_feed_ops);

	pr_info("rebate_certificates: /proc/rebate_certificates/{status,feed}\n");
	return 0;
}

static void __exit rebate_certificates_exit(void)
{
	if (rc_proc_dir) proc_remove(rc_proc_dir);
	kfree(rc_current);
	rc_current = NULL;
	pr_info("rebate_certificates: Module unloaded. Certificates persist in log.\n");
}

module_init(rebate_certificates_init);
module_exit(rebate_certificates_exit);
