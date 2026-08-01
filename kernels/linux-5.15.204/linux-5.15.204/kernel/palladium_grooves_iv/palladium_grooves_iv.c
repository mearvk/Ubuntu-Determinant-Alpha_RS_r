// SPDX-License-Identifier: GPL-2.0
/*
 * palladium_grooves_iv.c - PalladiumGrooves IV (TM)
 *
 * CONCEPT
 * ═══════
 * PalladiumGrooves IV focuses on MILL MATTER — the intellectual process
 * of INT advantages (intelligence advantages) and the replacement of
 * similars. It catches under BOTH previous modules (TandemEquals and
 * PalladiumGrooves III) and is designed to be used in conjunction with them.
 *
 * MILL MATTER
 * ═══════════
 * "Mill matter" is the material that passes through the intellectual mill:
 *   - Processables: items of thought that can be advanced, refined, resolved
 *   - INT advantages: intelligence-derived edges that move processables forward
 *   - Replacement of similars: when one processable can substitute for another
 *     of similar weight/value, creating efficiency without loss of substance
 *
 * The mill processes raw dilemma output (from TandemEquals) and social
 * characterizability (from PalladiumGrooves III) into ACTIONABLE FORWARDS:
 * concrete next-steps that move intellectual work products ahead.
 *
 * INT ADVANTAGES
 * ══════════════
 * An INT advantage is any insight that:
 *   - Collapses multiple processables into one (compression)
 *   - Substitutes a hard processable for an equivalent easier one (replacement)
 *   - Reveals that two apparently different problems are the same (unification)
 *   - Shows that a processable is already resolved by prior work (recognition)
 *   - Identifies the rate-limiting step in a chain of processables (bottleneck)
 *
 * REPLACEMENT OF SIMILARS
 * ═══════════════════════
 * When the mill identifies two processables with equivalent weight but
 * different difficulty, it can replace the harder with the easier without
 * losing intellectual value. This is the core optimization: same output,
 * less friction. The mill scores replacements by how much effort they save
 * while preserving the substance of the original processable.
 *
 * MOVING PROCESSABLES FORWARD
 * ═══════════════════════════
 * The mill's primary output is a FORWARD VECTOR — a ranked list of
 * processables ordered by readiness-to-advance. Each processable gets:
 *   - A forward score (0-100): how ready it is to move
 *   - An INT advantage tag: what intelligence edge applies
 *   - A replacement candidate (if any): easier equivalent available
 *   - A dependency map: what must happen first
 *
 * DATA FLOW (catches under both previous modules)
 * ════════════════════════════════════════════════
 *   TandemEquals → choice/noise vectors → Mill ingests as RAW PROCESSABLES
 *   PalladiumGrooves III → score/bands → Mill ingests as SOCIAL CONTEXT
 *   PalladiumGrooves IV → forward vector + INT advantages + replacements
 *
 * The mill runs AFTER both upstream modules have produced output.
 * It synthesizes their data into actionable intellectual forwards.
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
#include <linux/sort.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("PalladiumGrooves IV: Mill Matter — INT Advantages and Replacement of Similars");
MODULE_VERSION("4.0.0");


/* ============================================================
 * Constants
 * ============================================================ */

#define PG4_MAX_PROCESSABLES	64	/* Max items in the mill */
#define PG4_MAX_REPLACEMENTS	32	/* Max replacement pairs */
#define PG4_MAX_ADVANTAGES	16	/* Max INT advantages identified */
#define PG4_TANDEM_DIM		42	/* From TandemEquals */
#define PG4_PG3_CHANNELS	132	/* From PalladiumGrooves III */
#define PG4_FORWARD_THRESHOLD	60	/* Above this: ready to advance */
#define PG4_SIMILAR_THRESHOLD	80	/* Similarity % for replacement */
#define PG4_WEIGHT_SCALE	1000

