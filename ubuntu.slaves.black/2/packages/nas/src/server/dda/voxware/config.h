/*
*
*       config.h - describes abilities (desired or actual) of soundcard fd
*
* $NCDId: @(#)config.h,v 1.1 1996/04/24 17:00:31 greg Exp $
*/

#ifndef CONFIG_H_INCLUDED
#define CONFIG_H_INCLUDED

typedef struct {
    int fd;
    int wordSize;
    int isStereo;
    int curSampleRate;
    int minSampleRate;
    int maxSampleRate;
    int fragSize;
    int minFrags;
    int maxFrags;
    char *device;
    char *mixer;
    int howToOpen;
    int autoOpen;
    int forceRate;
    int isPCSpeaker;
    int gain;                   /* default gain */
    int gainScale;              /* percentage by which gain is always reduced */
} SndStat;


#endif /* CONFIG_H_INCLUDED */
