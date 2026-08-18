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
#define YYPURE 2

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 42 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:337  */

#ifndef BUILD_GENTOOLS
# include <config.h>
#endif
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <ctype.h>
#include <errno.h>

#ifdef BUILD_GENTOOLS
# include "gen-help.h"
#else
# include "util.h"
# include "ksba.h"
#endif

#include "asn1-func.h"

/* It would be better to make yyparse static but there is no way to do
   this.  Let's hope that this macros works. */
#define yyparse _ksba_asn1_yyparse

/* #define YYDEBUG 1 */
#define MAX_STRING_LENGTH 129

/* Dummy print so that yytoknum will be defined.  */
#define YYPRINT(F, N, L)  do { } while (0);


/* constants used in the grammar */
enum {
  CONST_EXPLICIT = 1,
  CONST_IMPLICIT
};

struct parser_control_s {
  FILE *fp;
  int lineno;
  int debug;
  int result_parse;
  AsnNode parse_tree;
  AsnNode all_nodes;
};
#define PARSECTL ((struct parser_control_s *)parm)


#line 119 "asn1-parse.c" /* yacc.c:337  */
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
# define YYERROR_VERBOSE 1
#endif


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
    ASSIG = 258,
    NUM = 259,
    IDENTIFIER = 260,
    OPTIONAL = 261,
    INTEGER = 262,
    SIZE = 263,
    OCTET = 264,
    STRING = 265,
    SEQUENCE = 266,
    BIT = 267,
    UNIVERSAL = 268,
    PRIVATE = 269,
    DEFAULT = 270,
    CHOICE = 271,
    OF = 272,
    OBJECT = 273,
    STR_IDENTIFIER = 274,
    ksba_BOOLEAN = 275,
    ksba_TRUE = 276,
    ksba_FALSE = 277,
    APPLICATION = 278,
    ANY = 279,
    DEFINED = 280,
    SET = 281,
    BY = 282,
    EXPLICIT = 283,
    IMPLICIT = 284,
    DEFINITIONS = 285,
    TAGS = 286,
    ksba_BEGIN = 287,
    ksba_END = 288,
    UTCTime = 289,
    GeneralizedTime = 290,
    FROM = 291,
    IMPORTS = 292,
    TOKEN_NULL = 293,
    ENUMERATED = 294,
    UTF8STRING = 295,
    NUMERICSTRING = 296,
    PRINTABLESTRING = 297,
    TELETEXSTRING = 298,
    IA5STRING = 299,
    UNIVERSALSTRING = 300,
    BMPSTRING = 301
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 97 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:352  */

  unsigned int constant;
  char str[MAX_STRING_LENGTH];
  AsnNode node;

#line 212 "asn1-parse.c" /* yacc.c:352  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif



int yyparse (void *parm);



/* Second part of user prologue.  */
#line 103 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:354  */

static AsnNode new_node (struct parser_control_s *parsectl, node_type_t type);
#define NEW_NODE(a)  (new_node (PARSECTL, (a)))
static void set_name (AsnNode node, const char *name);
static void set_str_value (AsnNode node, const char *text);
static void set_ulong_value (AsnNode node, const char *text);
static void set_right (AsnNode node, AsnNode right);
static void append_right (AsnNode node, AsnNode right);
static void set_down (AsnNode node, AsnNode down);


static int yylex (YYSTYPE *lvalp, void *parm);
static void yyerror (void *parm, const char *s);

#line 242 "asn1-parse.c" /* yacc.c:354  */

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
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

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
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   195

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  57
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  51
/* YYNRULES -- Number of rules.  */
#define YYNRULES  116
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  203

#define YYUNDEFTOK  2
#define YYMAXUTOK   301

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
      49,    50,     2,    47,    51,    48,    56,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    52,     2,    53,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    54,     2,    55,     2,     2,     2,     2,
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
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   184,   184,   185,   188,   189,   192,   199,   200,   203,
     204,   207,   208,   211,   216,   224,   225,   250,   255,   263,
     265,   272,   273,   274,   277,   283,   291,   293,   298,   305,
     310,   315,   322,   326,   332,   343,   349,   353,   359,   365,
     374,   378,   384,   388,   396,   397,   404,   405,   412,   414,
     421,   423,   430,   431,   438,   440,   447,   448,   457,   458,
     459,   460,   461,   462,   463,   469,   477,   481,   488,   492,
     500,   508,   514,   519,   526,   527,   528,   529,   530,   531,
     532,   533,   534,   535,   536,   537,   538,   544,   548,   559,
     563,   570,   577,   584,   586,   593,   598,   603,   612,   617,
     622,   631,   638,   642,   654,   661,   668,   677,   686,   687,
     690,   692,   699,   708,   724,   725,   728
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"::=\"", "NUM", "IDENTIFIER",
  "\"OPTIONAL\"", "\"INTEGER\"", "\"SIZE\"", "\"OCTET\"", "\"STRING\"",
  "\"SEQUENCE\"", "\"BIT\"", "\"UNIVERSAL\"", "\"PRIVATE\"", "\"DEFAULT\"",
  "\"CHOICE\"", "\"OF\"", "\"OBJECT\"", "\"IDENTIFIER\"", "\"BOOLEAN\"",
  "\"TRUE\"", "\"FALSE\"", "\"APPLICATION\"", "\"ANY\"", "\"DEFINED\"",
  "\"SET\"", "\"BY\"", "\"EXPLICIT\"", "\"IMPLICIT\"", "\"DEFINITIONS\"",
  "\"TAGS\"", "\"BEGIN\"", "\"END\"", "\"UTCTime\"", "\"GeneralizedTime\"",
  "\"FROM\"", "\"IMPORTS\"", "\"NULL\"", "\"ENUMERATED\"",
  "\"UTF8String\"", "\"NumericString\"", "\"PrintableString\"",
  "\"TeletexString\"", "\"IA5String\"", "\"UniversalString\"",
  "\"BMPString\"", "'+'", "'-'", "'('", "')'", "','", "'['", "']'", "'{'",
  "'}'", "'.'", "$accept", "input", "pos_num", "neg_num", "pos_neg_num",
  "num_identifier", "pos_neg_identifier", "constant", "constant_list",
  "obj_constant", "obj_constant_list", "class", "tag_type", "tag",
  "default", "integer_def", "boolean_def", "Time", "size_def2", "size_def",
  "octet_string_def", "utf8_string_def", "numeric_string_def",
  "printable_string_def", "teletex_string_def", "ia5_string_def",
  "universal_string_def", "bmp_string_def", "string_def", "bit_element",
  "bit_element_list", "bit_string_def", "enumerated_def", "object_def",
  "type_assig_right", "type_assig_right_tag",
  "type_assig_right_tag_default", "type_assig", "type_assig_list",
  "sequence_def", "set_def", "choise_def", "any_def", "type_def",
  "constant_def", "type_constant", "type_constant_list", "definitions_id",
  "imports_def", "explicit_implicit", "definitions", YY_NULLPTR
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
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,    43,    45,    40,
      41,    44,    91,    93,   123,   125,    46
};
# endif