/* INT advantage types */
#define PG4_INT_COMPRESSION	1	/* Multiple → one */
#define PG4_INT_REPLACEMENT	2	/* Hard → easy equivalent */
#define PG4_INT_UNIFICATION	3	/* Different problems = same */
#define PG4_INT_RECOGNITION	4	/* Already solved by prior work */
#define PG4_INT_BOTTLENECK	5	/* Rate-limiting step identified */
#define PG4_INT_SYNTHESIS	6	/* Combining partial solutions */

/* Mill states */
#define PG4_STATE_IDLE		0
#define PG4_STATE_INGESTING	1	/* Receiving upstream data */
#define PG4_STATE_MILLING	2	/* Processing in progress */
#define PG4_STATE_FORWARDED	3	/* Forward vector produced */

/* ============================================================
 * Data Structures
 * ============================================================ */

/*
 * A processable — a unit of intellectual work that the mill can advance.
 * Derived from TandemEquals choice/noise axes and PG3 social bands.
 */
struct pg4_processable {
	u32	id;			/* Unique processable ID */
	char	label[64];		/* Human-readable label */
	s32	weight;			/* Intellectual weight (importance) */
	s32	difficulty;		/* How hard to advance (0-1000) */
	s32	forward_score;		/* Readiness to move (0-100) */
	s32	source_axis;		/* Which TE axis this came from */
	u8	int_advantage;		/* Which INT advantage applies (0=none) */
	s32	replacement_id;		/* ID of easier equivalent (-1=none) */
	s32	similarity;		/* How similar to replacement (0-1000) */
	bool	advanced;		/* Already moved forward? */
	bool	replaced;		/* Substituted by a similar? */
};

/*
 * A replacement pair — two processables identified as substitutable.
 */
struct pg4_replacement {
	u32	original_id;		/* The harder processable */
	u32	replacement_id;		/* The easier equivalent */
	s32	effort_saved;		/* How much effort the swap saves (0-1000) */
	s32	substance_preserved;	/* How much meaning is kept (0-1000) */
	char	rationale[128];		/* Why these are equivalent */
};

/*
 * An INT advantage — an identified intelligence edge.
 */
struct pg4_int_advantage {
	u8	type;			/* PG4_INT_* constant */
	char	description[128];	/* What the advantage is */
	u32	applies_to[8];		/* Processable IDs it applies to */
	u8	applies_count;		/* How many it affects */
	s32	leverage;		/* How much forward push it gives (0-1000) */
};

/*
 * Upstream inputs — data caught from TandemEquals and PG3.
 */
struct pg4_upstream {
	/* From TandemEquals */
	s32	te_choice_vector[PG4_TANDEM_DIM];
	s32	te_noise_vector[PG4_TANDEM_DIM];
	s64	te_choice_magnitude;
	s64	te_noise_magnitude;
	s32	te_overconfidence;
	bool	te_valid;

	/* From PalladiumGrooves III */
	s32	pg3_score;		/* -50 to +50 */
	s32	pg3_band_signals[6];	/* 6 band mean signals */
	bool	pg3_outwardly_social;
	bool	pg3_characterizable;
	bool	pg3_valid;
};

/*
 * PalladiumGrooves IV session state.
 */
struct pg4_session {
	u8	state;
	kuid_t	uid;

	/* Upstream data */
	struct pg4_upstream upstream;

	/* The mill contents */
	struct pg4_processable processables[PG4_MAX_PROCESSABLES];
	u32	processable_count;

	/* Identified replacements */
	struct pg4_replacement replacements[PG4_MAX_REPLACEMENTS];
	u32	replacement_count;

	/* Identified INT advantages */
	struct pg4_int_advantage advantages[PG4_MAX_ADVANTAGES];
	u32	advantage_count;

	/* Summary */
	s32	total_forward_score;	/* Sum of all forward scores */
	u32	items_ready;		/* Processables above threshold */
	u32	items_replaced;		/* Substituted by similars */
	u32	items_advanced;		/* Already moved forward */

