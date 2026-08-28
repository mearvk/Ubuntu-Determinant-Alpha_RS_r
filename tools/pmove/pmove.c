/*
 * pmove — explicit Parallel Move source entry point
 *
 * This source is derived directly from the repository's existing
 * tools/pcopy/pcopy.c implementation.  The implementation remains in one
 * place: pmove.c includes pcopy.c after renaming its main() entry point, then
 * invokes that same implementation as pmove.
 *
 * Keeping the shared implementation avoids two independently maintained
 * copy/move engines while making pmove a real, selectable source under
 * /tools.
 *
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

/* Rename the shared entry point while including the established source. */
#define main pcopy_shared_main
#include "../pcopy/pcopy.c"
#undef main

/*
 * The compiled program is named pmove, so the existing implementation's
 * argv[0] detection selects move semantics and enables:
 *   PCOPY_F_MOVE
 *   PCOPY_F_CROSS_DEVICE
 */
int main(int argc, char *argv[])
{
	return pcopy_shared_main(argc, argv);
}
