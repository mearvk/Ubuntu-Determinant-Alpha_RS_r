/* -*- buffer-read-only: t -*- vi: set ro:
 *
 * Prototypes for agen5
 * Generated Sun Aug 26 10:44:48 PDT 2018
 */
#ifndef AGEN5_PROTO_H_GUARD
#define AGEN5_PROTO_H_GUARD 1


/*
 * Static declarations from agCgi.c
 */
static void
load_cgi(void);

/*
 * Static declarations from agDep.c
 */
static void
add_source_file(char const * pz);

static void
rm_source_file(char const * pz);

static void
add_target_file(char const * pz);

static void
rm_target_file(char const * pz);

static void
start_dep_file(void);

static void
wrap_up_depends(void);

/*
 * Static declarations from agInit.c
 */
static void
initialize(int arg_ct, char ** arg_vec);

static void
init_scm(void);

static char const *
make_quote_str(char const * str);

static void
dep_usage(char const * fmt, ...);

static void
config_dep(tOptions * opts, tOptDesc * od);

static void
add_sys_env(char * env_name);

static void
prep_env(void);

/*
 * Static declarations from agShell.c
 */
static void
close_server_shell(void);

static void
handle_signal(int signo);

static void
set_orig_dir(void);

static bool
send_cmd_ok(char const * cmd);

static void
start_server_cmd_trace(void);

static void
send_server_init_cmds(void);

static void
server_setup(void);

static int
chain_open(int in_fd, char const ** arg_v, pid_t * child_pid);

static pid_t
server_open(fd_pair_t * fd_pair, char const ** ppArgs);

static pid_t
server_fp_open(fp_pair_t * fp_pair, char const ** ppArgs);

static inline void
realloc_text(char ** p_txt, size_t * p_sz, size_t need_len);

static char *
load_data(void);

static char *
shell_cmd(char const * cmd);

/*
 * Static declarations from agUtils.c
 */
static void
fswarn(char const * op, char const * fname);

static char *
aprf(char const * pzFmt, ...);

static void
define_base_name(void);

static void
put_defines_into_env(void);

static void
open_trace_file(char ** av, tOptDesc * odsc);

static void
check_make_dep_env(void);

static void
process_ag_opts(int arg_ct, char ** arg_vec);

static char const *
get_define_str(char const * de_name, bool check_env);

static char *
span_quote(char * in_q);

static char const *
skip_quote(char const * qstr);

static char const *
skip_scheme(char const * scan,  char const * end);

static char const *
skip_expr(char const * src, size_t len);

/*
 * Static declarations from autogen.c
 */
static noreturn void
cleanup_and_abort(int sig);

static void
catch_sig_and_bail(int sig);

static void
ignore_signal(int sig);

static void
done_check(void);

static noreturn void
ag_abend_at(char const * msg
#ifdef DEBUG_ENABLED
            , char const * fname, int line
#endif
    );

static void *
ao_malloc (size_t sz);

static void *
ao_realloc (void *p, size_t sz);

static char *
ao_strdup(char const * str);

/*
 * Static declarations from defDirect.c
 */
static char *
end_of_directive(char * scan);

static char *
processDirective(char * scan);

static int
count_lines(char const * start, char const * end);

static char *
next_directive(char * scan);

static char *
skip_to_endif(char * start);

static char *
skip_to_endmac(char * start);

static char *
skip_to_else_end(char * start);

static void
check_assert_str(char const * pz, char const * arg);

static size_t
file_size(char const * fname);

static char *
ignore_directive(directive_enum_t id, char const * arg, char * scan_next);

static char *
bad_dirv_ctx(directive_enum_t id, char const * arg, char * scan_next);

/*
 * Static declarations from defFind.c
 */
static int
canonical_name(char * pzD, char const * pzS, int srcLen);

static def_ent_t *
find_def_ent(char * name, bool * indexed);

static void
print_used_defines(void);

static def_ent_t **
find_def_ent_list(char * name);

/*
 * Static declarations from defLex.c
 */
static void
pop_context(void);

static int
count_nl(char const * pz);

static void
trim_whitespace(void);

static void
lex_escaped_char(void);

static tSuccess
lex_backquote(void);

static tSuccess
lex_comment(void);

static tSuccess
lex_dollar(void);

static tSuccess
lex_here_string(void);

static te_dp_event
yylex(void);

static void
yyerror(char * s);

static void
loadScheme(void);

