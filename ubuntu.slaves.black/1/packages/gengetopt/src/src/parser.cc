/* A Bison parser, made by GNU Bison 3.3.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.3.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 22 "../../src/parser.yy" /* yacc.c:337  */


#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <string>
#include <sstream>

#include "acceptedvalues.h"

#include "argsdef.h"

#include "gengetopt.h"
#include "errorcodes.h"
#include "ggos.h"
#include "yyerror.h"

extern int gengetopt_count_line;
extern char * gengetopt_input_filename;

static int gengetopt_package_given = 0;
static int gengetopt_version_given = 0;
static int gengetopt_purpose_given = 0;
static int gengetopt_versiontext_given = 0;
static int gengetopt_usage_given = 0;
static int gengetopt_description_given = 0;

/// the last option parsed
static gengetopt_option *current_option = 0;

extern int yylex (void) ;

//#define YYERROR_VERBOSE 1

using namespace std;

void check_result(int o, gengetopt_option *opt)
{
  if (o)
    {
        ostringstream err;

    switch (o)
    {
    case NOT_ENOUGH_MEMORY:
        yyerror (opt, "not enough memory");
    	break;
    case REQ_LONG_OPTION:
        err << "long option redefined \'" << opt->long_opt << "\'";
        yyerror (opt, err.str().c_str());
		break;
    case REQ_SHORT_OPTION:
        err << "short option redefined \'" << opt->short_opt << "\'";
        yyerror (opt, err.str().c_str());
        break;
    case FOUND_BUG:
        yyerror (opt, "bug found!!");
        break;
    case GROUP_UNDEFINED:
        yyerror (opt, "group undefined");
        break;
    case MODE_UNDEFINED:
        yyerror (opt, "mode undefined");
        break;
    case INVALID_DEFAULT_VALUE:
        yyerror (opt, "invalid default value");
        break;
    case NOT_REQUESTED_TYPE:
        yyerror (opt, "type specification not requested");
        break;
    case NOT_VALID_SPECIFICATION:
      yyerror (opt, "invalid specification for this kind of option");
      break;
    case SPECIFY_FLAG_STAT:
      yyerror (opt, "you must specify the default flag status");
      break;
    case NOT_GROUP_OPTION:
      yyerror (opt, "group specification for a non group option");
      break;
    case NOT_MODE_OPTION:
      yyerror (opt, "mode specification for an option not belonging to a mode");
      break;
    case SPECIFY_GROUP:
      yyerror (opt, "missing group specification");
      break;
    case SPECIFY_MODE:
      yyerror (opt, "missing mode specification");
      break;
    case INVALID_NUMERIC_VALUE:
        yyerror (opt, "invalid numeric value");
        break;
    case INVALID_ENUM_TYPE_USE:
    	yyerror (opt, "enum type can only be specified for options with values");
        break;
    case HELP_REDEFINED:
    	yyerror (opt, "if you want to redefine --help, please use option --no-help");
        break;
    case VERSION_REDEFINED:
    	yyerror (opt, "if you want to redefine --version, please use option --no-version");
        break;
    }
  }
}

/* the number of allowed occurrences of a multiple option */
struct multiple_size
{
    /* these strings are allocated dynamically and NOT
      automatically freed upon destruction */
    char *min;
    char *max;

    /* if no limit is specified then initialized to 0.
       if the same size is specified for min and max, it means that an exact
       number of occurrences is required*/
    multiple_size(const char *m = "0", const char *M = "0") :
        min(strdup(m)), max(strdup(M))
    {}
};

#define check_error if (o) YYERROR;


#line 198 "parser.cc" /* yacc.c:337  */
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parser.h".  */
#ifndef YY_YY_PARSER_H_INCLUDED
# define YY_YY_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_PACKAGE = 258,
    TOK_VERSION = 259,
    TOK_OPTION = 260,
    TOK_DEFGROUP = 261,
    TOK_GROUPOPTION = 262,
    TOK_DEFMODE = 263,
    TOK_MODEOPTION = 264,
    TOK_YES = 265,
    TOK_NO = 266,
    TOK_ON = 267,
    TOK_OFF = 268,
    TOK_FLAG = 269,
    TOK_PURPOSE = 270,
    TOK_DESCRIPTION = 271,
    TOK_USAGE = 272,
    TOK_DEFAULT = 273,
    TOK_GROUP = 274,
    TOK_GROUPDESC = 275,
    TOK_MODE = 276,
    TOK_MODEDESC = 277,
    TOK_MULTIPLE = 278,
    TOK_ARGOPTIONAL = 279,
    TOK_TYPESTR = 280,
    TOK_SECTION = 281,
    TOK_DETAILS = 282,
    TOK_SECTIONDESC = 283,
    TOK_TEXT = 284,
    TOK_VERSIONTEXT = 285,
    TOK_ARGS = 286,
    TOK_VALUES = 287,
    TOK_HIDDEN = 288,
    TOK_DEPENDON = 289,
    TOK_STRING = 290,
    TOK_CHAR = 291,
    TOK_ARGTYPE = 292,
    TOK_SIZE = 293
  };
