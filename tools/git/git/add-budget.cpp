/*
 * C++ policy mirror for native add scheduling.
 *
 * The vendored Git engine is C; this companion source records the same
 * deterministic policy for C++ consumers in the surrounding project.
 * It intentionally has no dependency on a shell wrapper or external
 * scheduler.
 */

#include <cstdint>
#include <limits>

namespace git_add_policy {

static constexpr std::uintmax_t block_bytes = 100u * 1024u * 1024u;
static constexpr std::uintmax_t blocks_per_push = 2;

std::uintmax_t block_for_bytes(std::uintmax_t bytes)
{
	if (bytes == 0)
		return 1;
	return ((bytes - 1) / block_bytes) + 1;
}

bool would_cross_boundary(std::uintmax_t current_bytes,
			 std::uintmax_t file_bytes)
{
	if (file_bytes == 0)
		return false;
	if (current_bytes > std::numeric_limits<std::uintmax_t>::max() - file_bytes)
		return true;

	const auto next = current_bytes + file_bytes;
	return block_for_bytes(next) != block_for_bytes(current_bytes) &&
		current_bytes % block_bytes != 0;
}

std::uintmax_t push_capacity_bytes()
{
	return blocks_per_push * block_bytes;
}

} // namespace git_add_policy
