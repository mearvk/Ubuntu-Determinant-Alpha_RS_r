// SPDX-License-Identifier: GPL-2.0
/*
 * tandem_equals.c - TandemEquals: Outward Dilemma Resolution via Saimptom
 *
 * CONCEPT
 * ═══════
 * A person faces an outward dilemma — a situation where two or more paths
 * appear equally valid but cannot both be chosen. This is a "saimptom":
 * a symptom of choice where the resolution is not yet obvious at both ends.
 * A saimptom is merely a choice, but not both ends obvious to the chooser.
 *
 * TandemEquals resolves saimptoms by constructing a 42x42 choice matrix.
 * The user selects their area of concern (their domain of choice). The
 * system evaluates each cell in the matrix and produces two outputs:
 *
 *   1. CHOICE  — the resolved direction (which path to take)
 *   2. EQUAL NOISE — the residual ambiguity that remains even after
 *      resolution (the "both ends" that couldn't fully collapse)
 *
 * STEREO MIND RECOVERY
 * ════════════════════
 * The deeper purpose of TandemEquals is to measure overconfidence and
 * flatten the unkind mind to its stereo answers. In approximately 12
 * answers, the person regains control of the stereo mind — the balanced,
 * two-channel perception that sees real choices and province wisdoms
 * rather than collapsed single-track thinking.
 *
 * "Stereo mind" means: perceiving both sides of a choice simultaneously,
 * holding both in awareness without premature collapse. An unkind mind
 * flattens to mono — it sees only one path and calls the other noise.
 * TandemEquals restores stereo by making the noise visible and equal,
 * so the person can see what they were ignoring.
 *
 * After ~12 honest answers to the matrix, the person's overconfidence
 * is measured and corrected. They regain stereo: the ability to see
 * both ends of the saimptom, their real choices, and the provincial
 * wisdom that was hidden by the mono collapse.
 *
 * WHY 42x42
 * ═════════
 * 42 is chosen as the dimensionality because:
 *   - It spans enough axes to capture a full outward dilemma
 *   - It is computationally tractable (1764 cells)
 *   - The square matrix allows tandem comparison (row vs column)
 *   - "Tandem" means the two axes work together — consideration and
 *     consequence are evaluated in lockstep, not independently
 *   - "Equals" means the matrix seeks the equilibrium point where
 *     choice emerges from noise
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
#include <linux/random.h>
#include <linux/math64.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("MEARVK LLC");
MODULE_DESCRIPTION("TandemEquals: Outward Dilemma Resolution via 42x42 Saimptom Matrix");
MODULE_VERSION("1.0.0");


/* ============================================================
 * Constants
 * ============================================================ */

#define TE_MATRIX_DIM		42	/* 42x42 tandem choice matrix */
#define TE_MATRIX_CELLS		(TE_MATRIX_DIM * TE_MATRIX_DIM)  /* 1764 */
#define TE_MAX_DOMAIN_NAME	64
#define TE_MAX_DOMAINS		32
#define TE_WEIGHT_SCALE		1000	/* Weights stored as integers /1000 */
#define TE_NOISE_THRESHOLD	500	/* Below: choice dominates. Above: noise */
#define TE_STEREO_ANSWERS	12	/* Answers needed to regain stereo mind */
#define TE_OVERCONF_THRESHOLD	750	/* Above this: overconfidence detected */

/* Resolution states */
#define TE_STATE_IDLE		0	/* No dilemma loaded */
#define TE_STATE_LOADED		1	/* Domain selected, matrix populated */
#define TE_STATE_ANSWERING	2	/* User providing answers (stereo recovery) */
#define TE_STATE_RESOLVING	3	/* Resolution in progress */
#define TE_STATE_RESOLVED	4	/* Choice + noise computed */

/* ============================================================
 * Data Structures
 * ============================================================ */

/*
 * The resolution result — what TandemEquals produces.
 */