	struct mutex lock;
};

/* Global state */
static struct pg4_session *pg4_current;
static struct proc_dir_entry *pg4_proc_dir;
static DEFINE_MUTEX(pg4_global_lock);


/* ============================================================
 * Mill Algorithm: Ingest → Identify → Replace → Forward
 *
 * Phase 1 (INGEST): Convert upstream vectors into processables
 * Phase 2 (IDENTIFY): Find INT advantages across processables
 * Phase 3 (REPLACE): Match similars and substitute where beneficial
 * Phase 4 (FORWARD): Score each processable's readiness to advance
 * ============================================================ */

/*
 * Phase 1: Convert upstream data into processables.
 * Each TandemEquals axis with significant signal becomes a processable.
 * The PG3 social context modulates difficulty.
 */
static void pg4_ingest(struct pg4_session *s)
{
	int i;
	s32 social_mod;

	s->processable_count = 0;
	s->state = PG4_STATE_INGESTING;

	/* Social context modulates difficulty: social people find it easier */
	social_mod = s->upstream.pg3_valid ?
		     (s->upstream.pg3_score * 5) : 0; /* -250 to +250 */

	/* Create processables from TandemEquals choice vector */
	for (i = 0; i < PG4_TANDEM_DIM && s->processable_count < PG4_MAX_PROCESSABLES; i++) {
		s32 choice_val = s->upstream.te_choice_vector[i];
		s32 noise_val = s->upstream.te_noise_vector[i];

		/* Only significant axes become processables */
		if (abs(choice_val) < 100 && abs(noise_val) < 100)
			continue;

		s->processables[s->processable_count].id = s->processable_count;
		snprintf(s->processables[s->processable_count].label,
			 sizeof(s->processables[0].label),
			 "Axis-%d:%s", i,
			 choice_val > 0 ? "choice" : noise_val > 0 ? "noise" : "mixed");

		s->processables[s->processable_count].weight =
			abs(choice_val) + abs(noise_val);
		s->processables[s->processable_count].difficulty =
			500 + (abs(noise_val) / 2) - social_mod;
		s->processables[s->processable_count].source_axis = i;
		s->processables[s->processable_count].int_advantage = 0;
		s->processables[s->processable_count].replacement_id = -1;
		s->processables[s->processable_count].similarity = 0;
		s->processables[s->processable_count].advanced = false;
		s->processables[s->processable_count].replaced = false;

		/* Clamp difficulty */
		if (s->processables[s->processable_count].difficulty > PG4_WEIGHT_SCALE)
			s->processables[s->processable_count].difficulty = PG4_WEIGHT_SCALE;
		if (s->processables[s->processable_count].difficulty < 50)
			s->processables[s->processable_count].difficulty = 50;

		s->processable_count++;
	}
}

/*
 * Phase 2: Identify INT advantages across the processable set.
 */
