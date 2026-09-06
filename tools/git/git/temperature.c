/*
 * Native temperature module implementation.
 *
 * Deterministic assessment of a scanned project and aggregation of the total
 * achievable value across a project set. This module is advisory and read-only;
 * it performs no staging, commit, or transport.
 */
#include "git-compat-util.h"
#include "temperature.h"

/*
 * Assess a single project. The caller supplies the observable signals
 * (idle age, and the two independent input strips quality_intention and
 * relative_importance); this fills in the derived band, the third strip
 * (achievable value), and the recandle flag.
 *
 * quality_intention and relative_importance are clamped into 0..100. The
 * derivation is deterministic and depends only on the supplied signals.
 * Returns 0 on success, -1 on invalid input.
 */
int git_temperature_assess(struct git_temperature_project *p,
			   const char *path,
			   uintmax_t idle_days,
			   uintmax_t commit_count,
			   uintmax_t file_count,
			   uint8_t quality_intention,
			   uint8_t relative_importance)
{
	if (!p || !path)
		return -1;

	p->path = path;
	p->idle_days = idle_days;
	p->commit_count = commit_count;
	p->file_count = file_count;
	p->band = git_temperature_band_for_days(idle_days);

	p->strips.quality_intention = git_temperature_clamp(quality_intention);
	p->strips.relative_importance = git_temperature_clamp(relative_importance);
	p->strips.achievable_value = git_temperature_achievable_value(
		p->strips.quality_intention, p->strips.relative_importance);

	p->recandle_candidate =
		git_temperature_is_recandle(p->band, &p->strips);

	return git_temperature_project_valid(p) ? 0 : -1;
}

/*
 * Aggregate the total achievable value over the total quality across a set of
 * projects. Returns, via out params, the summed achievable value and the summed
 * current quality (both overflow-checked). This expresses the module's headline
 * relationship at the repository level: how much total improvement is unlocked
 * relative to how much quality already exists.
 *
 * Returns 0 on success, -1 on invalid input or overflow.
 */
int git_temperature_totals(const struct git_temperature_project *projects,
			   size_t count,
			   uintmax_t *out_total_value,
			   uintmax_t *out_total_quality,
			   uintmax_t *out_recandle_count)
{
	uintmax_t total_value = 0;
	uintmax_t total_quality = 0;
	uintmax_t recandle = 0;
	size_t i;

	if ((count && !projects) || !out_total_value ||
	    !out_total_quality || !out_recandle_count)
		return -1;

	for (i = 0; i < count; i++) {
		const struct git_temperature_project *p = &projects[i];

		if (!git_temperature_project_valid(p))
			return -1;

		if (total_value > UINTMAX_MAX - p->strips.achievable_value)
			return -1;
		total_value += p->strips.achievable_value;

		if (total_quality > UINTMAX_MAX - p->strips.quality_intention)
			return -1;
		total_quality += p->strips.quality_intention;

		if (p->recandle_candidate) {
			if (recandle == UINTMAX_MAX)
				return -1;
			recandle++;
		}
	}

	*out_total_value = total_value;
	*out_total_quality = total_quality;
	*out_recandle_count = recandle;
	return 0;
}