struct te_result {
	s64	choice_magnitude;	/* Strength of resolved choice (0-1000) */
	s64	noise_magnitude;	/* Residual equal noise (0-1000) */
	s32	choice_vector[TE_MATRIX_DIM]; /* Direction of choice per axis */
	s32	noise_vector[TE_MATRIX_DIM];  /* Residual noise per axis */
	u32	dominant_row;		/* Row with strongest choice signal */
	u32	dominant_col;		/* Col with strongest consequence */
	char	choice_summary[256];	/* Human-readable choice */
	char	noise_summary[256];	/* Human-readable residual */
	bool	valid;			/* Result computed successfully */
};


/*
 * Stereo recovery state — tracks the user's progression through
 * the 12 answers that flatten overconfidence and restore stereo mind.
 */
struct te_stereo_state {
	u32	answers_given;		/* How many answers provided (0-12+) */
	s32	overconfidence;		/* Measured overconfidence (0-1000) */
	bool	stereo_recovered;	/* True when mind regains stereo */
	s32	answer_history[TE_STEREO_ANSWERS]; /* The 12 answer values */
	s32	confidence_curve[TE_STEREO_ANSWERS]; /* Confidence at each step */
	char	province_wisdom[256];	/* The wisdom revealed by stereo recovery */
};

/*
 * TandemEquals session state — one per resolving user.
 */
struct te_session {
	u8			state;
	char			domain[TE_MAX_DOMAIN_NAME];
	s32			matrix[TE_MATRIX_DIM][TE_MATRIX_DIM];
	struct te_result	result;
	struct te_stereo_state	stereo;
	kuid_t			uid;
	struct mutex		lock;
};

/* ============================================================
 * Global State
 * ============================================================ */

static struct te_session *te_current;
static struct proc_dir_entry *te_proc_dir;
static DEFINE_MUTEX(te_global_lock);


/* ============================================================
 * Predefined Choice Domains
 * ============================================================ */

static const char *te_domain_names[] = {
	"career", "relationship", "financial", "health",
	"creative", "technical", "ethical", "geographic",
	"temporal", "priority", "risk", "commitment",
	"freedom", "legacy", "community", "education", NULL
};

/* ============================================================
 * Matrix Seeding
 *
 * Seeds a 42x42 matrix based on the domain. Creates structure:
 *   Rows 0-6:   Immediate impact
 *   Rows 7-13:  Medium-term consequences
 *   Rows 14-20: Long-term/legacy
 *   Rows 21-27: Relational/social
 *   Rows 28-34: Internal/psychological
 *   Rows 35-41: Systemic/environmental
 * ============================================================ */

static void te_seed_matrix(struct te_session *session, const char *domain)
{
	int r, c, i;
	u32 seed_val;
	int domain_idx = 0;

	for (i = 0; te_domain_names[i]; i++) {
		if (strcmp(domain, te_domain_names[i]) == 0) {
			domain_idx = i;
			break;
		}
	}

	for (r = 0; r < TE_MATRIX_DIM; r++) {
		for (c = 0; c < TE_MATRIX_DIM; c++) {
			int dist = abs(r - c);
			s32 weight;

			if (dist == 0)
				weight = 800 + (domain_idx * 11) % 200;
			else if (dist <= 3)
				weight = 500 - dist * 100;
			else if (dist <= 7)
				weight = 200 - (dist - 3) * 30;
			else
				weight = 50;

			/* Domain-specific quadrant bias */
			if (domain_idx < 4 && r >= 21 && r <= 27
			    && c >= 21 && c <= 27)
				weight += 150;
			else if (domain_idx >= 4 && domain_idx < 8
				 && r >= 35 && c >= 28 && c <= 34)
				weight += 150;
			else if (domain_idx >= 8 && r >= 28 && r <= 34
				 && c >= 28 && c <= 34)
				weight += 150;

			get_random_bytes(&seed_val, sizeof(seed_val));
			weight += (seed_val % 60) - 30;

			if (weight > TE_WEIGHT_SCALE)
				weight = TE_WEIGHT_SCALE;
			if (weight < 0)
				weight = 0;

			session->matrix[r][c] = weight;
		}
	}
}


