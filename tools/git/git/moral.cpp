/* C++ companion for the native moral/blessing policy. */
#include "git-compat-util.h"
#include "moral.h"

extern "C" int git_moral_bless(struct git_moral_blessing *blessing,
	uintmax_t spell_count, int great_user, const char *software)
{
	if (!blessing || !spell_count || !software)
		return -1;
	blessing->spell_count = spell_count;
	blessing->great_user = great_user != 0;
	blessing->mana = git_moral_mana_for_spells(
		spell_count, blessing->great_user);
	blessing->software = software;
	blessing->author = NULL;
	blessing->committer = NULL;
	blessing->date = NULL;
	blessing->timestamp = NULL;
	return git_moral_blessing_valid(blessing) ? 0 : -1;
}

extern "C" uintmax_t git_moral_total_mana(uintmax_t prior_mana,
	uintmax_t spell_count, int great_user)
{
	uintmax_t added = git_moral_mana_for_spells(spell_count, great_user);
	if (!added || prior_mana > UINTMAX_MAX - added)
		return 0;
	return prior_mana + added;
}
