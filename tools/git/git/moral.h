/* Native moral/blessing policy for the Git operation model. */
#ifndef GIT_MORAL_H
#define GIT_MORAL_H

#ifdef __cplusplus
#include <cstdint>
#include <cstddef>
#else
#include "git-compat-util.h"
#include <stdint.h>
#endif

#define GIT_MORAL_MANA_PER_SPELL ((uintmax_t)1)
#define GIT_MORAL_GREAT_MANA_PER_SPELL ((uintmax_t)10)

struct git_moral_blessing {
	uintmax_t spell_count;
	uintmax_t mana;
	int great_user;
	const char *software;
	const char *author;
	const char *committer;
	const char *date;
	const char *timestamp;
};

static inline uintmax_t git_moral_mana_for_spell(int great_user)
{
	return great_user ? GIT_MORAL_GREAT_MANA_PER_SPELL :
		GIT_MORAL_MANA_PER_SPELL;
}

static inline uintmax_t git_moral_mana_for_spells(uintmax_t spells,
	int great_user)
{
	uintmax_t per_spell = git_moral_mana_for_spell(great_user);
	if (!spells || spells > UINTMAX_MAX / per_spell)
		return 0;
	return spells * per_spell;
}

static inline int git_moral_blessing_valid(
	const struct git_moral_blessing *blessing)
{
	return blessing && blessing->software && blessing->spell_count &&
		blessing->mana == git_moral_mana_for_spells(
			blessing->spell_count, blessing->great_user);
}

#endif /* GIT_MORAL_H */