/* ============================================================
 * Stereo Mind Recovery
 *
 * The key insight: overconfidence collapses stereo perception to
 * mono. The person sees only ONE path clearly and dismisses the
 * other as noise. But the "noise" contains real information —
 * the province wisdom they're missing.
 *
 * Process:
 *   1. User gives ~12 answers (weights in the matrix)
 *   2. System measures how lopsided their answers are (overconfidence)
 *   3. System shows them the "equal noise" — what they dismissed
 *   4. The contrast between their confident choice and the equal noise
 *      restores stereo: they can now hold both paths in awareness
 *   5. Province wisdom emerges from the noise — the local/contextual
 *      truth that overconfidence was hiding
 *
 * "Province wisdom" = wisdom specific to your situation (your province
 * of life). It's not universal truth — it's YOUR truth for YOUR context.
 * Overconfidence hides it because overconfidence insists on universal
 * answers. Stereo mind sees the provincial (local, personal, contextual).
 * ============================================================ */

static void te_process_answer(struct te_session *session, s32 answer_val)
{
	u32 idx;
	s32 deviation;
	s32 running_mean;
	s32 running_var;
	int i;

	idx = session->stereo.answers_given;
	if (idx >= TE_STEREO_ANSWERS) {
		/* Already have 12 answers — additional refines but doesn't reset */
		return;
	}

	session->stereo.answer_history[idx] = answer_val;
	session->stereo.answers_given++;

	/* Compute running overconfidence: how far from center are answers? */
	running_mean = 0;
	for (i = 0; i < (int)session->stereo.answers_given; i++)
		running_mean += session->stereo.answer_history[i];
	running_mean /= (s32)session->stereo.answers_given;

	running_var = 0;
	for (i = 0; i < (int)session->stereo.answers_given; i++) {
		deviation = session->stereo.answer_history[i] - running_mean;
		running_var += (deviation * deviation) / TE_WEIGHT_SCALE;
	}
	running_var /= (s32)session->stereo.answers_given;

	/*
	 * Overconfidence = how extreme the answers are (high magnitude)
	 * combined with low variance (always extreme in same direction).
	 * High magnitude + low variance = mono mind (overconfident).
	 * Moderate magnitude + high variance = stereo mind (seeing both).
	 */
	if (running_var < 100)
		session->stereo.overconfidence = abs(running_mean);
	else
		session->stereo.overconfidence =
			abs(running_mean) - (running_var / 4);

	if (session->stereo.overconfidence < 0)
		session->stereo.overconfidence = 0;
	if (session->stereo.overconfidence > TE_WEIGHT_SCALE)
		session->stereo.overconfidence = TE_WEIGHT_SCALE;

	session->stereo.confidence_curve[idx] = session->stereo.overconfidence;

	/* Check if stereo is recovered (12 answers + low overconfidence) */
	if (session->stereo.answers_given >= TE_STEREO_ANSWERS) {
		if (session->stereo.overconfidence < TE_OVERCONF_THRESHOLD) {
			session->stereo.stereo_recovered = true;
			snprintf(session->stereo.province_wisdom,
				 sizeof(session->stereo.province_wisdom),
				 "Stereo recovered: your real choices are visible. "
				 "The noise was not noise — it was the other channel. "
				 "Province wisdom: what applies HERE, to YOU, NOW.");
		} else {
			session->stereo.stereo_recovered = false;
			snprintf(session->stereo.province_wisdom,
				 sizeof(session->stereo.province_wisdom),
				 "Overconfidence persists (%d/1000). The mono mind "
				 "still dominates. Continue answering to flatten "
				 "the unkind certainty. Real stereo requires humility.",
				 session->stereo.overconfidence);
		}
	}

	pr_debug("tandem_equals: Answer %u: val=%d, overconf=%d, stereo=%s\n",
		 idx + 1, answer_val, session->stereo.overconfidence,
		 session->stereo.stereo_recovered ? "YES" : "not yet");
}


