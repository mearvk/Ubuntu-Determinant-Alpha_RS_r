/* $Id: gram.y 246 2007-05-12 01:03:53Z jon $ */
/* $NCDId: @(#)gram.y,v 1.1 1996/04/24 17:01:03 greg Exp $ */


%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "auservertype.h"
#include "nasconf.h"
#include "aulog.h"
#include "misc.h"

static char     *ptr;
static int parsebool(char *str);
extern int yylineno;

%}

%union
{
    int num;
    char *ptr;
};

%token <num> INPUTSECTION OUTPUTSECTION ENDSECTION WORDSIZE FRAGSIZE MAXFRAGS
%token <num> MINFRAGS MAXRATE MINRATE NUMCHANS MIXER DEVICE NUMBER 
%token <num> CDEBUG VERBOSE
%token <num> READWRITE FORCERATE AUTOOPEN GAIN GAINSCALE
%token <num> RELEASEDEVICE KEEPMIXER OUTDEVTYPE MIXERINIT REINITMIXER
%token <ptr> STRING 

%type <ptr> string
%type <num> number 

%start auconfig 

%%
auconfig        : globstmts sectconfigs
                ;

globstmts       : /* Empty */
                | globstmts globstmt
                ;

globstmt        : VERBOSE
                        { NasConfig.DoVerbose = TRUE; }
                | CDEBUG number
                        { NasConfig.DoDebug = $2 ; }
                | RELEASEDEVICE string
                        {
                          int j;

                          j = parsebool($2);
                          if (j == -1) {
                                /* error - default to yes */
                              NasConfig.DoDeviceRelease = TRUE;
                          } else 
                              NasConfig.DoDeviceRelease = j; 
                        }
                | KEEPMIXER string
                        {
                          int j;

                          j = parsebool($2);
                          if (j == -1) {
                                /* error - default to yes */
                              NasConfig.DoKeepMixer = TRUE;
                          } else 
                              NasConfig.DoKeepMixer = j; 
                        }
                | MIXERINIT string
                        { ddaSetConfig(MIXERINIT, (void *)parsebool($2)); }  
                | REINITMIXER string
                        { ddaSetConfig(REINITMIXER, (void *)parsebool($2)); }  
                | OUTDEVTYPE string
                        { ddaSetConfig(OUTDEVTYPE, (void *)$2); }  
                ;

sectconfigs     : /* Empty */
                | sectconfigs sectconfig
                ;

sectconfig      : inputconfig
                | outputconfig
                ;

inputconfig     : inputword stmts ENDSECTION
                ;

inputword       : INPUTSECTION
                        { ddaSetConfig(CONF_SET_SECTION, (void *)INPUTSECTION); }
                ;

outputconfig    : outputword stmts ENDSECTION
                ;

outputword      : OUTPUTSECTION
                        { ddaSetConfig(CONF_SET_SECTION, (void *)OUTPUTSECTION); }
                ;

stmts           : /* Empty */
                | stmts stmt
                ;

stmt            : error
                | AUTOOPEN string
                        {
                          ddaSetConfig(AUTOOPEN, (void *)parsebool($2));
                        }
                | FORCERATE string
                        {
                          ddaSetConfig(FORCERATE, (void *)parsebool($2));
                        }
                | READWRITE string
                        {
                          ddaSetConfig(READWRITE, (void *)parsebool($2));
                        }
                | MIXER string
                        {
                          ddaSetConfig(MIXER, (void *)$2);
                        }
                | DEVICE string
                        {
                          ddaSetConfig(DEVICE, (void *)$2);
                        }
                | WORDSIZE number
                        {
                          ddaSetConfig(WORDSIZE, (void *)$2);
                        }
                | FRAGSIZE number
                        { 
                          ddaSetConfig(FRAGSIZE, (void *)$2);
                        }
                | MINFRAGS number
                        {
                          ddaSetConfig(MINFRAGS, (void *)$2);
                        }
                | MAXFRAGS number
                        {
                          ddaSetConfig(MAXFRAGS, (void *)$2);
                        }
                | NUMCHANS number
                        {
                          ddaSetConfig(NUMCHANS, (void *)$2);
                        }
                | MAXRATE number
                        { ddaSetConfig(MAXRATE, (void *)$2); }
                | MINRATE number
                        { ddaSetConfig(MINRATE, (void *)$2); }
                | GAIN number
                        { ddaSetConfig(GAIN, (void *)$2); }
                | GAINSCALE number
                        { ddaSetConfig(GAINSCALE, (void *)$2); }
                ;

string          : STRING                { ptr = (char *)malloc(strlen($1)+1);
                                          strcpy(ptr, $1);
                                          RemoveDQuote(ptr);
                                          $$ = ptr;
                                        }
                ;
number          : NUMBER                { $$ = $1; }
                ;

%%

RemoveDQuote(str)
char *str;
{
    char *i, *o;
    int n;
    int count;

    for (i = str + 1, o = str; *i && *i != '\"'; o++) {
        if (*i == '\\') {
            switch (*++i) {
            case 'n':
                *o = '\n';
                i++;
                break;
            case 'b':
                *o = '\b';
                i++;
                break;
            case 'r':
                *o = '\r';
                i++;
                break;
            case 't':
                *o = '\t';
                i++;
                break;
            case 'f':
                *o = '\f';
                i++;
                break;
            case '0':
                if (*++i == 'x')
                    goto hex;
                else
                    --i;
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
                n = 0;
                count = 0;
                while (*i >= '0' && *i <= '7' && count < 3) {
                    n = (n << 3) + (*i++ - '0');
                    count++;
                }
                *o = n;
                break;
              hex:
            case 'x':
                n = 0;
                count = 0;
                while (i++, count++ < 2) {
                    if (*i >= '0' && *i <= '9')
                        n = (n << 4) + (*i - '0');
                    else if (*i >= 'a' && *i <= 'f')
                        n = (n << 4) + (*i - 'a') + 10;
                    else if (*i >= 'A' && *i <= 'F')
                        n = (n << 4) + (*i - 'A') + 10;
                    else
                        break;
                }
                *o = n;
                break;
            case '\n':
                i++;            /* punt */
                o--;            /* to account for o++ at end of loop */
                break;
            case '\"':
            case '\'':
            case '\\':
            default:
                *o = *i++;
                break;
            }
        } else
            *o = *i++;
    }
    *o = '\0';
}

static int
parsebool(char *str)
{
    char *s;

    s = str;

    if (s == NULL)
        return (-1);

    while (*s) {
        *s = (char) tolower(*s);
        s++;
    }

    if (((char *) strstr("false", str) != NULL) ||
        ((char *) strstr("no", str) != NULL) ||
        ((char *) strstr("0", str) != NULL) ||
        ((char *) strstr("off", str) != NULL)) {
        return (FALSE);
    } else if (((char *) strstr("true", str) != NULL) ||
               ((char *) strstr("yes", str) != NULL) ||
               ((char *) strstr("1", str) != NULL) ||
               ((char *) strstr("on", str) != NULL)) {
        return (TRUE);
    } else {
        fprintf(stderr, "parsebool(): error parsing '%s', \n\t%s\n",
                str,
                "Value must be yes or no, true or false, or on or off.");
        return (-1);
    }
}