#define YYPACT_NINF -137

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-137)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -137,    33,  -137,   -39,     0,  -137,    76,   115,  -137,     4,
    -137,  -137,    -1,  -137,  -137,    15,    63,  -137,  -137,    59,
      77,    86,  -137,  -137,   105,    24,  -137,  -137,  -137,    18,
      52,   126,   129,   128,  -137,  -137,    16,    94,   139,    17,
     140,    97,   133,  -137,   130,    20,  -137,  -137,  -137,    99,
      16,    16,    16,    16,    16,    16,    16,    22,   117,    96,
     107,  -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,
    -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,
    -137,   100,   153,   155,   110,   152,  -137,  -137,     7,    16,
      96,   156,   146,   111,   156,  -137,   137,    96,   156,   149,
     162,  -137,  -137,  -137,  -137,  -137,  -137,  -137,   116,  -137,
    -137,  -137,   164,  -137,  -137,  -137,    84,    76,  -137,   118,
      84,   120,   122,    37,  -137,    -3,  -137,  -137,    52,  -137,
      51,    96,   162,    58,   168,  -137,    60,    96,   125,  -137,
      66,  -137,   123,  -137,   119,     3,    76,    -6,  -137,    37,
    -137,   173,   174,  -137,  -137,   131,     7,  -137,    34,  -137,
     156,  -137,  -137,    68,  -137,  -137,  -137,  -137,   175,   162,
    -137,  -137,   124,  -137,     5,  -137,   127,   132,  -137,  -137,
    -137,  -137,  -137,    78,  -137,  -137,  -137,   134,  -137,    84,
    -137,    84,  -137,  -137,  -137,  -137,  -137,  -137,  -137,   135,
     136,  -137,  -137
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     1,     0,     0,     3,     0,     0,     9,    10,
      17,    19,     0,   114,   115,     0,     0,   112,    20,     0,
       0,     0,    18,   113,     0,     0,   108,   109,   110,     0,
       0,     0,     0,     0,   116,   111,    72,    32,     0,     0,
       0,     0,     0,    35,   102,     0,    36,    37,    86,     0,
      44,    46,    48,    50,    52,    54,    56,     0,    26,     0,
      74,    76,    78,    79,    58,    59,    60,    61,    62,    63,
      64,    77,    80,    75,    82,    87,   104,    81,    85,    83,
      84,     0,     0,     0,     0,     0,    40,    73,     0,    42,
       0,     0,     0,    68,     0,    71,     0,     0,     0,     0,
       0,    45,    47,    49,    51,    53,    55,    57,     0,    21,
      22,    23,     0,    27,    28,    88,     0,     0,   107,     0,
       0,     0,     0,     0,    15,     0,    43,    96,     0,    93,
       0,     0,     0,     0,     0,    99,     0,     0,     0,    66,
       0,    24,     0,    10,     0,     0,     0,     0,    41,     0,
       4,     0,     0,     7,     8,     0,     0,    33,    89,    92,
       0,    95,    97,     0,   101,   103,    98,   100,     0,     0,
      70,    25,     0,   106,     0,    38,     0,     0,     5,     6,
      13,    16,    91,     0,    90,    94,    69,     0,    67,     0,
     105,     0,    14,    12,    30,    31,    11,    29,    65,     0,
       0,    34,    39
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -137,  -137,  -137,  -137,  -136,  -114,  -137,    31,  -137,   -12,
    -103,  -137,  -137,  -137,  -137,  -137,  -137,  -137,   103,   -34,
    -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,  -137,    21,
      57,  -137,  -137,  -137,   -58,    64,  -137,    35,    30,  -137,
    -137,  -137,  -137,  -137,  -137,   165,  -137,  -137,  -137,  -137,
    -137
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,   153,   154,   155,    10,   197,   124,   125,    11,
      12,   112,    58,    59,   184,    60,    61,    62,    86,    87,
      63,    64,    65,    66,    67,    68,    69,    70,    71,   139,
     140,    72,    73,    74,    75,    76,   159,   129,   130,    77,
      78,    79,    80,    26,    27,    28,    29,     4,    24,    15,
       5
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      18,   115,   144,     8,     9,    92,   147,     8,     9,     8,
       9,    99,   122,   177,   145,     6,   101,   102,   103,   104,
     105,   106,   107,    25,    84,    84,   108,    30,    84,    31,
       7,    32,   127,     2,    90,   109,   110,    97,     3,   135,
     182,   150,    33,   174,   175,   111,    19,   196,   156,   183,
     176,    34,   157,    16,    17,   126,   123,    36,   173,    37,
     190,    38,    21,    39,    40,    85,    85,    20,    41,    85,
      42,    91,    43,   162,    98,   199,    44,   200,    45,   167,
       8,     9,   150,   193,   151,   152,    46,    47,     8,   143,
      48,    49,    50,    51,    52,    53,    54,    55,    56,   194,
     195,    36,   160,    37,    57,    38,   161,    39,    40,   160,
      25,   160,    41,   164,    42,   166,    43,   169,    23,   169,
      44,   170,    45,   186,   133,   151,   152,    22,   136,    81,
      46,    47,    82,    18,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    13,    14,   113,   114,    83,    88,    89,
      93,    94,    95,   100,   117,    96,   116,   118,   119,   120,
      84,   128,    18,   131,   134,   132,   137,   138,   142,   141,
     148,   149,   146,   165,   168,   172,   171,   178,   179,   187,
     189,   180,   192,   191,   198,   201,   202,   181,   121,   163,
     188,     0,   158,     0,    35,   185
};