#endif
/* Tokens.  */
#define TOK_PACKAGE 258
#define TOK_VERSION 259
#define TOK_OPTION 260
#define TOK_DEFGROUP 261
#define TOK_GROUPOPTION 262
#define TOK_DEFMODE 263
#define TOK_MODEOPTION 264
#define TOK_YES 265
#define TOK_NO 266
#define TOK_ON 267
#define TOK_OFF 268
#define TOK_FLAG 269
#define TOK_PURPOSE 270
#define TOK_DESCRIPTION 271
#define TOK_USAGE 272
#define TOK_DEFAULT 273
#define TOK_GROUP 274
#define TOK_GROUPDESC 275
#define TOK_MODE 276
#define TOK_MODEDESC 277
#define TOK_MULTIPLE 278
#define TOK_ARGOPTIONAL 279
#define TOK_TYPESTR 280
#define TOK_SECTION 281
#define TOK_DETAILS 282
#define TOK_SECTIONDESC 283
#define TOK_TEXT 284
#define TOK_VERSIONTEXT 285
#define TOK_ARGS 286
#define TOK_VALUES 287
#define TOK_HIDDEN 288
#define TOK_DEPENDON 289
#define TOK_STRING 290
#define TOK_CHAR 291
#define TOK_ARGTYPE 292
#define TOK_SIZE 293

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 150 "../../src/parser.yy" /* yacc.c:352  */

    char   *str;
    char    chr;
    int	    argtype;
    int	    boolean;
    class AcceptedValues *ValueList;
    struct gengetopt_option *gengetopt_option;
    struct multiple_size *multiple_size;

#line 327 "parser.cc" /* yacc.c:352  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_PARSER_H_INCLUDED  */



#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
             && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  46
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   91

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  44
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  28
/* YYNRULES -- Number of rules.  */
#define YYNRULES  68
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  119

#define YYUNDEFTOK  2
#define YYMAXUTOK   293

/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  ((unsigned) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      41,    42,     2,     2,    40,    43,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    39,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   212,   212,   214,   219,   220,   221,   222,   223,   224,
     225,   226,   227,   228,   229,   230,   231,   232,   237,   257,
     277,   297,   317,   338,   345,   362,   382,   389,   400,   411,
     431,   450,   472,   475,   481,   486,   491,   496,   501,   506,
     511,   516,   521,   526,   534,   539,   544,   549,   553,   554,
     558,   559,   560,   564,   565,   569,   570,   574,   575,   579,
     580,   584,   585,   589,   593,   594,   595,   596,   597
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"package\"", "\"version\"",
  "\"option\"", "\"defgroup\"", "\"groupoption\"", "\"defmode\"",
  "\"modeoption\"", "\"yes\"", "\"no\"", "\"on\"", "\"off\"", "\"flag\"",
  "\"purpose\"", "\"description\"", "\"usage\"", "\"default\"",
  "\"group\"", "\"groupdesc\"", "\"mode\"", "\"modedesc\"", "\"multiple\"",
  "\"argoptional\"", "\"typestr\"", "\"section\"", "\"details\"",
  "\"sectiondesc\"", "\"text\"", "\"versiontext\"", "\"args\"",
  "\"values\"", "\"hidden\"", "\"dependon\"", "TOK_STRING", "TOK_CHAR",
  "TOK_ARGTYPE", "TOK_SIZE", "'='", "','", "'('", "')'", "'-'", "$accept",
  "input", "statement", "package", "version", "purpose", "description",
  "usage", "sectiondef", "text", "versiontext", "args", "groupdef",
  "modedef", "option", "groupoption", "modeoption", "quoted_string",
  "option_parts", "req_onoff", "optional_yesno", "opt_yesno",
  "opt_groupdesc", "opt_modedesc", "opt_sectiondesc", "listofvalues",
  "acceptedvalue", "multiple_size", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,    61,
      44,    40,    41,    45
};
# endif

