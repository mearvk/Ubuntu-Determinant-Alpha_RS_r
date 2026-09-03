#ifndef PUSH_BUDGET_H
#define PUSH_BUDGET_H

#include "strbuf.h"
#include "oid-array.h"

/*
 * The Ubuntu Determinant Git policy places a hard default ceiling on a
 * single push effort. This is an object-graph budget, not a working-tree
 * file-size limit.
 */
#define GIT_PUSH_MAX_BYTES ((uintmax_t)200 * 1024 * 1024)

static int push_budget_add_local_tips(const struct refspec *rs,
				      struct oid_array *tips)
{
	struct ref *local_refs = get_local_heads();
	struct ref *ref;

	for (ref = local_refs; ref; ref = ref->next) {
		char *dst;

		dst = apply_refspecs((struct refspec *)rs, ref->name);
		if (!dst)
			continue;

		if (!is_null_oid(&ref->old_oid))
			oid_array_append(tips, &ref->old_oid);
		free(dst);
	}

	free_refs(local_refs);
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
				     int flags UNUSED)
{
	const struct ref *remote_refs;
	struct oid_array tips = OID_ARRAY_INIT;
	struct oid_array remote_tips = OID_ARRAY_INIT;
	uintmax_t bytes = 0;
	int ret = 0;

	/* A dry-run does not transfer data, but still performs the same analysis
	 * so users can see whether the real push would fit the policy. */
	remote_refs = transport_get_remote_refs(transport, NULL);
	if (!remote_refs)
		goto cleanup;

	if (!push_budget_add_local_tips(rs, &tips))
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

/*
 * The public transport_push() implementation remains authoritative for
 * matching, status, hooks, and transport-specific behavior. This front-end
 * performs the object-graph safety decision before handing control to it.
 */
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

#endif