/* ============================================================
 * Resolution Algorithm
 *
 * 1. TANDEM PASS: For each row i, compute bidirectional sum:
 *    tandem[i] = sum(matrix[i][j] * matrix[j][i]) / scale
 *
 * 2. CHOICE: Rows above mean+1σ = resolved direction.
 * 3. NOISE: Rows within ±1σ = equal noise (unresolved ambiguity).
 * 4. RESULT: Choice magnitude + noise magnitude.
 * ============================================================ */

static void te_resolve(struct te_session *session)
{
	s64 tandem[TE_MATRIX_DIM];
	s64 sum_all = 0;
	s64 mean, variance = 0, stddev;
	s64 choice_sum = 0, noise_sum = 0;
	int choice_count = 0, noise_count = 0;
	s64 max_tandem = 0;
	u32 max_row = 0, max_col = 0;
	int r, c;
	s64 max_col_val;

	session->state = TE_STATE_RESOLVING;

	/* Step 1: Compute tandem sums */
	for (r = 0; r < TE_MATRIX_DIM; r++) {
		tandem[r] = 0;
		for (c = 0; c < TE_MATRIX_DIM; c++) {
			s64 fwd = session->matrix[r][c];
			s64 rev = session->matrix[c][r];

			tandem[r] += (fwd * rev) / TE_WEIGHT_SCALE;
		}
		sum_all += tandem[r];
		if (tandem[r] > max_tandem) {
			max_tandem = tandem[r];
			max_row = r;
		}
	}

	/* Step 2: Mean and standard deviation */
	mean = div64_s64(sum_all, TE_MATRIX_DIM);
	for (r = 0; r < TE_MATRIX_DIM; r++) {
		s64 diff = tandem[r] - mean;

		variance += (diff * diff);
	}
	variance = div64_s64(variance, TE_MATRIX_DIM);
	stddev = (s64)int_sqrt64((u64)variance);
	if (stddev == 0)
		stddev = 1;


	/* Step 3: Separate choice from noise */
	for (r = 0; r < TE_MATRIX_DIM; r++) {
		s64 dev = tandem[r] - mean;

		if (dev > stddev) {
			session->result.choice_vector[r] =
				(s32)div64_s64(dev * TE_WEIGHT_SCALE, max_tandem);
			session->result.noise_vector[r] = 0;
			choice_sum += dev;
			choice_count++;
		} else if (dev >= -stddev) {
			session->result.choice_vector[r] = 0;
			session->result.noise_vector[r] =
				(s32)(TE_WEIGHT_SCALE -
				      abs((int)div64_s64(dev * TE_WEIGHT_SCALE, stddev)));
			noise_sum += (s64)session->result.noise_vector[r];
			noise_count++;
		} else {
			session->result.choice_vector[r] =
				(s32)div64_s64(dev * TE_WEIGHT_SCALE, max_tandem);
			session->result.noise_vector[r] = 0;
		}
	}

	/* Step 4: Compute magnitudes */
	if (choice_count > 0)
		session->result.choice_magnitude =
			div64_s64(choice_sum * TE_WEIGHT_SCALE,
				  max_tandem * choice_count);
	else
		session->result.choice_magnitude = 0;

	if (noise_count > 0)
		session->result.noise_magnitude = div64_s64(noise_sum, noise_count);
	else
		session->result.noise_magnitude = 0;

	if (session->result.choice_magnitude > TE_WEIGHT_SCALE)
		session->result.choice_magnitude = TE_WEIGHT_SCALE;
	if (session->result.choice_magnitude < 0)
		session->result.choice_magnitude = 0;
	if (session->result.noise_magnitude > TE_WEIGHT_SCALE)
		session->result.noise_magnitude = TE_WEIGHT_SCALE;
	if (session->result.noise_magnitude < 0)
		session->result.noise_magnitude = 0;

	/* Find dominant column */
	max_col_val = 0;
	for (c = 0; c < TE_MATRIX_DIM; c++) {
		if ((s64)session->matrix[max_row][c] > max_col_val) {
			max_col_val = session->matrix[max_row][c];
			max_col = c;
		}
	}
	session->result.dominant_row = max_row;
	session->result.dominant_col = max_col;

	snprintf(session->result.choice_summary,
		 sizeof(session->result.choice_summary),
		 "Choice resolves at axis %u->%u (mag %lld/1000, %d axes)",
		 max_row, max_col, session->result.choice_magnitude, choice_count);
	snprintf(session->result.noise_summary,
		 sizeof(session->result.noise_summary),
		 "Equal noise: %d axes unresolved (mag %lld/1000)",
		 noise_count, session->result.noise_magnitude);

	session->result.valid = true;
	session->state = TE_STATE_RESOLVED;

	pr_info("tandem_equals: Resolved '%s' — choice=%lld, noise=%lld\n",
		session->domain, session->result.choice_magnitude,
		session->result.noise_magnitude);
}