static const yytype_int16 yycheck[] =
{
      12,    59,   116,     4,     5,    39,   120,     4,     5,     4,
       5,    45,     5,   149,   117,    54,    50,    51,    52,    53,
      54,    55,    56,     5,     8,     8,     4,     3,     8,     5,
      30,     7,    90,     0,    17,    13,    14,    17,     5,    97,
       6,     4,    18,   146,    50,    23,    31,   183,    51,    15,
      56,    33,    55,    49,    55,    89,    49,     5,    55,     7,
      55,     9,     3,    11,    12,    49,    49,     4,    16,    49,
      18,    54,    20,   131,    54,   189,    24,   191,    26,   137,
       4,     5,     4,     5,    47,    48,    34,    35,     4,     5,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    21,
      22,     5,    51,     7,    52,     9,    55,    11,    12,    51,
       5,    51,    16,    55,    18,    55,    20,    51,    32,    51,
      24,    55,    26,    55,    94,    47,    48,    50,    98,     3,
      34,    35,     3,   145,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    28,    29,    28,    29,    19,    54,    10,
      10,    54,    19,    54,    54,    25,    49,     4,     3,    49,
       8,     5,   174,    17,    27,    54,    17,     5,     4,    53,
      50,    49,    54,     5,    49,    56,    53,     4,     4,     4,
      56,    50,    50,    56,    50,    50,    50,   156,    85,   132,
     169,    -1,   128,    -1,    29,   160
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    58,     0,     5,   104,   107,    54,    30,     4,     5,
      62,    66,    67,    28,    29,   106,    49,    55,    66,    31,
       4,     3,    50,    32,   105,     5,   100,   101,   102,   103,
       3,     5,     7,    18,    33,   102,     5,     7,     9,    11,
      12,    16,    18,    20,    24,    26,    34,    35,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    52,    69,    70,
      72,    73,    74,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    88,    89,    90,    91,    92,    96,    97,    98,
      99,     3,     3,    19,     8,    49,    75,    76,    54,    10,
      17,    54,    76,    10,    54,    19,    25,    17,    54,    76,
      54,    76,    76,    76,    76,    76,    76,    76,     4,    13,
      14,    23,    68,    28,    29,    91,    49,    54,     4,     3,
      49,    75,     5,    49,    64,    65,    76,    91,     5,    94,
      95,    17,    54,    95,    27,    91,    95,    17,     5,    86,
      87,    53,     4,     5,    62,    67,    54,    62,    50,    49,
       4,    47,    48,    59,    60,    61,    51,    55,    92,    93,
      51,    55,    91,    87,    55,     5,    55,    91,    49,    51,
      55,    53,    56,    55,    67,    50,    56,    61,     4,     4,
      50,    64,     6,    15,    71,    94,    55,     4,    86,    56,
      55,    56,    50,     5,    21,    22,    61,    63,    50,    62,
      62,    50,    50
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    57,    58,    58,    59,    59,    60,    61,    61,    62,
      62,    63,    63,    64,    64,    65,    65,    66,    66,    67,
      67,    68,    68,    68,    69,    69,    70,    70,    70,    71,
      71,    71,    72,    72,    72,    73,    74,    74,    75,    75,
      76,    76,    77,    77,    78,    78,    79,    79,    80,    80,
      81,    81,    82,    82,    83,    83,    84,    84,    85,    85,
      85,    85,    85,    85,    85,    86,    87,    87,    88,    88,
      89,    90,    91,    91,    91,    91,    91,    91,    91,    91,
      91,    91,    91,    91,    91,    91,    91,    92,    92,    93,
      93,    93,    94,    95,    95,    96,    96,    96,    97,    97,
      97,    98,    99,    99,   100,   101,   101,   101,   102,   102,
     103,   103,   104,   105,   106,   106,   107
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     2,     2,     1,     1,     1,
       1,     1,     1,     3,     4,     1,     3,     1,     4,     1,
       2,     1,     1,     1,     3,     4,     1,     2,     2,     2,
       2,     2,     1,     4,     7,     1,     1,     1,     4,     7,
       1,     3,     2,     3,     1,     2,     1,     2,     1,     2,
       1,     2,     1,     2,     1,     2,     1,     2,     1,     1,
       1,     1,     1,     1,     1,     4,     1,     3,     2,     5,
       4,     2,     1,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     1,
       2,     2,     2,     1,     3,     4,     3,     4,     4,     3,
       4,     4,     1,     4,     3,     7,     6,     4,     1,     1,
       1,     2,     4,     0,     1,     1,     9
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
        yyerror (parm, YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



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

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, parm); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, void *parm)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  YYUSE (parm);
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
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep, void *parm)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep, parm);
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
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule, void *parm)
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
                                              , parm);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule, parm); \
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
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, void *parm)
{
  YYUSE (yyvaluep);
  YYUSE (parm);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void *parm)
{
/* The lookahead symbol.  */
int yychar;


/* The semantic value of the lookahead symbol.  */
/* Default value used for initialization, for pacifying older GCCs
   or non-GCC compilers.  */
YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);

    /* Number of syntax errors so far.  */
    int yynerrs;

    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

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

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
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

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
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
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

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
      yychar = yylex (&yylval, parm);
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


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:
#line 188 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { strcpy((yyval.str),(yyvsp[0].str)); }
#line 1486 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 5:
#line 189 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { strcpy((yyval.str),(yyvsp[0].str)); }
#line 1492 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 6:
#line 193 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                  strcpy((yyval.str),"-");
                  strcat((yyval.str),(yyvsp[0].str));
                }
