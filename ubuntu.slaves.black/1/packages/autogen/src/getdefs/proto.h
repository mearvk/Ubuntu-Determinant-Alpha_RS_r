/* -*- buffer-read-only: t -*- vi: set ro:
 *
 * Prototypes for getdefs
 * Generated Sun Aug 26 10:44:48 PDT 2018
 */
#ifndef GETDEFS_PROTO_H_GUARD
#define GETDEFS_PROTO_H_GUARD 1


/*
 * Static declarations from gdemit.c
 */
static void
compress_def(char * pz);

static char *
list_attrib(char * pzText, char * pzOut);

static char *
emit_quote(char ** ppzText, char * pzOut);

static void
next_def_entry(char ** txt_pp, char const ** def_pp);

static void
emit_attribute(char const ** def_pp, char ** out_pp);

static char *
emit_subblock(char const * pzDefList, char * pzText, char * pzOut);

static char *
subblock_str(char ** ppzText, uint_t sepChar, char * pzOut);

/*
 * Static declarations from getdefs.c
 */
static char *
assignIndex(char * pzOut, char * pzDef);

static int
awaitAutogen(void);

static void
buildDefinition(char * pzDef, char const * pzFile, int line, char * pzOut);

static tSuccess
buildPreamble(char ** ppzDef, char ** ppzOut, char const * fname, int line);

static int
compar_defname(const void * p1, const void * p2);

static int
compar_text(const void * p1, const void * p2);

static void
doPreamble(FILE * outFp);

static char *
loadFile(char const * pzFname);

static void
printEntries(FILE * fp);

static void
processFile(char const * fname);

static void
set_first_idx(void);

static FILE *
open_ag_file(char ** pzBase);

static FILE *
open_ag_proc_pipe(char ** pzBase);

static void
exec_autogen(char ** pzBase);

static FILE *
startAutogen(void);

static void
update_db(void);

#endif /* GETDEFS_PROTO_H_GUARD */