/* ============================================================
 * Proc Interface
 * ============================================================ */

/* --- /proc/tandem_equals/status --- */
static int te_proc_status_show(struct seq_file *m, void *v)
{
	seq_printf(m, "=== TandemEquals: Saimptom Resolution ===\n\n");
	seq_printf(m, "  Matrix:    %dx%d (%d cells)\n",
		   TE_MATRIX_DIM, TE_MATRIX_DIM, TE_MATRIX_CELLS);
	seq_printf(m, "  Stereo answers needed: %d\n", TE_STEREO_ANSWERS);
	seq_printf(m, "\n");

	if (!te_current || te_current->state == TE_STATE_IDLE) {
		seq_printf(m, "  State: IDLE (no dilemma loaded)\n");
		seq_printf(m, "  Use: echo '<domain>' > /proc/tandem_equals/resolve\n");
		return 0;
	}

	seq_printf(m, "  Domain:    %s\n", te_current->domain);
	seq_printf(m, "  State:     %s\n",
		   te_current->state == TE_STATE_LOADED ? "LOADED" :
		   te_current->state == TE_STATE_ANSWERING ? "ANSWERING" :
		   te_current->state == TE_STATE_RESOLVING ? "RESOLVING" :
		   te_current->state == TE_STATE_RESOLVED ? "RESOLVED" : "?");
	seq_printf(m, "\n");
	seq_printf(m, "  Stereo Recovery:\n");
	seq_printf(m, "    Answers given:   %u / %d\n",
		   te_current->stereo.answers_given, TE_STEREO_ANSWERS);
	seq_printf(m, "    Overconfidence:  %d / 1000\n",
		   te_current->stereo.overconfidence);
	seq_printf(m, "    Stereo mind:     %s\n",
		   te_current->stereo.stereo_recovered ? "RECOVERED" : "not yet");

	if (te_current->stereo.province_wisdom[0])
		seq_printf(m, "    Province wisdom: %s\n",
			   te_current->stereo.province_wisdom);

	if (te_current->result.valid) {
		seq_printf(m, "\n  Resolution:\n");
		seq_printf(m, "    %s\n", te_current->result.choice_summary);
		seq_printf(m, "    %s\n", te_current->result.noise_summary);
	}

	return 0;
}

static int te_proc_status_open(struct inode *inode, struct file *file)
{
	return single_open(file, te_proc_status_show, NULL);
}

static const struct proc_ops te_proc_status_ops = {
	.proc_open = te_proc_status_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};


/* --- /proc/tandem_equals/resolve --- */
/*
 * Write a domain name to begin resolution.
 * Or write "answer <value>" to provide a stereo answer.
 */