#line 1501 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 7:
#line 199 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { strcpy((yyval.str),(yyvsp[0].str)); }
#line 1507 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 8:
#line 200 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { strcpy((yyval.str),(yyvsp[0].str)); }
#line 1513 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 9:
#line 203 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {strcpy((yyval.str),(yyvsp[0].str));}
#line 1519 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 10:
#line 204 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {strcpy((yyval.str),(yyvsp[0].str));}
#line 1525 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 11:
#line 207 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {strcpy((yyval.str),(yyvsp[0].str));}
#line 1531 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 12:
#line 208 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {strcpy((yyval.str),(yyvsp[0].str));}
#line 1537 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 13:
#line 212 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                          (yyval.node) = NEW_NODE (TYPE_CONSTANT);
                          set_str_value ((yyval.node), (yyvsp[-1].str));
                        }
#line 1546 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 14:
#line 217 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                          (yyval.node) = NEW_NODE (TYPE_CONSTANT);
                          set_name ((yyval.node), (yyvsp[-3].str));
                          set_str_value ((yyval.node), (yyvsp[-1].str));
                        }
#line 1556 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 15:
#line 224 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node)=(yyvsp[0].node); }
#line 1562 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 16:
#line 226 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                    (yyval.node) = (yyvsp[-2].node);
                    append_right ((yyvsp[-2].node), (yyvsp[0].node));
                  }
#line 1571 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 17:
#line 251 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_CONSTANT);
                   set_str_value ((yyval.node), (yyvsp[0].str));
                 }
#line 1580 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 18:
#line 256 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_CONSTANT);
                   set_name ((yyval.node), (yyvsp[-3].str));
                   set_str_value ((yyval.node), (yyvsp[-1].str));
                 }
#line 1590 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 19:
#line 264 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node)=(yyvsp[0].node);}
#line 1596 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 20:
#line 266 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                          (yyval.node)=(yyvsp[-1].node);
                          append_right ((yyval.node), (yyvsp[0].node));
                        }
#line 1605 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 21:
#line 272 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.constant) = CLASS_UNIVERSAL;   }
#line 1611 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 22:
#line 273 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.constant) = CLASS_PRIVATE;     }
#line 1617 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 23:
#line 274 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.constant) = CLASS_APPLICATION; }
#line 1623 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 24:
#line 278 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                  (yyval.node) = NEW_NODE (TYPE_TAG);
                  (yyval.node)->flags.class = CLASS_CONTEXT;
                  set_ulong_value ((yyval.node), (yyvsp[-1].str));
                }
#line 1633 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 25:
#line 284 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                  (yyval.node) = NEW_NODE (TYPE_TAG);
                  (yyval.node)->flags.class = (yyvsp[-2].constant);
                  set_ulong_value ((yyval.node), (yyvsp[-1].str));
                }
#line 1643 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 26:
#line 292 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = (yyvsp[0].node); }
#line 1649 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 27:
#line 294 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
           (yyval.node) = (yyvsp[-1].node);
           (yyval.node)->flags.explicit = 1;
         }
#line 1658 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 28:
#line 299 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
           (yyval.node) = (yyvsp[-1].node);
           (yyval.node)->flags.implicit = 1;
         }
#line 1667 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 29:
#line 306 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 (yyval.node) = NEW_NODE (TYPE_DEFAULT);
                 set_str_value ((yyval.node), (yyvsp[0].str));
               }
