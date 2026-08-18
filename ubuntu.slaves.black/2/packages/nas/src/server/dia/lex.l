/* $Id: lex.l 173 2006-07-29 17:43:25Z jon $ */
/* $NCDId: @(#)lex.l,v 1.1 1996/04/24 17:01:06 greg Exp $ */

%{
#include "auservertype.h"
#include "gram.h"
#include "nasconf.h"

int Lineno = 1; /* current line number of the scanner */

%}

string                          \"([^"]|\\.)*\"
number                          [0-9]+
%%

[Dd][Ee][Bb][Uu][Gg]                    { return CDEBUG; }
[Vv][Ee][Rr][Bb][Oo][Ss][Ee]            { return VERBOSE; }
[Rr][Ee][Ll][Ee][Aa][Ss][Ee][Dd][Ee][Vv][Ii][Cc][Ee]   { return RELEASEDEVICE;}
[Kk][Ee][Ee][Pp][Mm][Ii][Xx][Ee][Rr]    { return KEEPMIXER; }
[Ii][Nn][Pp][Uu][Tt][Ss][Ee][Cc][Tt][Ii][Oo][Nn] { return INPUTSECTION; }
[Oo][Uu][Tt][Pp][Uu][Tt][Ss][Ee][Cc][Tt][Ii][Oo][Nn] { return OUTPUTSECTION; }
[Ee][Nn][Dd]                            { return ENDSECTION; }
[Gg][Aa][Ii][Nn]                        { return GAIN; }
[Gg][Aa][Ii][Nn][Ss][Cc][Aa][Ll][Ee]    { return GAINSCALE; }
[Ww][Oo][Rr][Dd][Ss][Ii][Zz][Ee]        { return WORDSIZE; }
[Ff][Rr][Aa][Gg][Ss][Ii][Zz][Ee]        { return FRAGSIZE; }
[Mm][Ii][Nn][Ff][Rr][Aa][Gg][Ss]        { return MINFRAGS; }
[Mm][Aa][Xx][Ff][Rr][Aa][Gg][Ss]        { return MAXFRAGS; }
[Nn][Uu][Mm][Cc][Hh][Aa][Nn][Ss]        { return NUMCHANS; }
[Mm][Aa][Xx][Rr][Aa][Tt][Ee]            { return MAXRATE; }
[Mm][Ii][Nn][Rr][Aa][Tt][Ee]            { return MINRATE; }
[Dd][Ee][Vv][Ii][Cc][Ee]                { return DEVICE; }
[Mm][Ii][Xx][Ee][Rr]                    { return MIXER; }
[Rr][Ee][Aa][Dd][Ww][Rr][Ii][Tt][Ee]    { return READWRITE; }
[Mm][Ii][Xx][Ee][Rr][Ii][Nn][Ii][Tt]    { return MIXERINIT; }
[Rr][Ee][Ii][Nn][Ii][Tt][Mm][Ii][Xx][Ee][Rr]    { return REINITMIXER; }
[Oo][Uu][Tt][Dd][Ee][Vv][Tt][Yy][Pp][Ee]  { return OUTDEVTYPE; }
[Ff][Oo][Rr][Cc][Ee][Rr][Aa][Tt][Ee]    { return FORCERATE; }
[Aa][Uu][Tt][Oo][Oo][Pp][Ee][Nn]        { return AUTOOPEN; }


{string}                        { yylval.ptr = (char *)yytext; return STRING; }
{number}                        { (void)sscanf((char *)yytext, "%d", &yylval.num);
                                  return (NUMBER);
                                }
#+.*                            {;}
[\t ]                           {;}
\n                              {Lineno++;}
.                               {
                                  fprintf (stderr, 
                                           "ignoring character \"%s\"\n",
                                           yytext);
                                }
%%
#ifndef yywrap
yywrap()
{
    return (1);
}
#endif

/* parser error reporting routine */
void
yyerror(char *s)
{
    fprintf(stderr, "lex.l: %s at or near '%s' on line %d.\n",
            s, yytext, Lineno);

    return;
}