static ssize_t te_proc_resolve_write(struct file *file,
				     const char __user *buf,
				     size_t count, loff_t *ppos)
{
	char kbuf[128];
	s32 answer_val;

	if (count >= sizeof(kbuf))
		return -EINVAL;
	if (copy_from_user(kbuf, buf, count))
		return -EFAULT;
	kbuf[count] = '\0';
	if (count > 0 && kbuf[count - 1] == '\n')
		kbuf[count - 1] = '\0';

	mutex_lock(&te_global_lock);

	/* "answer <value>" — provide a stereo recovery answer */
	if (strncmp(kbuf, "answer ", 7) == 0) {
		if (!te_current || te_current->state < TE_STATE_LOADED) {
			mutex_unlock(&te_global_lock);
			return -EINVAL;
		}
		if (kstrtos32(kbuf + 7, 10, &answer_val)) {
			mutex_unlock(&te_global_lock);
			return -EINVAL;
		}
		te_current->state = TE_STATE_ANSWERING;
		te_process_answer(te_current, answer_val);

		/* Auto-resolve after 12 answers */
		if (te_current->stereo.answers_given >= TE_STEREO_ANSWERS)
			te_resolve(te_current);

		mutex_unlock(&te_global_lock);
		return count;
	}

	/* "resolve" — force resolve with current state */
	if (strcmp(kbuf, "resolve") == 0) {
		if (!te_current || te_current->state < TE_STATE_LOADED) {
			mutex_unlock(&te_global_lock);
			return -EINVAL;
		}
		te_resolve(te_current);
		mutex_unlock(&te_global_lock);
		return count;
	}

	/* Otherwise: domain name — start a new session */
	if (!te_current) {
		te_current = kzalloc(sizeof(*te_current), GFP_KERNEL);
		if (!te_current) {
			mutex_unlock(&te_global_lock);
			return -ENOMEM;
		}
		mutex_init(&te_current->lock);
	}

	/* Reset session */
	memset(&te_current->result, 0, sizeof(te_current->result));
	memset(&te_current->stereo, 0, sizeof(te_current->stereo));
	strncpy(te_current->domain, kbuf, TE_MAX_DOMAIN_NAME - 1);
	te_current->uid = current_fsuid();

	te_seed_matrix(te_current, kbuf);
	te_current->state = TE_STATE_LOADED;

	mutex_unlock(&te_global_lock);

	pr_info("tandem_equals: Domain '%s' loaded. Provide 12 answers "
		"to regain stereo mind.\n", kbuf);

	return count;
}

static const struct proc_ops te_proc_resolve_ops = {
	.proc_write = te_proc_resolve_write,
};


/* --- /proc/tandem_equals/result --- */
static int te_proc_result_show(struct seq_file *m, void *v)
{
	int r;

	if (!te_current || !te_current->result.valid) {
		seq_printf(m, "(no resolution computed yet)\n");
		seq_printf(m, "Use: echo '<domain>' > /proc/tandem_equals/resolve\n");
		seq_printf(m, "Then: echo 'answer <val>' twelve times.\n");
		return 0;
	}

	seq_printf(m, "=== TandemEquals Resolution Result ===\n\n");
	seq_printf(m, "Domain: %s\n\n", te_current->domain);
	seq_printf(m, "CHOICE:  %s\n", te_current->result.choice_summary);
	seq_printf(m, "NOISE:   %s\n\n", te_current->result.noise_summary);

	seq_printf(m, "Stereo State:\n");
	seq_printf(m, "  Answers:        %u\n", te_current->stereo.answers_given);
	seq_printf(m, "  Overconfidence: %d/1000%s\n",
		   te_current->stereo.overconfidence,
		   te_current->stereo.overconfidence > TE_OVERCONF_THRESHOLD
		   ? " (HIGH — mono mind)" : " (healthy — stereo)");
	seq_printf(m, "  Stereo mind:    %s\n",
		   te_current->stereo.stereo_recovered ? "RECOVERED" : "NOT YET");

	if (te_current->stereo.province_wisdom[0])
		seq_printf(m, "\n  Province Wisdom:\n    %s\n",
			   te_current->stereo.province_wisdom);

	seq_printf(m, "\nChoice Vector (non-zero axes):\n");
	for (r = 0; r < TE_MATRIX_DIM; r++) {
		if (te_current->result.choice_vector[r] != 0)
			seq_printf(m, "  Axis %2d: %+5d\n",
				   r, te_current->result.choice_vector[r]);
	}

	seq_printf(m, "\nNoise Vector (non-zero axes):\n");
	for (r = 0; r < TE_MATRIX_DIM; r++) {
		if (te_current->result.noise_vector[r] != 0)
			seq_printf(m, "  Axis %2d: %5d (ambiguous)\n",
				   r, te_current->result.noise_vector[r]);
	}

	return 0;
}