static void
alist_to_autogen_def(void);

static char *
gather_name(char * scan, te_dp_event * ret_val);

static char *
build_here_str(char * scan);

/*
 * Static declarations from defLoad.c
 */
static def_ent_t *
new_def_ent(void);

static void
free_def_ent(def_ent_t * de);

static void
print_ent(def_ent_t * de);

static void
delete_ent(def_ent_t * de);

static def_ent_t *
number_and_insert_ent(char * name, char const * idx_str);

static void
mod_time_is_now(void);

static void
read_defs(void);

static void
unload_defs(void);

/*
 * Static declarations from expExtract.c
 */
static char *
load_file(char const * fname);

static char const *
load_extract_file(char const * new_fil);

static SCM
mk_empty_text(char const * start, char const * end, SCM def);

static SCM
get_text(char const * text, char const * start, char const * end, SCM def);

/*
 * Static declarations from expGuile.c
 */
static char *
ag_scm2zchars(SCM s, const char * type);

static teGuileType
ag_scm_type_e(SCM typ);

static SCM
ag_scm_c_eval_string_from_file_line(
    char const * pzExpr, char const * pzFile, int line);

/*
 * Static declarations from expMake.c
 */
static bool
handle_eol(char ** ppzi, char ** ppzo, char tabch, char * bol);

static bool
handle_sed_expr(char ** src_p, char ** out_p);

static size_t
script_size(char ** txt_p, char * tab);

/*
 * Static declarations from expOutput.c
 */
static int
current_line(FILE * fp);

static SCM
do_output_file_line(int line_delta, char const * fmt);

static void
make_readonly(void);

static void
open_output_file(char const * fname, size_t nmsz, char const * mode, int flags);

/*
 * Static declarations from expPrint.c
 */
static ssize_t
safePrintf(char ** ppzBuf, char const * pzFmt, void ** argV);

static SCM
run_printf(char const * pzFmt, int len, SCM alist);

/*
 * Static declarations from expString.c
 */
static size_t
stringify_for_sh(char * pzNew, uint_t qt, char const * pzDta);

static SCM
shell_stringify(SCM obj, uint_t qt);

static int
sub_count(char const * haystack, char const * needle);

static void
do_substitution(
    char const * src_str,
    ssize_t      str_len,
    SCM          match,
    SCM          repl,
    char **      ppz_res,
    ssize_t *    res_len);

static void
do_multi_subs(char ** ppzStr, ssize_t * pStrLen, SCM match, SCM repl);

static inline void
tr_char_range(unsigned char * ch_map, unsigned char * from, unsigned char * to);

/*
 * Static declarations from fmemopen.c
 */
static ssize_t
fmem_read(void *cookie, void *pBuf, size_t sz);

static ssize_t
fmem_write(void *cookie, const void *pBuf, size_t sz);

static int
fmem_close(void * cookie);

/*
 * Static declarations from funcCase.c
 */
static void
compile_re(regex_t * re, char const * pat, int flags);

static inline void
up_case(char * pz);

static tSuccess
Select_Compare(char const * sample, char const * pattern);

static tSuccess
Select_Compare_End(char const * sample, char const * pattern);

static tSuccess
Select_Compare_Start(char const * sample, char const * pattern);

static tSuccess
Select_Compare_Full(char const * sample, char const * pattern);

static tSuccess
Select_Equivalent(char const * sample, char const * pattern);

static tSuccess
Select_Equivalent_End(char const * sample, char const * pattern);

static tSuccess
Select_Equivalent_Start(char const * sample, char const * pattern);

static tSuccess
Select_Equivalent_Full(char const * sample, char const * pattern);

static tSuccess
Select_Match(char const * sample, char const * pattern);

static tSuccess
Select_Match_End(char const * sample, char const * pattern);

static tSuccess
Select_Match_Start(char const * sample, char const * pattern);

static tSuccess
Select_Match_Full(char const * sample, char const * pattern);

static tSuccess
Select_Match_Always(char const * sample, char const * pattern);

static tSuccess
Select_Match_Existence(char const * sample, char const * pattern);

static tSuccess
Select_Match_NonExistence(char const * sample, char const * pattern);

static bool
selection_type_complete(templ_t * tpl, macro_t * mac, char const ** psrc);

static macro_t *
mLoad_Select(templ_t * tpl, macro_t * mac, char const ** pscan);

/*
 * Static declarations from funcDef.c
 */