#line 1676 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 30:
#line 311 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 (yyval.node) = NEW_NODE (TYPE_DEFAULT);
                 (yyval.node)->flags.is_true = 1;
               }
#line 1685 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 31:
#line 316 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 (yyval.node) = NEW_NODE (TYPE_DEFAULT);
                 (yyval.node)->flags.is_false = 1;
               }
#line 1694 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 32:
#line 323 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 (yyval.node) = NEW_NODE (TYPE_INTEGER);
               }
#line 1702 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 33:
#line 327 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 (yyval.node) = NEW_NODE (TYPE_INTEGER);
                 (yyval.node)->flags.has_list = 1;
                 set_down ((yyval.node), (yyvsp[-1].node));
               }
#line 1712 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 34:
#line 333 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 (yyval.node) = NEW_NODE (TYPE_INTEGER);
                 (yyval.node)->flags.has_min_max = 1;
                 /* the following is wrong.  Better use a union for the value*/
                 set_down ((yyval.node), NEW_NODE (TYPE_SIZE) );
                 set_str_value ((yyval.node)->down, (yyvsp[-1].str));
                 set_name ((yyval.node)->down, (yyvsp[-4].str));
               }
#line 1725 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 35:
#line 344 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                (yyval.node) = NEW_NODE (TYPE_BOOLEAN);
              }
#line 1733 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 36:
#line 350 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
            (yyval.node) = NEW_NODE (TYPE_UTC_TIME);
          }
#line 1741 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 37:
#line 354 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
            (yyval.node) = NEW_NODE (TYPE_GENERALIZED_TIME);
          }
#line 1749 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 38:
#line 360 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node) = NEW_NODE (TYPE_SIZE);
               (yyval.node)->flags.one_param = 1;
               set_str_value ((yyval.node), (yyvsp[-1].str));
             }
#line 1759 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 39:
#line 366 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node) = NEW_NODE (TYPE_SIZE);
               (yyval.node)->flags.has_min_max = 1;
               set_str_value ((yyval.node), (yyvsp[-4].str));
               set_name ((yyval.node), (yyvsp[-1].str));
             }
#line 1770 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 40:
#line 375 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node)=(yyvsp[0].node);
             }
#line 1778 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 41:
#line 379 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node)=(yyvsp[-1].node);
             }
#line 1786 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 42:
#line 385 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_OCTET_STRING);
                     }
#line 1794 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 43:
#line 389 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_OCTET_STRING);
                       (yyval.node)->flags.has_size = 1;
                       set_down ((yyval.node),(yyvsp[0].node));
                     }
#line 1804 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 44:
#line 396 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_UTF8_STRING); }
#line 1810 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 45:
#line 398 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_UTF8_STRING);
                       (yyval.node)->flags.has_size = 1;
                       set_down ((yyval.node),(yyvsp[0].node));
                     }
#line 1820 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 46:
#line 404 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_NUMERIC_STRING); }
#line 1826 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 47:
#line 406 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_NUMERIC_STRING);
                       (yyval.node)->flags.has_size = 1;
                       set_down ((yyval.node),(yyvsp[0].node));
                     }
#line 1836 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 48:
#line 413 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_PRINTABLE_STRING); }
#line 1842 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 49:
#line 415 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                          (yyval.node) = NEW_NODE (TYPE_PRINTABLE_STRING);
                          (yyval.node)->flags.has_size = 1;
                          set_down ((yyval.node),(yyvsp[0].node));
                        }
#line 1852 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 50:
#line 422 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_TELETEX_STRING); }
#line 1858 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 51:
#line 424 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_TELETEX_STRING);
                       (yyval.node)->flags.has_size = 1;
                       set_down ((yyval.node),(yyvsp[0].node));
                     }
#line 1868 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 52:
#line 430 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_IA5_STRING); }
#line 1874 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 53:
#line 432 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_IA5_STRING);
                       (yyval.node)->flags.has_size = 1;
                       set_down ((yyval.node),(yyvsp[0].node));
                     }
#line 1884 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 54:
#line 439 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_UNIVERSAL_STRING); }
#line 1890 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 55:
#line 441 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                           (yyval.node) = NEW_NODE (TYPE_UNIVERSAL_STRING);
                           (yyval.node)->flags.has_size = 1;
                           set_down ((yyval.node),(yyvsp[0].node));
                         }
#line 1900 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 56:
#line 447 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = NEW_NODE (TYPE_BMP_STRING); }
#line 1906 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 57:
#line 449 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                       (yyval.node) = NEW_NODE (TYPE_BMP_STRING);
                       (yyval.node)->flags.has_size = 1;
                       set_down ((yyval.node),(yyvsp[0].node));
                     }
#line 1916 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 65:
#line 470 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_CONSTANT);
                   set_name ((yyval.node), (yyvsp[-3].str));
                   set_str_value ((yyval.node), (yyvsp[-1].str));
                 }
#line 1926 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 66:
#line 478 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                        (yyval.node)=(yyvsp[0].node);
                      }
#line 1934 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 67:
#line 482 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                        (yyval.node)=(yyvsp[-2].node);
                        append_right ((yyval.node), (yyvsp[0].node));
                      }
#line 1943 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 68:
#line 489 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                     (yyval.node) = NEW_NODE (TYPE_BIT_STRING);
                   }