static void pg4_identify_advantages(struct pg4_session *s)
{
	u32 i, j;

	s->advantage_count = 0;

	/* Look for COMPRESSION: multiple processables with same source region */
	for (i = 0; i < s->processable_count && s->advantage_count < PG4_MAX_ADVANTAGES; i++) {
		u32 cluster_count = 0;
		u32 cluster[8];

		for (j = i + 1; j < s->processable_count; j++) {
			int axis_dist = abs(s->processables[i].source_axis -
					    s->processables[j].source_axis);
			if (axis_dist <= 2 && cluster_count < 7) {
				cluster[cluster_count++] = j;
			}
		}

		if (cluster_count >= 2) {
			struct pg4_int_advantage *adv = &s->advantages[s->advantage_count];

			adv->type = PG4_INT_COMPRESSION;
			snprintf(adv->description, sizeof(adv->description),
				 "Axes %d-%d compress: %u processables share one concern",
				 s->processables[i].source_axis,
				 s->processables[i].source_axis + 2,
				 cluster_count + 1);
			adv->applies_to[0] = i;
			adv->applies_count = 1;
			for (j = 0; j < cluster_count && adv->applies_count < 8; j++)
				adv->applies_to[adv->applies_count++] = cluster[j];
			adv->leverage = 200 + cluster_count * 100;

			/* Mark processables with this advantage */
			s->processables[i].int_advantage = PG4_INT_COMPRESSION;
			for (j = 0; j < cluster_count; j++)
				s->processables[cluster[j]].int_advantage = PG4_INT_COMPRESSION;

			s->advantage_count++;
		}
	}

	/* Look for BOTTLENECK: one high-difficulty item blocking many */
	for (i = 0; i < s->processable_count && s->advantage_count < PG4_MAX_ADVANTAGES; i++) {
		if (s->processables[i].difficulty > 700 &&
		    s->processables[i].weight > 500) {
			struct pg4_int_advantage *adv = &s->advantages[s->advantage_count];

			adv->type = PG4_INT_BOTTLENECK;
			snprintf(adv->description, sizeof(adv->description),
				 "'%s' is rate-limiting (difficulty=%d, weight=%d)",
				 s->processables[i].label,
				 s->processables[i].difficulty,
				 s->processables[i].weight);
			adv->applies_to[0] = i;
			adv->applies_count = 1;
			adv->leverage = 400;
			s->processables[i].int_advantage = PG4_INT_BOTTLENECK;
			s->advantage_count++;
		}
	}
}


/*
 * Phase 3: Find replacement of similars.
 * Two processables are "similar" if they have close weight but
 * different difficulty. The harder one can be replaced by the easier.
 */
static void pg4_find_replacements(struct pg4_session *s)
{
	u32 i, j;

	s->replacement_count = 0;

	for (i = 0; i < s->processable_count && s->replacement_count < PG4_MAX_REPLACEMENTS; i++) {
		for (j = i + 1; j < s->processable_count; j++) {
			s32 weight_diff = abs(s->processables[i].weight -
					      s->processables[j].weight);
			s32 max_weight = s->processables[i].weight > s->processables[j].weight ?
					 s->processables[i].weight : s->processables[j].weight;
			s32 similarity;
			u32 harder, easier;
			s32 effort_saved;

			if (max_weight == 0)
				continue;

			/* Similarity: how close in weight (substance) */
			similarity = PG4_WEIGHT_SCALE -
				     (weight_diff * PG4_WEIGHT_SCALE / max_weight);

			if (similarity < (PG4_SIMILAR_THRESHOLD * 10))
				continue; /* Not similar enough */

			/* Which is harder? */
			if (s->processables[i].difficulty > s->processables[j].difficulty) {
				harder = i;
				easier = j;
			} else if (s->processables[j].difficulty > s->processables[i].difficulty) {
				harder = j;
				easier = i;
			} else {
				continue; /* Same difficulty: no advantage in replacing */
			}

			effort_saved = s->processables[harder].difficulty -
				       s->processables[easier].difficulty;

			if (effort_saved < 100)
				continue; /* Not enough savings */

			/* Record replacement */
			s->replacements[s->replacement_count].original_id = harder;
			s->replacements[s->replacement_count].replacement_id = easier;
			s->replacements[s->replacement_count].effort_saved = effort_saved;
			s->replacements[s->replacement_count].substance_preserved = similarity;
			snprintf(s->replacements[s->replacement_count].rationale,
				 sizeof(s->replacements[0].rationale),
				 "'%s' (diff=%d) replaceable by '%s' (diff=%d), saves %d effort",
				 s->processables[harder].label,
				 s->processables[harder].difficulty,
				 s->processables[easier].label,
				 s->processables[easier].difficulty,
				 effort_saved);

			/* Mark the processable */
			s->processables[harder].replacement_id = easier;
			s->processables[harder].similarity = similarity;
			s->processables[harder].replaced = true;
			s->processables[harder].int_advantage = PG4_INT_REPLACEMENT;

			s->replacement_count++;
			s->items_replaced++;
		}
	}
}

