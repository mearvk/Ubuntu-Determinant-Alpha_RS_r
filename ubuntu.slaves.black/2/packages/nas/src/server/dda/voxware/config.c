/* config.c - configuration setting and functions for this server 
 *
 * $Id: config.c 173 2006-07-29 17:43:25Z jon $
 *
 */

#include <fcntl.h>
#include "nasconf.h"
#include "config.h"
#include "aulog.h"
#include "../../dia/gram.h"


extern SndStat sndStatOut, sndStatIn, *confStat;
extern int VOXMixerInit;
extern int VOXReInitMixer;

void
ddaSetConfig(int token, void *value)
{
    int num;
    char *str;

    /* a switch statement based on the lex/yacc token (defined in 
       ../../dia/gram.h) is done here... Ignore any token not handled
       or understood by this server */

    switch (token) {
    case CONF_SET_SECTION:
        num = (int) value;

        if (num == INPUTSECTION) {      /* we're in the input section */
            confStat = &sndStatIn;
        } else {                /* we're in the output section */
            confStat = &sndStatOut;
        }
        break;

    case FORCERATE:
        num = (int) value;
        confStat->forceRate = num;
        break;

    case GAINSCALE:
        num = (int) value;
        if (num < 0 || num > 100)
            osLogMsg("config: gain scaling must be within the range 0-100\n");
        else
            confStat->gainScale = num;
        break;

    case GAIN:
        num = (int) value;
        /* the default is 50, so if it's just out of range, don't
           reset it */
        if (num < 0 || num > 100)
            osLogMsg("config: Gain must be within the range 0-100, setting to 50\n");
        else
            confStat->gain = num;

        break;

    case AUTOOPEN:
        num = (int) value;
        confStat->autoOpen = num;
        break;

    case READWRITE:
        num = (int) value;
        if (confStat == &sndStatIn) {
            confStat->howToOpen = (num ? O_RDWR : O_RDONLY);
        } else {
            confStat->howToOpen = (num ? O_RDWR : O_WRONLY);
        }
        break;

    case MIXER:
        str = (char *) value;

        confStat->mixer = str;
        break;

    case DEVICE:
        str = (char *) value;

        confStat->device = str;
        if (!strcmp(str, "/dev/pcaudio") || !strcmp(str, "/dev/pcdsp"))
            confStat->isPCSpeaker = 1;
        break;

    case WORDSIZE:
        num = (int) value;

        if (num != 8 && num != 16) {
            osLogMsg("config: Wordsize (%d) not 8 or 16, setting to 8\n",
                     num);
            confStat->wordSize = 8;
        } else
            confStat->wordSize = num;
        break;

    case FRAGSIZE:
        num = (int) value;

        {
            int i, j, k;

            /* Determine if it is a power of two */
            k = 0;
            j = num;
            for (i = 0; i < 32; i++) {
                if (j & 0x1)
                    k++;
                j >>= 1;
            }
            if (k != 1) {
                osLogMsg("config: Fragment size should be a power of two - setting to 256\n");
                confStat->fragSize = 256;
            } else
                confStat->fragSize = num;
            if (NasConfig.DoDebug)
                osLogMsg("config: Fragsize set to %d\n",
                         confStat->fragSize);
        }
        break;

    case MINFRAGS:
        num = (int) value;

        if (num < 2 || num > 32) {
            osLogMsg("config: Minfrags out of range - setting to 2\n");
            confStat->minFrags = 2;
        } else
            confStat->minFrags = num;

        if (NasConfig.DoDebug)
            osLogMsg("config: Minfrags set to %d\n", confStat->minFrags);
        break;

    case MAXFRAGS:
        num = (int) value;

        if (num < 2 || num > 32) {
            osLogMsg("config: Maxfrags out of range - setting to 32\n");
            confStat->maxFrags = 32;
        } else
            confStat->maxFrags = num;

        if (NasConfig.DoDebug)
            osLogMsg("config: Maxfrags set to %d\n", confStat->maxFrags);
        break;

    case NUMCHANS:
        num = (int) value;

        if (num != 1 && num != 2) {
            osLogMsg("config: Number of channels wrong, setting to 1\n");
            confStat->isStereo = 0;
        } else
            confStat->isStereo = num - 1;
        break;

    case MAXRATE:
        num = (int) value;

        confStat->maxSampleRate = num;
        break;

    case MINRATE:
        num = (int) value;

        confStat->minSampleRate = num;
        break;

    case MIXERINIT:
        num = (int) value;

        VOXMixerInit = num;
        break;

    case REINITMIXER:
        num = (int) value;

        VOXReInitMixer = num;
        break;

    default:                   /* ignore any other tokens */
        if (NasConfig.DoDebug > 5)
            osLogMsg("config: ddaSetConfig() : unknown token %d, ignored\n", token);

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