#define YYPACT_NINF -42

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-42)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
       2,   -13,    -8,    -6,    -5,    -1,     0,     1,     5,     5,
       5,     5,     5,     5,     6,    26,     2,   -42,   -42,   -42,
     -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,
     -42,   -42,   -42,     7,    17,     8,    16,    15,   -42,   -42,
     -42,   -42,    24,   -42,   -42,   -42,   -42,   -42,     5,    14,
       3,     5,    19,   -42,     5,    23,   -42,   -42,    21,   -42,
     -42,   -42,   -42,    29,   -42,    30,    36,   -42,    36,   -42,
      36,   -42,   -42,   -42,   -42,   -42,   -42,    27,    28,    32,
      31,   -42,    35,    37,    38,   -42,    39,   -42,   -42,   -42,
      40,    44,    45,   -23,   -42,    46,     5,    47,    48,   -42,
     -42,   -42,   -18,    50,   -42,   -42,   -42,    49,   -42,   -42,
     -42,   -26,    42,    47,    43,   -42,   -42,   -42,   -42
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     2,     4,     5,     7,
       8,     9,    10,    12,    13,     6,    15,    17,    11,    14,
      16,    18,    19,     0,    55,     0,    57,     0,    32,    20,
      21,    22,    59,    24,    25,    26,     1,     3,     0,     0,
      50,     0,     0,    28,     0,     0,    23,    47,     0,    51,
      52,    27,    47,     0,    47,     0,    29,    56,    30,    58,
      31,    60,    53,    54,    48,    49,    44,     0,     0,     0,
      64,    42,     0,     0,     0,    45,     0,    34,    46,    33,
       0,     0,     0,     0,    43,     0,     0,     0,     0,    38,
      39,    40,     0,     0,    35,    36,    63,    37,    61,    41,
      65,     0,     0,     0,     0,    66,    67,    62,    68
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -42,    70,   -42,   -42,   -42,   -42,   -42,   -42,   -42,   -42,
     -42,   -42,   -42,   -42,   -42,   -42,   -42,    -9,   -41,   -42,
     -42,   -42,   -42,   -42,   -42,   -42,   -22,   -42
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,    15,    16,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    39,    66,    88,
      61,    89,    50,    53,    56,   107,   108,    94
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      40,    41,    42,    43,    44,     1,     2,     3,     4,     5,
       6,     7,   114,    59,    60,   102,   115,     8,     9,    10,
     103,    68,    31,    70,   110,   111,    46,    32,    11,    33,
      34,    12,    13,    14,    35,    36,    37,    49,    52,    57,
      38,    45,    62,    48,    51,    64,    72,    73,    74,    75,
      76,    54,    55,    58,    77,    78,    67,    79,    63,    80,
      81,    82,    65,    83,    69,    71,    90,    91,    84,    85,
      86,    92,    93,    87,    95,    99,    96,    97,    98,   100,
     101,   104,   106,   109,   116,   118,    47,   105,   112,   113,
       0,   117
};