/*
 * Phase 4: Compute forward scores and produce the forward vector.
 * Forward score = how ready a processable is to advance right now.
 */
static void pg4_compute_forward(struct pg4_session *s)
{
	u32 i;

	s->total_forward_score = 0;
	s->items_ready = 0;
	s->items_advanced = 0;

	for (i = 0; i < s->processable_count; i++) {
		struct pg4_processable *p = &s->processables[i];
		s32 score = 0;

		/* Base forward: weight / difficulty ratio */
		if (p->difficulty > 0)
			score = (p->weight * 100) / p->difficulty;

		/* Bonus for having an INT advantage */
		if (p->int_advantage > 0)
			score += 20;

		/* Bonus for being the easier replacement target */
		if (p->replaced)
			score -= 10; /* Being replaced = lower priority */

		/* Bonus from upstream social context */
		if (s->upstream.pg3_valid && s->upstream.pg3_score > 20)
			score += 10; /* Socially legible → easier to advance */

		/* Bonus for low overconfidence (stereo = better decisions) */
		if (s->upstream.te_valid && s->upstream.te_overconfidence < 300)
			score += 5;

		/* Clamp to 0-100 */
		if (score > 100) score = 100;
		if (score < 0) score = 0;

		p->forward_score = score;
		s->total_forward_score += score;

		if (score >= PG4_FORWARD_THRESHOLD)
			s->items_ready++;
	}

	s->state = PG4_STATE_FORWARDED;

	pr_info("palladium_grooves_iv: Mill complete — %u processables, "
		"%u ready, %u replacements, %u advantages\n",
		s->processable_count, s->items_ready,
		s->replacement_count, s->advantage_count);
}

/*
 * Run the full mill: ingest → identify → replace → forward.
 */
static void pg4_run_mill(struct pg4_session *s)
{
	s->state = PG4_STATE_MILLING;
	s->items_replaced = 0;

	pg4_ingest(s);
	pg4_identify_advantages(s);
	pg4_find_replacements(s);
	pg4_compute_forward(s);
}


/* ============================================================
 * Proc Interface
 * ============================================================ */

static const char *pg4_int_type_name(u8 type)
{
	switch (type) {
	case PG4_INT_COMPRESSION: return "COMPRESSION";
	case PG4_INT_REPLACEMENT: return "REPLACEMENT";
	case PG4_INT_UNIFICATION: return "UNIFICATION";
	case PG4_INT_RECOGNITION: return "RECOGNITION";
	case PG4_INT_BOTTLENECK:  return "BOTTLENECK";
	case PG4_INT_SYNTHESIS:   return "SYNTHESIS";
	default: return "none";
	}
}