static int te_proc_result_open(struct inode *inode, struct file *file)
{
	return single_open(file, te_proc_result_show, NULL);
}

static const struct proc_ops te_proc_result_ops = {
	.proc_open = te_proc_result_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};


/* --- /proc/tandem_equals/domains --- */
static int te_proc_domains_show(struct seq_file *m, void *v)
{
	int i;

	seq_printf(m, "=== Available Choice Domains ===\n\n");
	seq_printf(m, "Select a domain to begin saimptom resolution:\n");
	seq_printf(m, "  echo '<domain>' > /proc/tandem_equals/resolve\n\n");

	for (i = 0; te_domain_names[i]; i++)
		seq_printf(m, "  %-14s\n", te_domain_names[i]);

	seq_printf(m, "\nAfter selecting domain, provide 12 answers:\n");
	seq_printf(m, "  echo 'answer <-1000..1000>' > /proc/tandem_equals/resolve\n");
	seq_printf(m, "\n");
	seq_printf(m, "Positive values = lean toward one end of the saimptom.\n");
	seq_printf(m, "Negative values = lean toward the other end.\n");
	seq_printf(m, "Values near zero = genuine uncertainty (healthy stereo).\n");
	seq_printf(m, "\n");
	seq_printf(m, "After 12 answers, TandemEquals resolves your dilemma into:\n");
	seq_printf(m, "  CHOICE = the direction that resolves\n");
	seq_printf(m, "  EQUAL NOISE = what remains honestly ambiguous\n");
	seq_printf(m, "  PROVINCE WISDOM = contextual truth revealed by stereo\n");

	return 0;
}

static int te_proc_domains_open(struct inode *inode, struct file *file)
{
	return single_open(file, te_proc_domains_show, NULL);
}

static const struct proc_ops te_proc_domains_ops = {
	.proc_open = te_proc_domains_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release,
};


/* ============================================================
 * Module Init / Exit
 * ============================================================ */

static int __init tandem_equals_init(void)
{
	pr_info("tandem_equals: ═══════════════════════════════════════\n");
	pr_info("tandem_equals: TandemEquals v1.0.0 — Saimptom Resolution\n");
	pr_info("tandem_equals: Matrix: %dx%d | Stereo recovery: %d answers\n",
		TE_MATRIX_DIM, TE_MATRIX_DIM, TE_STEREO_ANSWERS);
	pr_info("tandem_equals: ═══════════════════════════════════════\n");

	te_proc_dir = proc_mkdir("tandem_equals", NULL);
	if (!te_proc_dir)
		return -ENOMEM;

	proc_create("status", 0444, te_proc_dir, &te_proc_status_ops);
	proc_create("resolve", 0222, te_proc_dir, &te_proc_resolve_ops);
	proc_create("result", 0444, te_proc_dir, &te_proc_result_ops);
	proc_create("domains", 0444, te_proc_dir, &te_proc_domains_ops);

	pr_info("tandem_equals: Interface: /proc/tandem_equals/\n");
	pr_info("tandem_equals: Domains: cat /proc/tandem_equals/domains\n");
	pr_info("tandem_equals: Begin: echo 'career' > /proc/tandem_equals/resolve\n");
	pr_info("tandem_equals: Answer: echo 'answer 500' > /proc/tandem_equals/resolve\n");
	pr_info("tandem_equals: Result: cat /proc/tandem_equals/result\n");

	return 0;
}

static void __exit tandem_equals_exit(void)
{
	if (te_proc_dir)
		proc_remove(te_proc_dir);

	kfree(te_current);
	te_current = NULL;

	pr_info("tandem_equals: Module unloaded.\n");
}

module_init(tandem_equals_init);
module_exit(tandem_equals_exit);