static const yytype_int8 yycheck[] =
{
       9,    10,    11,    12,    13,     3,     4,     5,     6,     7,
       8,     9,    38,    10,    11,    38,    42,    15,    16,    17,
      43,    62,    35,    64,    42,    43,     0,    35,    26,    35,
      35,    29,    30,    31,    35,    35,    35,    20,    22,    48,
      35,    35,    51,    36,    36,    54,    10,    11,    12,    13,
      14,    36,    28,    39,    18,    19,    35,    21,    39,    23,
      24,    25,    39,    27,    35,    35,    39,    39,    32,    33,
      34,    39,    41,    37,    39,    35,    39,    39,    39,    35,
      35,    35,    35,    35,    42,    42,    16,    96,    38,    40,
      -1,   113
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,     9,    15,    16,
      17,    26,    29,    30,    31,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    35,    35,    35,    35,    35,    35,    35,    35,    61,
      61,    61,    61,    61,    61,    35,     0,    45,    36,    20,
      66,    36,    22,    67,    36,    28,    68,    61,    39,    10,
      11,    64,    61,    39,    61,    39,    62,    35,    62,    35,
      62,    35,    10,    11,    12,    13,    14,    18,    19,    21,
      23,    24,    25,    27,    32,    33,    34,    37,    63,    65,
      39,    39,    39,    41,    71,    39,    39,    39,    39,    35,
      35,    35,    38,    43,    35,    61,    35,    69,    70,    35,
      42,    43,    38,    40,    38,    42,    42,    70,    42
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    44,    45,    45,    46,    46,    46,    46,    46,    46,
      46,    46,    46,    46,    46,    46,    46,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    62,    62,    62,    62,    62,    62,
      62,    62,    62,    62,    62,    62,    62,    62,    63,    63,
      64,    64,    64,    65,    65,    66,    66,    67,    67,    68,
      68,    69,    69,    70,    71,    71,    71,    71,    71
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     2,
       2,     2,     2,     3,     2,     2,     2,     4,     3,     5,
       5,     5,     1,     2,     2,     4,     4,     4,     4,     4,
       4,     4,     2,     3,     2,     2,     2,     0,     1,     1,
       0,     1,     1,     1,     1,     0,     3,     0,     3,     0,
       3,     1,     3,     1,     0,     3,     4,     4,     5
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static int
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  int res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  YYUSE (yylocationp);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyo, *yylocationp);
  YYFPRINTF (yyo, ": ");
  yy_symbol_value_print (yyo, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
{
  unsigned long yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return (YYSIZE_T) (yystpcpy (yyres, yystr) - yyres);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Location data for the lookahead symbol.  */
YYLTYPE yylloc
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.
       'yyls': related to locations.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yynewstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  *yyssp = (yytype_int16) yystate;

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = (YYSIZE_T) (yyssp - yyss + 1);

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yyls1, yysize * sizeof (*yylsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
        yyls = yyls1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location. */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  yyerror_range[1] = yyloc;
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 18:
#line 238 "../../src/parser.yy" /* yacc.c:1652  */
    {
	      if (gengetopt_package_given)
		{
		  yyerror ("package redefined");
		  YYERROR;
		}
	      else
		{
		  gengetopt_package_given = 1;
		  if (gengetopt_define_package ((yyvsp[0].str)))
		    {
		      yyerror ("not enough memory");
		      YYERROR;
		    }
		}
	    }
#line 1626 "parser.cc" /* yacc.c:1652  */
    break;

  case 19:
#line 258 "../../src/parser.yy" /* yacc.c:1652  */
    {
	      if (gengetopt_version_given)
		{
		  yyerror ("version redefined");
		  YYERROR;
		}
	      else
		{
		  gengetopt_version_given = 1;
		  if (gengetopt_define_version ((yyvsp[0].str)))
		    {
		      yyerror ("not enough memory");
		      YYERROR;
		    }
		}
	    }
#line 1647 "parser.cc" /* yacc.c:1652  */
    break;

  case 20:
#line 278 "../../src/parser.yy" /* yacc.c:1652  */
    {
	      if (gengetopt_purpose_given)
		{
		  yyerror ("purpose redefined");
		  YYERROR;
		}
	      else
		{
		  gengetopt_purpose_given = 1;
		  if (gengetopt_define_purpose ((yyvsp[0].str)))
		    {
		      yyerror ("not enough memory");
		      YYERROR;
		    }
		}
	    }
#line 1668 "parser.cc" /* yacc.c:1652  */
    break;

  case 21:
#line 298 "../../src/parser.yy" /* yacc.c:1652  */
    {
	      if (gengetopt_description_given)
		{
		  yyerror ("description redefined");
		  YYERROR;
		}
	      else
		{
		  gengetopt_description_given = 1;
		  if (gengetopt_define_description ((yyvsp[0].str)))
		    {
		      yyerror ("not enough memory");
		      YYERROR;
		    }
		}
	    }
#line 1689 "parser.cc" /* yacc.c:1652  */
    break;

  case 22:
#line 318 "../../src/parser.yy" /* yacc.c:1652  */
    {
      if (gengetopt_usage_given)
      {
	  yyerror ("usage redefined");
	  YYERROR;
      }
      else
      {
	  gengetopt_usage_given = 1;
	  if (gengetopt_define_usage ((yyvsp[0].str)))
          {
	      yyerror ("not enough memory");
	      YYERROR;
          }
      }
  }
#line 1710 "parser.cc" /* yacc.c:1652  */
    break;

  case 23:
#line 339 "../../src/parser.yy" /* yacc.c:1652  */
    {
                gengetopt_set_section ((yyvsp[-1].str), (yyvsp[0].str));
              }
#line 1718 "parser.cc" /* yacc.c:1652  */
    break;

  case 24:
#line 346 "../../src/parser.yy" /* yacc.c:1652  */
    {
            	if (current_option) {
            		std::string current_option_text;
            		if (current_option->text_after) {
            			current_option_text = std::string(current_option->text_after) + (yyvsp[0].str);
            			current_option->text_after = strdup(current_option_text.c_str()); 
            		} else {
	            		current_option->text_after = strdup((yyvsp[0].str));
	            	}
            	} else {
					gengetopt_set_text((yyvsp[0].str));
  				}
            }
#line 1736 "parser.cc" /* yacc.c:1652  */
    break;

  case 25:
#line 363 "../../src/parser.yy" /* yacc.c:1652  */
    {
	    	if (gengetopt_versiontext_given)
	        {
		    yyerror ("versiontext redefined");
		    YYERROR;
		}
		else
		{
		    gengetopt_versiontext_given = 1;
		    if (gengetopt_define_versiontext ((yyvsp[0].str)))
		    {
			yyerror ("not enough memory");
			YYERROR;
		    }
		}
	    }
#line 1757 "parser.cc" /* yacc.c:1652  */
    break;

  case 26:
#line 383 "../../src/parser.yy" /* yacc.c:1652  */
    {
  gengetopt_set_args((yyvsp[0].str));
            }
#line 1765 "parser.cc" /* yacc.c:1652  */
    break;

  case 27:
#line 390 "../../src/parser.yy" /* yacc.c:1652  */
    {
              if (gengetopt_add_group ((yyvsp[-2].str), (yyvsp[-1].str), (yyvsp[0].boolean)))
                {
		  	yyerror ("group redefined");
		  	YYERROR;
		  }
	    }
#line 1777 "parser.cc" /* yacc.c:1652  */
    break;

  case 28:
#line 401 "../../src/parser.yy" /* yacc.c:1652  */
    {
              if (gengetopt_add_mode ((yyvsp[-1].str), (yyvsp[0].str)))
                {
		  	yyerror ("mode redefined");
		  	YYERROR;
		  }
	    }
#line 1789 "parser.cc" /* yacc.c:1652  */
    break;

  case 29:
#line 413 "../../src/parser.yy" /* yacc.c:1652  */
    {
          (yyvsp[0].gengetopt_option)->filename = gengetopt_input_filename;
          (yyvsp[0].gengetopt_option)->linenum = (yylsp[-4]).first_line;
	      (yyvsp[0].gengetopt_option)->long_opt = strdup((yyvsp[-3].str));
	      if ((yyvsp[-2].chr) != '-')
	      	(yyvsp[0].gengetopt_option)->short_opt = (yyvsp[-2].chr);
	      (yyvsp[0].gengetopt_option)->desc = strdup((yyvsp[-1].str));
	      int o = gengetopt_check_option ((yyvsp[0].gengetopt_option), false);
	      check_result(o, (yyvsp[0].gengetopt_option));
          check_error;
	      o = gengetopt_add_option ((yyvsp[0].gengetopt_option));
	      check_result(o, (yyvsp[0].gengetopt_option));
	      check_error;
	      current_option = (yyvsp[0].gengetopt_option);
	    }
#line 1809 "parser.cc" /* yacc.c:1652  */
    break;

  case 30:
#line 433 "../../src/parser.yy" /* yacc.c:1652  */
    {
          (yyvsp[0].gengetopt_option)->filename = gengetopt_input_filename;
          (yyvsp[0].gengetopt_option)->linenum = (yylsp[-4]).first_line;
	      (yyvsp[0].gengetopt_option)->long_opt = strdup((yyvsp[-3].str));
          if ((yyvsp[-2].chr) != '-')
            (yyvsp[0].gengetopt_option)->short_opt = (yyvsp[-2].chr);
          (yyvsp[0].gengetopt_option)->desc = strdup((yyvsp[-1].str));
          int o = gengetopt_check_option ((yyvsp[0].gengetopt_option), true);
          check_result(o, (yyvsp[0].gengetopt_option));
          check_error;
          o = gengetopt_add_option ((yyvsp[0].gengetopt_option));
          check_result(o, (yyvsp[0].gengetopt_option));
          check_error;
	    }
#line 1828 "parser.cc" /* yacc.c:1652  */
    break;

  case 31:
#line 452 "../../src/parser.yy" /* yacc.c:1652  */
    {
          (yyvsp[0].gengetopt_option)->filename = gengetopt_input_filename;
          (yyvsp[0].gengetopt_option)->linenum = (yylsp[-4]).first_line;
	      (yyvsp[0].gengetopt_option)->long_opt = strdup((yyvsp[-3].str));
          if ((yyvsp[-2].chr) != '-')
            (yyvsp[0].gengetopt_option)->short_opt = (yyvsp[-2].chr);
          (yyvsp[0].gengetopt_option)->desc = strdup((yyvsp[-1].str));
          int o = gengetopt_check_option ((yyvsp[0].gengetopt_option), false, true);
          check_result(o, (yyvsp[0].gengetopt_option));
          check_error;
          o = gengetopt_add_option ((yyvsp[0].gengetopt_option));
          check_result(o, (yyvsp[0].gengetopt_option));
          check_error;
	    }
#line 1847 "parser.cc" /* yacc.c:1652  */
    break;

  case 33:
#line 476 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-1].gengetopt_option);
			  	(yyval.gengetopt_option)->required = (yyvsp[0].boolean);
			  	(yyval.gengetopt_option)->required_set = true;
			  }
#line 1857 "parser.cc" /* yacc.c:1652  */
    break;

  case 34:
#line 482 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-1].gengetopt_option);
			  	(yyval.gengetopt_option)->type = (yyvsp[0].argtype);
			  }
#line 1866 "parser.cc" /* yacc.c:1652  */
    break;

  case 35:
#line 487 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
			  	(yyval.gengetopt_option)->type_str = strdup((yyvsp[0].str));
			  }