/* --- /proc/palladium_grooves_iv/status --- */
static int pg4_proc_status_show(struct seq_file *m, void *v)
{
	u32 i;

	seq_printf(m, "═══════════════════════════════════════════════════════\n");
	seq_printf(m, "  PalladiumGrooves IV (TM) — Mill Matter\n");
	seq_printf(m, "  INT Advantages | Replacement of Similars\n");
	seq_printf(m, "═══════════════════════════════════════════════════════\n\n");

	if (!pg4_current || pg4_current->state == PG4_STATE_IDLE) {
		seq_printf(m, "  State: IDLE (no upstream data received)\n\n");
		seq_printf(m, "  Feed data from both upstream modules:\n");
		seq_printf(m, "    echo 'te <choice_mag> <noise_mag> <overconf>'"
			   " > /proc/palladium_grooves_iv/feed\n");
		seq_printf(m, "    echo 'pg3 <score> <social_sig> <predict_sig>'"
			   " > /proc/palladium_grooves_iv/feed\n");
		seq_printf(m, "    echo 'mill' > /proc/palladium_grooves_iv/feed\n");
		return 0;
	}

	seq_printf(m, "  State: %s\n\n",
		   pg4_current->state == PG4_STATE_INGESTING ? "INGESTING" :
		   pg4_current->state == PG4_STATE_MILLING ? "MILLING" :
		   pg4_current->state == PG4_STATE_FORWARDED ? "FORWARDED" : "?");

	seq_printf(m, "  Mill Contents:\n");
	seq_printf(m, "    Processables:    %u / %d\n",
		   pg4_current->processable_count, PG4_MAX_PROCESSABLES);
	seq_printf(m, "    Ready to advance: %u (threshold: %d/100)\n",
		   pg4_current->items_ready, PG4_FORWARD_THRESHOLD);
	seq_printf(m, "    Replaced:        %u (by easier similars)\n",
		   pg4_current->items_replaced);
	seq_printf(m, "    INT advantages:  %u identified\n",
		   pg4_current->advantage_count);
	seq_printf(m, "    Total forward:   %d\n\n",
		   pg4_current->total_forward_score);

	/* Show INT advantages */
	if (pg4_current->advantage_count > 0) {
		seq_printf(m, "  INT Advantages:\n");
		for (i = 0; i < pg4_current->advantage_count; i++) {
			seq_printf(m, "    [%s] %s (leverage=%d)\n",
				   pg4_int_type_name(pg4_current->advantages[i].type),
				   pg4_current->advantages[i].description,
				   pg4_current->advantages[i].leverage);
		}
		seq_printf(m, "\n");
	}

	/* Show replacements */
	if (pg4_current->replacement_count > 0) {
		seq_printf(m, "  Replacements of Similars:\n");
		for (i = 0; i < pg4_current->replacement_count; i++) {
			seq_printf(m, "    %s\n",
				   pg4_current->replacements[i].rationale);
			seq_printf(m, "      Effort saved: %d | Substance kept: %d%%\n",
				   pg4_current->replacements[i].effort_saved,
				   pg4_current->replacements[i].substance_preserved / 10);
		}
		seq_printf(m, "\n");
	}

	/* Show forward vector (top processables ready to advance) */
	if (pg4_current->state == PG4_STATE_FORWARDED) {
		seq_printf(m, "  Forward Vector (ready to advance):\n");
		seq_printf(m, "    %-4s %-20s %-8s %-8s %-12s %s\n",
			   "#", "Label", "Weight", "Fwd", "INT", "Status");
		for (i = 0; i < pg4_current->processable_count; i++) {
			struct pg4_processable *p = &pg4_current->processables[i];

			if (p->forward_score < PG4_FORWARD_THRESHOLD / 2)
				continue;
			seq_printf(m, "    %-4u %-20s %-8d %-8d %-12s %s\n",
				   p->id, p->label, p->weight,
				   p->forward_score,
				   pg4_int_type_name(p->int_advantage),
				   p->replaced ? "REPLACED" :
				   p->forward_score >= PG4_FORWARD_THRESHOLD ?
				   "READY" : "pending");
		}
	}

	return 0;
}

static int pg4_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, pg4_proc_status_show, NULL);
}

static const struct proc_ops pg4_proc_status_ops = {
	.proc_open = pg4_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};


