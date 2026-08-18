/*
 * nasconf.h
 *
 * $Id: nasconf.h 166 2006-07-26 23:56:34Z jon $
 *
 * Jon Trulson 9/19/99
 */

#ifndef NASCONFIG_H_INCLUDED
#define NASCONFIG_H_INCLUDED

#ifdef NASCONFIG_INSTANTIATE
# define GEXTERN
#else
# define GEXTERN extern
#endif /* NASCONFIG_INSTANTIATE */

                                /* global configurables */
typedef struct {
    int DoDebug;
    int DoVerbose;
    int DoDeviceRelease;
    int DoKeepMixer;
    int DoDaemon;
    int LocalOnly;
    int AllowAny;
} NasConfig_t;

GEXTERN NasConfig_t NasConfig;

                                /* defined in server's config.c file */
void ddaSetConfig(int token, void *value);
                                /* dda specific arg handling */
int ddaProcessArg(int *index, int argc, char *argv[]);
                                /* dda specific usage summary */
void ddaUseMsg(void);

                                /* A special token for ddaSetConfig */
#define CONF_SET_SECTION (-1)

void diaInitGlobalConfig(void); /* init function */

#undef GEXTERN
#endif /* NASCONFIG_H_INCLUDED */