#line 1951 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 69:
#line 493 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                     (yyval.node) = NEW_NODE (TYPE_BIT_STRING);
                     (yyval.node)->flags.has_list = 1;
                     set_down ((yyval.node), (yyvsp[-1].node));
                   }
#line 1961 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 70:
#line 501 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                     (yyval.node) = NEW_NODE (TYPE_ENUMERATED);
                     (yyval.node)->flags.has_list = 1;
                     set_down ((yyval.node), (yyvsp[-1].node));
                   }
#line 1971 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 71:
#line 509 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                     (yyval.node) = NEW_NODE (TYPE_OBJECT_ID);
                   }
#line 1979 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 72:
#line 515 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                      (yyval.node) = NEW_NODE (TYPE_IDENTIFIER);
                      set_str_value ((yyval.node), (yyvsp[0].str));
                    }
#line 1988 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 73:
#line 520 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                      (yyval.node) = NEW_NODE (TYPE_IDENTIFIER);
                      (yyval.node)->flags.has_size = 1;
                      set_str_value ((yyval.node), (yyvsp[-1].str));
                      set_down ((yyval.node), (yyvsp[0].node));
                    }
#line 1999 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 74:
#line 526 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2005 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 75:
#line 527 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2011 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 76:
#line 528 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2017 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 77:
#line 529 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2023 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 79:
#line 531 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2029 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 80:
#line 532 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2035 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 81:
#line 533 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2041 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 82:
#line 534 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2047 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 83:
#line 535 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2053 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 84:
#line 536 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2059 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 85:
#line 537 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {(yyval.node)=(yyvsp[0].node);}
#line 2065 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 86:
#line 539 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                      (yyval.node) = NEW_NODE(TYPE_NULL);
                    }
#line 2073 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 87:
#line 545 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                             (yyval.node) = (yyvsp[0].node);
                           }
#line 2081 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 88:
#line 549 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
/*                               $2->flags.has_tag = 1; */
/*                               $$ = $2; */
/*                               set_right ($1, $$->down ); */
/*                               set_down ($$, $1); */
                             (yyval.node) = (yyvsp[-1].node);
                             set_down ((yyval.node), (yyvsp[0].node));
                           }
#line 2094 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 89:
#line 560 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                                   (yyval.node) = (yyvsp[0].node);
                                 }
#line 2102 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 90:
#line 564 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                                   (yyvsp[-1].node)->flags.has_default = 1;
                                   (yyval.node) = (yyvsp[-1].node);
                                   set_right ((yyvsp[0].node), (yyval.node)->down);
                                   set_down ((yyval.node), (yyvsp[0].node));
                                 }
#line 2113 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 91:
#line 571 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                                   (yyvsp[-1].node)->flags.is_optional = 1;
                                   (yyval.node) = (yyvsp[-1].node);
                                 }
#line 2122 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 92:
#line 578 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 set_name ((yyvsp[0].node), (yyvsp[-1].str));
                 (yyval.node) = (yyvsp[0].node);
               }
#line 2131 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 93:
#line 585 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node)=(yyvsp[0].node); }
#line 2137 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 94:
#line 587 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                      (yyval.node)=(yyvsp[-2].node);
                      append_right ((yyval.node), (yyvsp[0].node));
                    }
#line 2146 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 95:
#line 594 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_SEQUENCE);
                   set_down ((yyval.node), (yyvsp[-1].node));
                 }
#line 2155 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 96:
#line 599 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_SEQUENCE_OF);
                   set_down ((yyval.node), (yyvsp[0].node));
                 }
#line 2164 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 97:
#line 604 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_SEQUENCE_OF);
                   (yyval.node)->flags.has_size = 1;
                   set_right ((yyvsp[-2].node),(yyvsp[0].node));
                   set_down ((yyval.node),(yyvsp[-2].node));
                 }
#line 2175 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 98:
#line 613 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node) = NEW_NODE (TYPE_SET);
               set_down ((yyval.node), (yyvsp[-1].node));
             }
#line 2184 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 99:
#line 618 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node) = NEW_NODE (TYPE_SET_OF);
               set_down ((yyval.node), (yyvsp[0].node));
             }
#line 2193 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 100:
#line 623 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node) = NEW_NODE (TYPE_SET_OF);
               (yyval.node)->flags.has_size = 1;
               set_right ((yyvsp[-2].node), (yyvsp[0].node));
               set_down ((yyval.node), (yyvsp[-2].node));
             }
#line 2204 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 101:
#line 632 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                  (yyval.node) = NEW_NODE (TYPE_CHOICE);
                  set_down ((yyval.node), (yyvsp[-1].node));
                }
#line 2213 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 102:
#line 639 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               (yyval.node) = NEW_NODE (TYPE_ANY);
             }
#line 2221 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 103:
#line 643 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               AsnNode node;

               (yyval.node) = NEW_NODE (TYPE_ANY);
               (yyval.node)->flags.has_defined_by = 1;
               node = NEW_NODE (TYPE_CONSTANT);
               set_name (node, (yyvsp[0].str));
               set_down((yyval.node), node);
             }
#line 2235 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 104:
#line 655 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
               set_name ((yyvsp[0].node), (yyvsp[-2].str));
               (yyval.node) = (yyvsp[0].node);
             }
#line 2244 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 105:
#line 662 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_OBJECT_ID);
                   (yyval.node)->flags.assignment = 1;
                   set_name ((yyval.node), (yyvsp[-6].str));
                   set_down ((yyval.node), (yyvsp[-1].node));
                 }
