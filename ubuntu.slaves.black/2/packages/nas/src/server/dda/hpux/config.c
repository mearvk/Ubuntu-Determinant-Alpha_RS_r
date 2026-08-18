/* config.c - configuration setting and functions for this server 
 *
 * $Id: config.c 166 2006-07-26 23:56:34Z jon $
 *
 */

#include "nasconf.h"
#include "config.h"
#include "aulog.h"
#include "../../dia/gram.h"

/* for hpux */
#include <sys/audio.h>

extern int OutputDevType;

void
ddaSetConfig(int token, void *value)
{
    int num;
    char *str;

    /* a switch statement based on the lex/yacc token (defined in 
       ../../dia/gram.h) is done here... Ignore any token not handled
       or understood by this server */

    switch (token) {

    case OUTDEVTYPE:
        str = (char *) value;
        if (!strcmp(str, "ext") || !strcmp(str, "EXT")) {
            OutputDevType = AUDIO_OUT_EXTERNAL;
            if (NasConfig.DoDebug)
                osLogMsg("### Intializing to AUDIO_OUT_EXTERNAL\n");
        } else if (!strcmp(str, "int") || !strcmp(str, "INT")) {
            OutputDevType = AUDIO_OUT_INTERNAL;
            if (NasConfig.DoDebug)
                osLogMsg("### Intializing to AUDIO_OUT_INTERNAL\n");
        } else {                /* default - external */

            OutputDevType = AUDIO_OUT_EXTERNAL;
            osLogMsg("ddaSetConfig(): unknown OutDevType '%s'\n", str);
        }

        break;

    default:                   /* ignore any other tokens */
        if (NasConfig.DoDebug > 5)
            osLogMsg("ddaSetConfig(): WARNING: unknown token %d, ignored\n", token);

        break;
    }

    return;                     /* that's it... */
}

int
ddaProcessArg(int *index, int argc, char *argv[])
{
    /* If you have an option that takes an
       arguement, be sure to increment
       index after processing the arg,
       otherwise, leave it alone. 
       DO NOT MODIFY argv! */

    /* nothing here yet... */

    /* always return 1 to indicate failure */
    return (1);
}

void
ddaUseMsg(void)
{
    /* print usage summary for this server,
       called from UseMsg() in utils.c */
    ErrorF("\nNo Server specific options supported.\n");

    return;
}
