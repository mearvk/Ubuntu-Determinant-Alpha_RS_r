#ifndef PUSH_BUDGET_H
#define PUSH_BUDGET_H

#include "strbuf.h"
#include "oid-array.h"
#include "refs.h"
#include "resume-budget.h"

/* Hard native ceiling: 200 MiB per push effort. */
#define GIT_PUSH_MAX_BYTES ((uintmax_t)200 * 1024 * 1024)

struct push_budget_refs {
	struct refspec *rs;
	struct oid_array *tips;
	int mirror;
};

static int push_budget_has_matching_refspec(const struct refspec *rs)
{
	for (int i = 0; i < rs->nr; i++)
		if (rs->items[i].matching)
			return 1;
	return 0;
}

static int push_budget_collect_ref(const struct reference *ref, void *cb_data)
{
	struct push_budget_refs *data = cb_data;
	char *dst;

	if (!ref->oid || (ref->flags & REF_ISBROKEN))
		return 0;

	/* A plain ':' push means matching branches, except --mirror, which
	 * intentionally operates on the complete local ref namespace. */
	if (push_budget_has_matching_refspec(data->rs) && !data->mirror &&
	    !starts_with(ref->name, "refs/heads/"))
		return 0;

	dst = apply_refspecs(data->rs, ref->name);
	if (!dst)
		return 0;

	oid_array_append(data->tips, ref->oid);
	free(dst);
	return 0;
}

static int push_budget_add_local_tips(const struct refspec *rs,
				      struct oid_array *tips, int mirror)
{
	struct push_budget_refs data = {
		.rs = (struct refspec *)rs,
		.tips = tips,
		.mirror = mirror,
	};
	struct object_id head_oid;

	refs_for_each_ref(get_main_ref_store(the_repository),
			  push_budget_collect_ref, &data);

	/* HEAD is not part of refs_for_each_ref(). Explicit HEAD refspecs still
	 * need their commit included in the budget. */
	for (int i = 0; i < rs->nr; i++) {
		if (rs->items[i].src && !strcmp(rs->items[i].src, "HEAD") &&
		    !repo_get_oid(the_repository, "HEAD", &head_oid)) {
			oid_array_append(tips, &head_oid);
			break;
		}
	}

	return tips->nr != 0;
}

static void push_budget_add_remote_tips(const struct ref *refs,
					struct oid_array *tips)
{
	for (; refs; refs = refs->next)
		if (!is_null_oid(&refs->old_oid))
			oid_array_append(tips, &refs->old_oid);
}

static int push_budget_measure(const struct oid_array *tips,
				       const struct oid_array *remote_tips,
				       uintmax_t *bytes)
{
	struct child_process cmd = CHILD_PROCESS_INIT;
	struct strbuf out = STRBUF_INIT;
	char *end;
	uintmax_t value;
	int ret;

	strvec_push(&cmd.args, "rev-list");
	strvec_push(&cmd.args, "--disk-usage");
	strvec_push(&cmd.args, "--objects");
	strvec_push(&cmd.args, "--use-bitmap-index");

	for (size_t i = 0; i < tips->nr; i++)
		strvec_push(&cmd.args, oid_to_hex(&tips->oid[i]));

	if (remote_tips->nr) {
		strvec_push(&cmd.args, "--not");
		for (size_t i = 0; i < remote_tips->nr; i++)
			strvec_push(&cmd.args, oid_to_hex(&remote_tips->oid[i]));
	}

	cmd.git_cmd = 1;
	ret = capture_command(&cmd, &out, 64);
	if (ret) {
		strbuf_release(&out);
		return -1;
	}

	strbuf_rtrim(&out);
	if (!out.len) {
		strbuf_release(&out);
		return -1;
	}

	errno = 0;
	value = strtoumax(out.buf, &end, 10);
	if (errno || end == out.buf || *end) {
		strbuf_release(&out);
		return -1;
	}

	*bytes = value;
	strbuf_release(&out);
	return 0;
}

static int push_budget_check(struct transport *transport,
				     struct refspec *rs,
				     int flags)
{
	const struct ref *remote_refs;
	struct oid_array tips = OID_ARRAY_INIT;
	struct oid_array remote_tips = OID_ARRAY_INIT;
	uintmax_t bytes = 0;
	int ret = 0;

	/* Fetch the remote advertisement once. transport_push() will reuse the
	 * transport's cached advertisement rather than needing a second lookup. */
	remote_refs = transport_get_remote_refs(transport, NULL);

	if (!push_budget_add_local_tips(rs, &tips,
					flags & TRANSPORT_PUSH_MIRROR))
		goto cleanup;

	push_budget_add_remote_tips(remote_refs, &remote_tips);

	if (push_budget_measure(&tips, &remote_tips, &bytes) < 0) {
		error(_("unable to calculate the Git push object budget"));
		ret = -1;
		goto cleanup;
	}

	if (transport->verbose >= 0)
		fprintf(stderr,
			_("Git push object budget: %" PRIuMAX
			  " bytes of %" PRIuMAX " bytes maximum\n"),
			bytes, GIT_PUSH_MAX_BYTES);

	if (bytes > GIT_PUSH_MAX_BYTES) {
		error(_("Git push rejected: estimated object payload exceeds the 200 MiB maximum"));
		error(_("No push was attempted; reduce the commit set or push in smaller logical units."));
		ret = -1;
	}

cleanup:
	oid_array_clear(&tips);
	oid_array_clear(&remote_tips);
	return ret;
}