#line 2255 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 106:
#line 669 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_OBJECT_ID);
                   (yyval.node)->flags.assignment = 1;
                   (yyval.node)->flags.one_param = 1;
                   set_name ((yyval.node), (yyvsp[-5].str));
                   set_str_value ((yyval.node), (yyvsp[-4].str));
                   set_down ((yyval.node), (yyvsp[-1].node));
                 }
#line 2268 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 107:
#line 678 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                   (yyval.node) = NEW_NODE (TYPE_INTEGER);
                   (yyval.node)->flags.assignment = 1;
                   set_name ((yyval.node), (yyvsp[-3].str));
                   set_str_value ((yyval.node), (yyvsp[0].str));
                 }
#line 2279 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 108:
#line 686 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = (yyvsp[0].node); }
#line 2285 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 109:
#line 687 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = (yyvsp[0].node); }
#line 2291 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 110:
#line 691 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node) = (yyvsp[0].node); }
#line 2297 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 111:
#line 693 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                         (yyval.node) = (yyvsp[-1].node);
                         append_right ((yyval.node), (yyvsp[0].node));
                       }
#line 2306 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 112:
#line 700 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                     (yyval.node) = NEW_NODE (TYPE_OBJECT_ID);
                     set_down ((yyval.node), (yyvsp[-1].node));
                     set_name ((yyval.node), (yyvsp[-3].str));
                   }
#line 2316 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 113:
#line 708 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.node)=NULL;}
#line 2322 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 114:
#line 724 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.constant) = CONST_EXPLICIT; }
#line 2328 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 115:
#line 725 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    { (yyval.constant) = CONST_IMPLICIT; }
#line 2334 "asn1-parse.c" /* yacc.c:1652  */
    break;

  case 116:
#line 731 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1652  */
    {
                 AsnNode node;

                 (yyval.node) = node = NEW_NODE (TYPE_DEFINITIONS);

                 if ((yyvsp[-6].constant) == CONST_EXPLICIT)
                   node->flags.explicit = 1;
                 else if ((yyvsp[-6].constant) == CONST_IMPLICIT)
                   node->flags.implicit = 1;

                 if ((yyvsp[-2].node))
                   node->flags.has_imports = 1;

                 set_name ((yyval.node), (yyvsp[-8].node)->name);
                 set_name ((yyvsp[-8].node), "");

                 if (!node->flags.has_imports)
                   set_right ((yyvsp[-8].node),(yyvsp[-1].node));
                 else
                   {
                     set_right ((yyvsp[-2].node),(yyvsp[-1].node));
                     set_right ((yyvsp[-8].node),(yyvsp[-2].node));
                   }

                 set_down ((yyval.node), (yyvsp[-8].node));

                 _ksba_asn_set_default_tag ((yyval.node));
                 _ksba_asn_type_set_config ((yyval.node));
                 PARSECTL->result_parse = _ksba_asn_check_identifier((yyval.node));
                 PARSECTL->parse_tree=(yyval.node);
               }
#line 2370 "asn1-parse.c" /* yacc.c:1652  */
    break;


#line 2374 "asn1-parse.c" /* yacc.c:1652  */
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
      yyerror (parm, YY_("syntax error"));
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
        yyerror (parm, yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



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
                      yytoken, &yylval, parm);
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


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, parm);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


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
  yyerror (parm, YY_("memory exhausted"));
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
                  yytoken, &yylval, parm);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, parm);
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
#line 764 "/home/wk/s/libksba/src/asn1-parse.y" /* yacc.c:1918  */



/*************************************************************/
/*  Function: yylex                                          */
/*  Description: looks for tokens in file_asn1 pointer file. */
/*  Return: int                                              */
/*    Token identifier or ASCII code or 0(zero: End Of File) */
/*************************************************************/
static int
yylex (YYSTYPE *lvalp, void *parm)
{
  int c,counter=0,k;
  char string[MAX_STRING_LENGTH];
  size_t len;
  FILE *fp = PARSECTL->fp;

  if (!PARSECTL->lineno)
    PARSECTL->lineno++; /* start with line one */

  while (1)
    {
      while ( (c=fgetc (fp))==' ' || c=='\t')
        ;
      if (c =='\n')
        {
          PARSECTL->lineno++;
          continue;
        }
      if(c==EOF)
        return 0;

      if ( c=='(' || c==')' || c=='[' || c==']'
           || c=='{' || c=='}' || c==',' || c=='.' || c=='+')
        return c;

      if (c=='-')
        {
          if ( (c=fgetc(fp))!='-')
            {
              ungetc(c,fp);
              return '-';
            }
          else
            {
              /* A comment finishes at the end of line */
              counter=0;
              while ( (c=fgetc(fp))!=EOF && c != '\n' )
                ;
              if (c==EOF)
                return 0;
              else
                continue; /* repeat the search */
            }
        }

      do
        {
          if (counter >= DIM (string)-1 )
            {
              fprintf (stderr,"%s:%d: token too long\n", "myfile:",
                       PARSECTL->lineno);
              return 0; /* EOF */
            }
          string[counter++]=c;
        }
      while ( !((c=fgetc(fp))==EOF
                || c==' '|| c=='\t' || c=='\n'
                || c=='(' || c==')' || c=='[' || c==']'
                || c=='{' || c=='}' || c==',' || c=='.'));

      ungetc (c,fp);
      string[counter]=0;
      /*fprintf (stderr, "yylex token `%s'\n", string);*/

      /* Is STRING a number? */
      for (k=0; k<counter; k++)
        {
          if(!isdigit(string[k]))
            break;
        }
      if (k>=counter)
        {
          strcpy (lvalp->str,string);
          if (PARSECTL->debug)
            fprintf (stderr,"%d: yylex found number `%s'\n",
                     PARSECTL->lineno, string);
          return NUM;
        }

      /* Is STRING a keyword? */
      len = strlen (string);
      for (k = 0; k < YYNTOKENS; k++)
        {
          if (yytname[k] && yytname[k][0] == '\"'
              && !strncmp (yytname[k] + 1, string, len)
              && yytname[k][len + 1] == '\"' && !yytname[k][len + 2])
            return yytoknum[k];
        }

      /* STRING is an IDENTIFIER */
      strcpy(lvalp->str,string);
      if (PARSECTL->debug)
        fprintf (stderr,"%d: yylex found identifier `%s'\n",
                 PARSECTL->lineno, string);
      return IDENTIFIER;
    }
}

