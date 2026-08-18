/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_CTF_PARSER_H_INCLUDED
# define YY_YY_CTF_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTEGER_LITERAL = 258,
    STRING_LITERAL = 259,
    CHARACTER_LITERAL = 260,
    LSBRAC = 261,
    RSBRAC = 262,
    LPAREN = 263,
    RPAREN = 264,
    LBRAC = 265,
    RBRAC = 266,
    RARROW = 267,
    STAR = 268,
    PLUS = 269,
    MINUS = 270,
    LT = 271,
    GT = 272,
    TYPEASSIGN = 273,
    COLON = 274,
    SEMICOLON = 275,
    DOTDOTDOT = 276,
    DOT = 277,
    EQUAL = 278,
    COMMA = 279,
    CONST = 280,
    CHAR = 281,
    DOUBLE = 282,
    ENUM = 283,
    ENV = 284,
    EVENT = 285,
    FLOATING_POINT = 286,
    FLOAT = 287,
    INTEGER = 288,
    INT = 289,
    LONG = 290,
    SHORT = 291,
    SIGNED = 292,
    STREAM = 293,
    STRING = 294,
    STRUCT = 295,
    TRACE = 296,
    CALLSITE = 297,
    CLOCK = 298,
    TYPEALIAS = 299,
    TYPEDEF = 300,
    UNSIGNED = 301,
    VARIANT = 302,
    VOID = 303,
    _BOOL = 304,
    _COMPLEX = 305,
    _IMAGINARY = 306,
    TOK_ALIGN = 307,
    IDENTIFIER = 308,
    ID_TYPE = 309,
    ERROR = 310
  };
#endif
/* Tokens.  */
#define INTEGER_LITERAL 258
#define STRING_LITERAL 259
#define CHARACTER_LITERAL 260
#define LSBRAC 261
#define RSBRAC 262
#define LPAREN 263
#define RPAREN 264
#define LBRAC 265
#define RBRAC 266
#define RARROW 267
#define STAR 268
#define PLUS 269
#define MINUS 270
#define LT 271
#define GT 272
#define TYPEASSIGN 273
#define COLON 274
#define SEMICOLON 275
#define DOTDOTDOT 276
#define DOT 277
#define EQUAL 278
#define COMMA 279
#define CONST 280
#define CHAR 281
#define DOUBLE 282
#define ENUM 283
#define ENV 284
#define EVENT 285
#define FLOATING_POINT 286
#define FLOAT 287
#define INTEGER 288
#define INT 289
#define LONG 290
#define SHORT 291
#define SIGNED 292
#define STREAM 293
#define STRING 294
#define STRUCT 295
#define TRACE 296
#define CALLSITE 297
#define CLOCK 298
#define TYPEALIAS 299
#define TYPEDEF 300
#define UNSIGNED 301
#define VARIANT 302
#define VOID 303
#define _BOOL 304
#define _COMPLEX 305
#define _IMAGINARY 306
#define TOK_ALIGN 307
#define IDENTIFIER 308
#define ID_TYPE 309
#define ERROR 310

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 1060 "ctf-parser.y" /* yacc.c:1909  */

	long long ll;
	unsigned long long ull;
	char c;
	char *s;
	struct ctf_node *n;

#line 172 "ctf-parser.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif



int yyparse (struct ctf_scanner *scanner, yyscan_t yyscanner);

#endif /* !YY_YY_CTF_PARSER_H_INCLUDED  */
