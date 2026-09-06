/*
 * Ubuntu Determinant native "temperature" module.
 *
 * `temperature` is a read-only advisory AI module. It scans the repository for
 * projects (subtrees) that were started and may since have been left alone,
 * and reports which ones could still be improved or "recandled" (revived).
 *
 * The metaphor is thermal: a project with recent activity is "warm"; one that
 * has gone quiet is "cold". A cold project that is nonetheless important and
 * improvable is the strongest recandle candidate.
 *
 * The module is advisory only. It never stages, commits, pushes, or rewrites
 * anything, and its scores never gate any Git operation. Like the other native
 * modules its outputs supplement Git; they never replace object identity or
 * history. Scores are deterministic given the same inputs and are explicitly
 * NOT derived from author identity, appearance, credentials, or IQ — only from
 * observable project signals the caller supplies.
 */

#ifndef GIT_TEMPERATURE_H
#define GIT_TEMPERATURE_H

#include "git-compat-util.h"
#include <stdint.h>

/*
 * All learner-strip scores are on a fixed 0..100 integer scale so the output
 * is stable and comparable across projects and runs.
 */
#define GIT_TEMPERATURE_SCALE_MAX ((uint8_t)100)

/*
 * Thermal band derived from how recently a project changed. "Cold" projects
 * are the ones most likely to have been left alone.
 */
enum git_temperature_band {
	GIT_TEMPERATURE_COLD = 0,  /* long idle; likely abandoned          */
	GIT_TEMPERATURE_COOL,      /* idle a while                          */
	GIT_TEMPERATURE_WARM,      /* recently touched                      */
	GIT_TEMPERATURE_HOT        /* actively worked                       */
};

/* Idle-age band boundaries in days. Deterministic, policy-level constants. */
#define GIT_TEMPERATURE_HOT_MAX_DAYS   14U   /* <= 14d idle => hot   */
#define GIT_TEMPERATURE_WARM_MAX_DAYS  60U   /* <= 60d idle => warm  */
#define GIT_TEMPERATURE_COOL_MAX_DAYS  180U  /* <= 180d idle => cool */
/* > COOL_MAX_DAYS => cold */

/*
 * The three learner strips.
 *
 *  1. quality_intention: how good and how deliberate the project looks
 *     (structure, docs, tests, coherent intent). Higher = better shape.
 *  2. relative_importance: how much this project matters relative to the
 *     rest of the repository (size/centrality/dependencies).
 *  3. achievable_value: the total value unlockable by fully improving it.
 *     This is DEFINED as improvement headroom measured over current quality:
 *     the room to grow (100 - quality) weighted by importance. A high-quality
 *     project has little headroom; a low-quality but important one has much.
 *
 * A "strip" is simply a labeled 0..100 gauge in the printed output.
 */
struct git_temperature_strips {
	uint8_t quality_intention;   /* strip 1: quality & intention  */
	uint8_t relative_importance; /* strip 2: relative importance  */
	uint8_t achievable_value;    /* strip 3: total achievable value */
};

/* A single scanned project and its temperature assessment. */
struct git_temperature_project {
	const char *path;            /* project subtree path            */
	uintmax_t idle_days;         /* days since last observed change */
	uintmax_t commit_count;      /* observed commits touching it    */
	uintmax_t file_count;        /* files in the subtree            */
	enum git_temperature_band band;
	struct git_temperature_strips strips;
	int recandle_candidate;      /* cold + important + improvable   */
};

/* Recandle thresholds: an important, improvable project gone cold/cool. */
#define GIT_TEMPERATURE_RECANDLE_MIN_IMPORTANCE ((uint8_t)40)
#define GIT_TEMPERATURE_RECANDLE_MIN_VALUE      ((uint8_t)40)

static inline int git_temperature_band_valid(enum git_temperature_band b)
{
	return b >= GIT_TEMPERATURE_COLD && b <= GIT_TEMPERATURE_HOT;
}