#line 1875 "parser.cc" /* yacc.c:1652  */
    break;

  case 36:
#line 492 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
			  	(yyval.gengetopt_option)->details = strdup((yyvsp[0].str));
			  }
#line 1884 "parser.cc" /* yacc.c:1652  */
    break;

  case 37:
#line 497 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
			  	(yyval.gengetopt_option)->acceptedvalues = (yyvsp[0].ValueList);
			  }
#line 1893 "parser.cc" /* yacc.c:1652  */
    break;

  case 38:
#line 502 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
			  	(yyval.gengetopt_option)->default_string = strdup((yyvsp[0].str));
			  }
#line 1902 "parser.cc" /* yacc.c:1652  */
    break;

  case 39:
#line 507 "../../src/parser.yy" /* yacc.c:1652  */
    {
                (yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
                (yyval.gengetopt_option)->group_value = strdup((yyvsp[0].str));
              }
#line 1911 "parser.cc" /* yacc.c:1652  */
    break;

  case 40:
#line 512 "../../src/parser.yy" /* yacc.c:1652  */
    {
                (yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
                (yyval.gengetopt_option)->mode_value = strdup((yyvsp[0].str));
              }
#line 1920 "parser.cc" /* yacc.c:1652  */
    break;

  case 41:
#line 517 "../../src/parser.yy" /* yacc.c:1652  */
    {
                (yyval.gengetopt_option) = (yyvsp[-3].gengetopt_option);
                (yyval.gengetopt_option)->dependon = strdup((yyvsp[0].str));
              }
#line 1929 "parser.cc" /* yacc.c:1652  */
    break;

  case 42:
#line 522 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-1].gengetopt_option);
			  	(yyval.gengetopt_option)->arg_is_optional = true;
			  }
#line 1938 "parser.cc" /* yacc.c:1652  */
    break;

  case 43:
#line 527 "../../src/parser.yy" /* yacc.c:1652  */
    {
			  	(yyval.gengetopt_option) = (yyvsp[-2].gengetopt_option);
			  	(yyval.gengetopt_option)->multiple = true;
                (yyval.gengetopt_option)->multiple_min = (yyvsp[0].multiple_size)->min;
                (yyval.gengetopt_option)->multiple_max = (yyvsp[0].multiple_size)->max;
                delete (yyvsp[0].multiple_size);
			  }
#line 1950 "parser.cc" /* yacc.c:1652  */
    break;

  case 44:
#line 535 "../../src/parser.yy" /* yacc.c:1652  */
    {
          (yyval.gengetopt_option) = (yyvsp[-1].gengetopt_option);
          (yyval.gengetopt_option)->type = ARG_FLAG;
        }
#line 1959 "parser.cc" /* yacc.c:1652  */
    break;

  case 45:
#line 540 "../../src/parser.yy" /* yacc.c:1652  */
    {
          (yyval.gengetopt_option) = (yyvsp[-1].gengetopt_option);
          (yyval.gengetopt_option)->hidden = true;
        }
#line 1968 "parser.cc" /* yacc.c:1652  */
    break;

  case 46:
#line 545 "../../src/parser.yy" /* yacc.c:1652  */
    {
          (yyval.gengetopt_option) = (yyvsp[-1].gengetopt_option);
          (yyval.gengetopt_option)->flagstat = (yyvsp[0].boolean);
        }
#line 1977 "parser.cc" /* yacc.c:1652  */
    break;

  case 47:
#line 549 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.gengetopt_option) = new gengetopt_option; }
#line 1983 "parser.cc" /* yacc.c:1652  */
    break;

  case 48:
#line 553 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 1; }
#line 1989 "parser.cc" /* yacc.c:1652  */
    break;

  case 49:
#line 554 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 0; }
#line 1995 "parser.cc" /* yacc.c:1652  */
    break;

  case 50:
#line 558 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 0; }
#line 2001 "parser.cc" /* yacc.c:1652  */
    break;

  case 51:
#line 559 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 1; }
#line 2007 "parser.cc" /* yacc.c:1652  */
    break;

  case 52:
#line 560 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 0; }
#line 2013 "parser.cc" /* yacc.c:1652  */
    break;

  case 53:
#line 564 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 1; }
#line 2019 "parser.cc" /* yacc.c:1652  */
    break;

  case 54:
#line 565 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.boolean) = 0; }
#line 2025 "parser.cc" /* yacc.c:1652  */
    break;

  case 55:
#line 569 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = 0; }
#line 2031 "parser.cc" /* yacc.c:1652  */
    break;

  case 56:
#line 570 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = (yyvsp[0].str); }
#line 2037 "parser.cc" /* yacc.c:1652  */
    break;

  case 57:
#line 574 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = 0; }
#line 2043 "parser.cc" /* yacc.c:1652  */
    break;

  case 58:
#line 575 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = (yyvsp[0].str); }
#line 2049 "parser.cc" /* yacc.c:1652  */
    break;

  case 59:
#line 579 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = 0; }
#line 2055 "parser.cc" /* yacc.c:1652  */
    break;

  case 60:
#line 580 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = (yyvsp[0].str); }
#line 2061 "parser.cc" /* yacc.c:1652  */
    break;

  case 61:
#line 584 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.ValueList) = new AcceptedValues; (yyval.ValueList)->insert((yyvsp[0].str)); }
#line 2067 "parser.cc" /* yacc.c:1652  */
    break;

  case 62:
#line 585 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyvsp[-2].ValueList)->insert((yyvsp[0].str)); (yyval.ValueList) = (yyvsp[-2].ValueList); }
#line 2073 "parser.cc" /* yacc.c:1652  */
    break;

  case 63:
#line 589 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.str) = (yyvsp[0].str); }
#line 2079 "parser.cc" /* yacc.c:1652  */
    break;

  case 64:
#line 593 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.multiple_size) = new multiple_size; }
#line 2085 "parser.cc" /* yacc.c:1652  */
    break;

  case 65:
#line 594 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.multiple_size) = new multiple_size((yyvsp[-1].str), (yyvsp[-1].str)); }
#line 2091 "parser.cc" /* yacc.c:1652  */
    break;

  case 66:
#line 595 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.multiple_size) = new multiple_size((yyvsp[-2].str), "0"); free((yyvsp[-2].str)); }
#line 2097 "parser.cc" /* yacc.c:1652  */
    break;

  case 67:
#line 596 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.multiple_size) = new multiple_size("0", (yyvsp[-1].str)); free((yyvsp[-1].str)); }
#line 2103 "parser.cc" /* yacc.c:1652  */
    break;

  case 68:
#line 597 "../../src/parser.yy" /* yacc.c:1652  */
    { (yyval.multiple_size) = new multiple_size((yyvsp[-3].str), (yyvsp[-1].str)); free((yyvsp[-3].str)); free((yyvsp[-1].str)); }
#line 2109 "parser.cc" /* yacc.c:1652  */
    break;


#line 2113 "parser.cc" /* yacc.c:1652  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }

  yyerror_range[1] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 600 "../../src/parser.yy" /* yacc.c:1918  */