/* Native front-end used by builtin push callers. The original transport_push()
 * remains the authoritative implementation for negotiation, hooks, status,
 * and transport-specific transfer behavior. */
static inline int transport_push_with_budget(struct repository *repo,
					     struct transport *connection,
					     struct refspec *rs,
					     int flags,
					     unsigned int *reject_reasons)
{
	if (push_budget_check(connection, rs, flags) < 0)
		return -1;

	return transport_push(repo, connection, rs, flags, reject_reasons);
}

/*
 * Count the candidate local push tips whose object id already appears among
 * the remote's advertised tips. This is a coarse, ref-level acknowledgement
 * signal: it does not decode individual 50 MiB units, but it lets the resume
 * front-end distinguish "the remote already has our tips" (nothing to do) from
 * "work remains" without inventing progress the remote never confirmed.
 */
static int push_budget_acked_tips(struct transport *transport,
				  struct refspec *rs, int flags)
{
	const struct ref *remote_refs = transport_get_remote_refs(transport, NULL);
	struct oid_array tips = OID_ARRAY_INIT;
	struct oid_array remote_tips = OID_ARRAY_INIT;
	int acked = 0;

	push_budget_add_local_tips(rs, &tips, flags & TRANSPORT_PUSH_MIRROR);
	push_budget_add_remote_tips(remote_refs, &remote_tips);

	for (size_t i = 0; i < tips.nr; i++) {
		for (size_t j = 0; j < remote_tips.nr; j++) {
			if (oideq(&tips.oid[i], &remote_tips.oid[j])) {
				acked++;
				break;
			}
		}
	}

	oid_array_clear(&tips);
	oid_array_clear(&remote_tips);
	return acked;
}

/*
 * Resume-aware native push front-end for slow or lossy connections.
 *
 * Semantics:
 *   - The 200 MiB object budget guard runs before every transport attempt.
 *   - Progress is measured only by the remote's acknowledged tips, never by
 *     what was merely attempted (see resume-budget.h).
 *   - On a transport failure the still-unacknowledged remainder is retried up
 *     to the checkpoint's attempt ceiling, then the effort HALTs rather than
 *     looping.
 *   - The checkpoint never authorizes an oversized transfer; the guard remains
 *     authoritative every attempt.
 *
 * `cp` must be initialised by the caller (git_resume_checkpoint_init). Its
 * total_units/max_attempts describe the effort; the front-end updates its
 * acked_units/attempt/state. Returns 0 once the remote acknowledges the tips,
 * or -1 when the effort halts with work remaining or the guard rejects it.
 */
static inline int transport_push_resume(struct repository *repo,
					struct transport *connection,
					struct refspec *rs,
					int flags,
					unsigned int *reject_reasons,
					struct git_resume_checkpoint *cp)
{
	if (!git_resume_checkpoint_valid(cp))
		return -1;

	/* Record what the remote already acknowledges before we start. */
	if (push_budget_acked_tips(connection, rs, flags) > 0 &&
	    git_resume_is_complete(cp))
		return 0;

	while (git_resume_begin_attempt(cp) > 0) {
		int err;

		/* The budget guard re-measures the real object graph here. */
		err = transport_push_with_budget(repo, connection, rs, flags,
						 reject_reasons);

		if (!err) {
			/*
			 * The transport reported success. Confirm against the
			 * remote advertisement and mark the effort complete
			 * only on genuine acknowledgement.
			 */
			if (push_budget_acked_tips(connection, rs, flags) > 0) {
				git_resume_record_outcome(cp, git_resume_units_remaining(cp), 0);
				if (git_resume_is_complete(cp))
					return 0;
			} else {
				git_resume_record_outcome(cp, 0, 1);
			}
		} else {
			/* Interruption: no new units acknowledged; retry. */
			git_resume_record_outcome(cp, 0, 1);
		}

		if (cp->state == GIT_RESUME_HALT)
			break;
	}

	return git_resume_is_complete(cp) ? 0 : -1;
}

#endif