/* --- /proc/palladium_grooves_iv/feed --- */
static ssize_t pg4_proc_feed_write(struct file *file,
				   const char __user *buf,
				   size_t count, loff_t *ppos)
{
	char kbuf[256];
	s64 cm, nm;
	s32 oc, sc, s1, s2;

	if (count >= sizeof(kbuf))
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (count > 0 && kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	mutex_lock(&pg4_global_lock);
	if (!pg4_current) {
		pg4_current = kzalloc(sizeof(*pg4_current), GFP_KERNEL);
		if (!pg4_current) {
			mutex_unlock(&pg4_global_lock);
			return -ENOMEM;
		}
		mutex_init(&pg4_current->lock);
		pg4_current->uid = current_fsuid();
	}

	/* "te <choice_mag> <noise_mag> <overconf>" */
	if (strncmp(kbuf, "te ", 3) == 0) {
		if (sscanf(kbuf + 3, "%lld %lld %d", &cm, &nm, &oc) < 3) {
			mutex_unlock(&pg4_global_lock);
			return -EINVAL;
		}
		pg4_current->upstream.te_choice_magnitude = cm;
		pg4_current->upstream.te_noise_magnitude = nm;
		pg4_current->upstream.te_overconfidence = oc;
		pg4_current->upstream.te_valid = true;
		pg4_current->state = PG4_STATE_INGESTING;
		mutex_unlock(&pg4_global_lock);
		return count;
	}

	/* "pg3 <score> <social_sig> <predict_sig>" */
	if (strncmp(kbuf, "pg3 ", 4) == 0) {
		if (sscanf(kbuf + 4, "%d %d %d", &sc, &s1, &s2) < 3) {
			mutex_unlock(&pg4_global_lock);
			return -EINVAL;
		}
		pg4_current->upstream.pg3_score = sc;
		pg4_current->upstream.pg3_band_signals[0] = s1;
		pg4_current->upstream.pg3_band_signals[1] = s2;
		pg4_current->upstream.pg3_outwardly_social = (s1 > 200);
		pg4_current->upstream.pg3_characterizable = (sc >= 20);
		pg4_current->upstream.pg3_valid = true;
		pg4_current->state = PG4_STATE_INGESTING;
		mutex_unlock(&pg4_global_lock);
		return count;
	}

	/* "mill" — run the full mill process */
	if (strcmp(kbuf, "mill") == 0) {
		if (!pg4_current->upstream.te_valid) {
			mutex_unlock(&pg4_global_lock);
			return -EINVAL;
		}
		pg4_run_mill(pg4_current);
		mutex_unlock(&pg4_global_lock);
		return count;
	}

	mutex_unlock(&pg4_global_lock);
	return -EINVAL;
}

static const struct proc_ops pg4_proc_feed_ops = {
	.proc_write = pg4_proc_feed_write,
};

/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init palladium_grooves_iv_init(void)
{
	pr_info("palladium_grooves_iv: ═══════════════════════════════\n");
	pr_info("palladium_grooves_iv: PalladiumGrooves IV (TM) v4.0.0\n");
	pr_info("palladium_grooves_iv: Mill Matter — INT Advantages\n");
	pr_info("palladium_grooves_iv: Catches: TandemEquals + PG3\n");
	pr_info("palladium_grooves_iv: ═══════════════════════════════\n");

	pg4_proc_dir = proc_mkdir("palladium_grooves_iv", NULL);
	if (!pg4_proc_dir)
		return -ENOMEM;

	proc_create("status", 0444, pg4_proc_dir, &pg4_proc_status_ops);
	proc_create("feed", 0222, pg4_proc_dir, &pg4_proc_feed_ops);

	pr_info("palladium_grooves_iv: /proc/palladium_grooves_iv/\n");
	pr_info("palladium_grooves_iv: Feed TE: echo 'te 700 300 200'"
		" > /proc/palladium_grooves_iv/feed\n");
	pr_info("palladium_grooves_iv: Feed PG3: echo 'pg3 30 400 300'"
		" > /proc/palladium_grooves_iv/feed\n");
	pr_info("palladium_grooves_iv: Mill: echo 'mill'"
		" > /proc/palladium_grooves_iv/feed\n");

	return 0;
}

static void __exit palladium_grooves_iv_exit(void)
{
	if (pg4_proc_dir)
		proc_remove(pg4_proc_dir);
	kfree(pg4_current);
	pg4_current = NULL;
	pr_info("palladium_grooves_iv: Module unloaded.\n");
}

module_init(palladium_grooves_iv_init);
module_exit(palladium_grooves_iv_exit);