static void
yyerror (void *parm, const char *s)
{
  (void)parm;
  /* Sends the error description to stderr */
  fprintf (stderr, "%s\n", s);
  /* Why doesn't bison provide a way to pass the parm to yyerror?
     Update: Newer bison versions allow for this.  We need to see how
     we can make use of it.  */
}



static AsnNode
new_node (struct parser_control_s *parsectl, node_type_t type)
{
  AsnNode node;

  node = xcalloc (1, sizeof *node);
  node->type = type;
  node->off = -1;
  node->link_next = parsectl->all_nodes;
  parsectl->all_nodes = node;

  return node;
}

static void
release_all_nodes (AsnNode node)
{
  AsnNode node2;

  for (; node; node = node2)
    {
      node2 = node->link_next;
      xfree (node->name);

      if (node->valuetype == VALTYPE_CSTR)
        xfree (node->value.v_cstr);
      else if (node->valuetype == VALTYPE_MEM)
        xfree (node->value.v_mem.buf);

      xfree (node);
    }
}

static void
set_name (AsnNode node, const char *name)
{
  _ksba_asn_set_name (node, name);
}

static void
set_str_value (AsnNode node, const char *text)
{
  if (text && *text)
    _ksba_asn_set_value (node, VALTYPE_CSTR, text, 0);
  else
    _ksba_asn_set_value (node, VALTYPE_NULL, NULL, 0);
}

static void
set_ulong_value (AsnNode node, const char *text)
{
  unsigned long val;

  if (text && *text)
    val = strtoul (text, NULL, 10);
  else
    val = 0;
  _ksba_asn_set_value (node, VALTYPE_ULONG, &val, sizeof(val));
}

static void
set_right (AsnNode node, AsnNode right)
{
  return_if_fail (node);

  node->right = right;
  if (right)
    right->left = node;
}

static void
append_right (AsnNode node, AsnNode right)
{
  return_if_fail (node);

  while (node->right)
    node = node->right;

  node->right = right;
  if (right)
    right->left = node;
}


static void
set_down (AsnNode node, AsnNode down)
{
  return_if_fail (node);

  node->down = down;
  if (down)
    down->left = node;
}


/**
 * ksba_asn_parse_file:
 * @file_name: Filename with the ASN module
 * @pointer: Returns the syntax tree
 * @debug: Enable debug output
 *
 * Parse an ASN.1 file and return an syntax tree.
 *
 * Return value: 0 for okay or an ASN_xx error code
 **/
int
ksba_asn_parse_file (const char *file_name, ksba_asn_tree_t *result, int debug)
{
  struct parser_control_s parsectl;

  *result = NULL;

  parsectl.fp = file_name? fopen (file_name, "r") : NULL;
  if ( !parsectl.fp )
    return gpg_error_from_syserror ();

  parsectl.lineno = 0;
  parsectl.debug = debug;
  parsectl.result_parse = gpg_error (GPG_ERR_SYNTAX);
  parsectl.parse_tree = NULL;
  parsectl.all_nodes = NULL;
  /* yydebug = 1; */
  if ( yyparse ((void*)&parsectl) || parsectl.result_parse )
    { /* error */
      fprintf (stderr, "%s:%d: parse error\n",
               file_name?file_name:"-", parsectl.lineno );
      release_all_nodes (parsectl.all_nodes);
      parsectl.all_nodes = NULL;
    }
  else
    { /* okay */
      ksba_asn_tree_t tree;

      _ksba_asn_change_integer_value (parsectl.parse_tree);
      _ksba_asn_expand_object_id (parsectl.parse_tree);
      tree = xmalloc ( sizeof *tree + (file_name? strlen (file_name):1) );
      tree->parse_tree = parsectl.parse_tree;
      tree->node_list = parsectl.all_nodes;
      strcpy (tree->filename, file_name? file_name:"-");
      *result = tree;
    }

  if (file_name)
    fclose (parsectl.fp);
  return parsectl.result_parse;
}

void
ksba_asn_tree_release (ksba_asn_tree_t tree)
{
  if (!tree)
    return;
  release_all_nodes (tree->node_list);
  tree->node_list = NULL;
  xfree (tree);
}


void
_ksba_asn_release_nodes (AsnNode node)
{
  /* FIXME: it does not work yet because the allocation function in
     asn1-func.c does not link all nodes together */
  release_all_nodes (node);
}