/* Map an idle age in days to a thermal band. */
static inline enum git_temperature_band git_temperature_band_for_days(
						uintmax_t idle_days)
{
	if (idle_days <= GIT_TEMPERATURE_HOT_MAX_DAYS)
		return GIT_TEMPERATURE_HOT;
	if (idle_days <= GIT_TEMPERATURE_WARM_MAX_DAYS)
		return GIT_TEMPERATURE_WARM;
	if (idle_days <= GIT_TEMPERATURE_COOL_MAX_DAYS)
		return GIT_TEMPERATURE_COOL;
	return GIT_TEMPERATURE_COLD;
}

/* Human-readable band label; never returns NULL. */
static inline const char *git_temperature_band_label(enum git_temperature_band b)
{
	switch (b) {
	case GIT_TEMPERATURE_HOT:  return "hot";
	case GIT_TEMPERATURE_WARM: return "warm";
	case GIT_TEMPERATURE_COOL: return "cool";
	case GIT_TEMPERATURE_COLD:
	default:                   return "cold";
	}
}

/* Clamp an arbitrary value into the 0..100 strip scale. */
static inline uint8_t git_temperature_clamp(uintmax_t v)
{
	return v > GIT_TEMPERATURE_SCALE_MAX ?
		GIT_TEMPERATURE_SCALE_MAX : (uint8_t)v;
}

/*
 * Strip 3, the defining relationship: total achievable value is the
 * improvement headroom (100 - quality) taken *over* current quality, scaled by
 * importance. Concretely: headroom * importance / 100, so a project that is
 * already excellent (quality ~ 100) yields near-zero achievable value, while an
 * important project with low quality yields a high value. Deterministic and
 * overflow-safe (all inputs are <= 100).
 */
static inline uint8_t git_temperature_achievable_value(uint8_t quality_intention,
						uint8_t relative_importance)
{
	unsigned headroom;

	if (quality_intention >= GIT_TEMPERATURE_SCALE_MAX)
		return 0;
	headroom = (unsigned)GIT_TEMPERATURE_SCALE_MAX - quality_intention;
	/* headroom (<=100) * importance (<=100) <= 10000; safe in unsigned. */
	return git_temperature_clamp(
		((uintmax_t)headroom * relative_importance) /
		GIT_TEMPERATURE_SCALE_MAX);
}

/*
 * A project is a recandle candidate when it has gone cold or cool AND is
 * important enough AND has enough achievable value to be worth reviving.
 */
static inline int git_temperature_is_recandle(enum git_temperature_band band,
					const struct git_temperature_strips *s)
{
	if (!s)
		return 0;
	if (band != GIT_TEMPERATURE_COLD && band != GIT_TEMPERATURE_COOL)
		return 0;
	return s->relative_importance >= GIT_TEMPERATURE_RECANDLE_MIN_IMPORTANCE &&
		s->achievable_value >= GIT_TEMPERATURE_RECANDLE_MIN_VALUE;
}

static inline int git_temperature_strips_valid(
					const struct git_temperature_strips *s)
{
	return s &&
		s->quality_intention   <= GIT_TEMPERATURE_SCALE_MAX &&
		s->relative_importance <= GIT_TEMPERATURE_SCALE_MAX &&
		s->achievable_value    <= GIT_TEMPERATURE_SCALE_MAX;
}

static inline int git_temperature_project_valid(
				const struct git_temperature_project *p)
{
	return p && p->path && git_temperature_band_valid(p->band) &&
		git_temperature_strips_valid(&p->strips);
}

/*
 * The exported scan/aggregate functions are implemented in temperature.c and
 * temperature.cpp. They are intentionally not forward-declared here so each
 * translation unit can declare them with the linkage it needs (C, or
 * extern "C" from C++), matching the convention used by the other native
 * operation headers.
 */

#endif /* GIT_TEMPERATURE_H */