static void
parse_mac_args(templ_t * pT, macro_t * mac);

static templ_t *
new_template(templ_t * base_tpl, macro_t * mac, char const * scan);

static void
load_define_tpl(templ_t * tpl, char const ** ppzScan);

/*
 * Static declarations from funcEval.c
 */
static char const *
scm2display(SCM s);

static inline char const *
tpl_text(templ_t * tpl, macro_t * mac);

static void
tpl_warning(templ_t * tpl, macro_t * mac, char const * msg);

static char const *
is_mac_entry_ok(bool * allocated, def_ent_t * ent,
                int * code, templ_t * tpl, macro_t * mac);

static char const *
eval_mac_expr(bool * allocated);

static void
emit_insertion_file(char const * fname, FILE * outfp);

static SCM
eval(char const * expr);

static int
expr_type(char * pz);

/*
 * Static declarations from funcFor.c
 */
static for_state_t *
find_for_state(SCM which_scm);

static bool
next_def(bool invert, def_ent_t ** de_lst);

static inline t_word
set_loop_limit(def_ent_t * found);

static int
for_by_step(templ_t * pT, macro_t * pMac, def_ent_t * found);

static int
for_each(templ_t * tpl, macro_t * mac, def_ent_t * def_ent);

static void
load_for_in(char const * pzSrc, size_t srcLen, templ_t * pT, macro_t * pMac);

static for_state_t *
new_for_context(void);

static void
free_for_context(int pop_ct);

/*
 * Static declarations from funcIf.c
 */
static bool
eval_true(void);

static macro_t *
mLoad_Elif(templ_t * pT, macro_t * pMac, char const ** ppzScan);

static macro_t *
mLoad_Else(templ_t * pT, macro_t * pMac, char const ** ppzScan);

/*
 * Static declarations from functions.c
 */
static loop_jmp_type_t
call_gen_block(jmp_buf jbuf, templ_t * tpl, macro_t * mac, macro_t * end_mac);

static void
gen_new_block(templ_t * tpl);

/*
 * Static declarations from loadPseudo.c
 */
static char const *
do_scheme_expr(char const * text, char const * fname);

static char const *
do_suffix(char const * const text, char const * fname, int lineNo);

static char const *
handle_hash_line(char const * pz);

static te_pm_event
next_pm_token(char const ** ptext, te_pm_state fsm_state, char const * fnm);

static char const *
copy_mark(char const * text, char * marker, size_t * ret_ct);

static char const *
load_pseudo_mac(char const * text, char const * fname);

/*
 * Static declarations from tpLoad.c
 */
static templ_t *
find_tpl(char const * tpl_name);

static bool
read_okay(char const * fname);

static char const *
expand_dir(char const ** dir_pp, char * name_buf);

static inline bool
file_search_dirs(
    char const * in_name,
    char *       res_name,
    char const * const * sfx_list,
    char const * referring_tpl,
    size_t       nm_len,
    bool         no_suffix);

static tSuccess
find_file(char const * in_name,
          char *       res_name,
          char const * const * sfx_list,
          char const * referring_tpl);

static size_t
cnt_macros(char const * pz);

static void
load_macs(templ_t * tpl, char const * fname, char const * pzData);

static templ_t *
digest_tpl(tmap_info_t * minfo, char * fname);

static templ_t *
tpl_load(char const * fname, char const * referrer);

static void
tpl_unload(templ_t * tpl);

static void
cleanup(templ_t * tpl);

/*
 * Static declarations from tpParse.c
 */
static mac_func_t
func_code(char const ** pscan);

static char const *
find_mac_end(char const ** ppzMark);

static char const *
find_mac_start(char const * pz, macro_t ** ppm, templ_t * tpl);

static char const *
find_macro(templ_t * tpl, macro_t ** ppm, char const ** pscan);

static macro_t *
parse_tpl(macro_t * mac, char const ** p_scan);

/*
 * Static declarations from tpProcess.c
 */
static void
gen_block(templ_t * tpl, macro_t * mac, macro_t * emac);

static void
trace_macro(templ_t * tpl, macro_t * mac);

static void
do_stdout_tpl(templ_t * tpl);

static out_spec_t *
next_out_spec(out_spec_t * os);

static void
process_tpl(templ_t * tpl);

static void
set_utime(char const * fname);

static void
out_close(bool purge);

static void
open_output(out_spec_t * spec);

#endif /* AGEN5_PROTO_H_GUARD */
