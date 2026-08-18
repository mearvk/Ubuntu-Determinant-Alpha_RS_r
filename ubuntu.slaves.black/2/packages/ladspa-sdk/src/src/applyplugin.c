/* applyplugin.c

   Free software by Richard W.E. Furse. Do with as you will. No
   warranty. */

/*****************************************************************************/

#include <dlfcn.h>
#include <endian.h>
#include <errno.h>
#include <math.h>
#include <sndfile.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>

/*****************************************************************************/

#include "ladspa.h"

#include "utils.h"

/*****************************************************************************/

#define BUFFER_SIZE 2048

/*****************************************************************************/

SNDFILE * g_poInputFile;
SNDFILE * g_poOutputFile;
LADSPA_Data g_fPeakWritten = 0;

unsigned long g_lInputFileChannelCount;
unsigned long g_lOutputFileChannelCount;

float * g_pfInputFileBuffer;
/* We use sf_writef_int rather than sf_writef_float because we want an
   identify pass-through if nothing is done to the audio. */
int32_t * g_piOutputFileBuffer;

static void 
openInputFile(const char * pcFilename,
              unsigned long * plChannelCount,
              unsigned long * plSampleRate) {
  
  SF_INFO oInfo;
  
  memset(&oInfo, 0, sizeof(SF_INFO));
  g_poInputFile = sf_open(pcFilename, SFM_READ, &oInfo);
  if (g_poInputFile == NULL) {
    fprintf(stderr,
            "Failed to open input file \"%s\".\n",
            pcFilename);
    exit(1);
  }

  *plChannelCount = (unsigned long)(oInfo.channels);
  *plSampleRate   = (unsigned long)(oInfo.samplerate);

  g_lInputFileChannelCount
    = *plChannelCount;
  g_pfInputFileBuffer
    = (float *)calloc(*plChannelCount * BUFFER_SIZE, sizeof(float));
  
}

int
getLibsndfileFormat(const char * pcFilename) {

  const char * pcSuffix, * pcAt;
  int iCount, iIndex;
  SF_FORMAT_INFO oInfo;

  pcSuffix = NULL;
  for (pcAt = pcFilename; *pcAt != '\0'; pcAt++)
    if (*pcAt == '.')
      pcSuffix = pcAt;
  
  if (pcSuffix == NULL) {
    fprintf(stderr,
            "Unable to establish output file type.\n");
    exit(1);
  }
 
  pcSuffix++;
    
  sf_command(NULL, SFC_GET_FORMAT_MAJOR_COUNT, &iCount, sizeof(iCount));
  
  for (iIndex = 0; iIndex < iCount; iIndex++) {
    
    oInfo.format = iIndex;    
    sf_command(NULL, SFC_GET_FORMAT_MAJOR, &oInfo, sizeof(oInfo));

    if (strcasecmp(pcSuffix, oInfo.extension) == 0) {

      /* Always set the minor format to PCM16 for simplicity. This
         could be improved on. */
      return (oInfo.format & SF_FORMAT_TYPEMASK) | SF_FORMAT_PCM_16;
      
    }
    
  }
  
  fprintf(stderr,
          "Unable to open file of type \"%s\".\n",
          pcSuffix);
  exit(1);

}
    
static void 
openOutputFile(const char * pcFilename,
               unsigned long lChannelCount,
               unsigned long lSampleRate) {

  SF_INFO oInfo;
  
  memset(&oInfo, 0, sizeof(SF_INFO));
  oInfo.channels   = (int)lChannelCount;
  oInfo.samplerate = (int)lSampleRate;
  oInfo.format     = getLibsndfileFormat(pcFilename);
  g_poOutputFile = sf_open(pcFilename, SFM_WRITE, &oInfo);
  if (g_poOutputFile == NULL) {
    fprintf(stderr,
            "Failed to open output file \"%s\".\n",
            pcFilename);
    exit(1);
  }

  g_lOutputFileChannelCount
    = lChannelCount;
  g_piOutputFileBuffer 
    = (int32_t *)calloc(lChannelCount * BUFFER_SIZE, sizeof(int32_t));
  
}

static int
readIntoBuffers(LADSPA_Data ** ppfBuffers, 
                const unsigned long lFrameSize) {

  sf_count_t lReadLength, lFrameIndex;
  const float * pfReadPointer;
  long lChannelIndex;

  lReadLength = sf_readf_float(g_poInputFile,
                               g_pfInputFileBuffer,
                               (sf_count_t)lFrameSize);
  if (lReadLength < 0) {
    fprintf(stderr,
            "Failed to read audio from input file.\n");
    exit(1);
  }

  for (lChannelIndex = 0;
       lChannelIndex < g_lInputFileChannelCount; 
       lChannelIndex++) {
    pfReadPointer = g_pfInputFileBuffer + lChannelIndex;
    for (lFrameIndex = 0; 
         lFrameIndex < lReadLength;
         lFrameIndex++,
           pfReadPointer += g_lInputFileChannelCount) 
      ppfBuffers[lChannelIndex][lFrameIndex]
        = (LADSPA_Data)(*pfReadPointer);
  }

  return (int)lReadLength;

}

static void
writeFromBuffers(LADSPA_Data ** ppfBuffers, 
                 const unsigned long lFrameSize) {

  LADSPA_Data fValue, fAbsValue, fScalar, fMinimum, fMaximum;
  int bLow, bHigh;
  int32_t * piWritePointer;
  size_t lWriteLength;
  unsigned long lChannelIndex;
  unsigned long lFrameIndex;

  fScalar  = (float)( 0x80000000ll);
  fMinimum = (float)(-0x80000000ll);
  fMaximum = (float)( 0x7FFFFFFFll);
  
  for (lChannelIndex = 0;
       lChannelIndex < g_lOutputFileChannelCount; 
       lChannelIndex++) {
    
    piWritePointer = g_piOutputFileBuffer + lChannelIndex;
    
    for (lFrameIndex = 0; 
         lFrameIndex < lFrameSize; 
         lFrameIndex++,
           piWritePointer += g_lOutputFileChannelCount) {
      
      fValue = ppfBuffers[lChannelIndex][lFrameIndex];
      
      fAbsValue = fabs(fValue);
      if (fAbsValue > g_fPeakWritten)
        g_fPeakWritten = fAbsValue;

      fValue *= fScalar;
      
      bHigh = (fValue >= fMaximum);
      bLow  = (fValue <= fMinimum);
      if (bHigh | bLow) {
        if (bHigh)
          fValue = fMaximum;
        else
          fValue = fMinimum;
      }

      *piWritePointer = (int32_t)(llrintf(fValue));
      
    }
    
  }

  lWriteLength = sf_writef_int(g_poOutputFile,
                               g_piOutputFileBuffer,
                               lFrameSize);
  if (lWriteLength < lFrameSize) {
    fprintf(stderr,
            "Failed to write audio to output file.\n");
    exit(1);
  }

}

static void
closeFiles(void) {
  sf_close(g_poInputFile);
  sf_close(g_poOutputFile);
  printf("Peak output: %g\n", g_fPeakWritten);
}

/*****************************************************************************/

static unsigned long
getPortCountByType(const LADSPA_Descriptor     * psDescriptor,
                   const LADSPA_PortDescriptor   iType) {

  unsigned long lCount;
  unsigned long lIndex;

  lCount = 0;
  for (lIndex = 0; lIndex < psDescriptor->PortCount; lIndex++)
    if ((psDescriptor->PortDescriptors[lIndex] & iType) == iType)
      lCount++;

  return lCount;
}

/*****************************************************************************/

static void
listControlsForPlugin(const LADSPA_Descriptor * psDescriptor) {

  int bFound;
  unsigned long lIndex;
  LADSPA_PortRangeHintDescriptor iHintDescriptor;
  LADSPA_Data fBound;
        
  fprintf(stderr,
          "Plugin \"%s\" has the following control inputs:\n",
          psDescriptor->Name);

  bFound = 0;
  for (lIndex = 0; lIndex < psDescriptor->PortCount; lIndex++)
    if (LADSPA_IS_PORT_INPUT(psDescriptor->PortDescriptors[lIndex])
        && LADSPA_IS_PORT_CONTROL(psDescriptor->PortDescriptors[lIndex])) {
      fprintf(stderr,
              "\t%s",
              psDescriptor->PortNames[lIndex]);
      bFound = 1;
      iHintDescriptor = psDescriptor->PortRangeHints[lIndex].HintDescriptor;
      if (LADSPA_IS_HINT_BOUNDED_BELOW(iHintDescriptor)
          || LADSPA_IS_HINT_BOUNDED_ABOVE(iHintDescriptor)) {
        fprintf(stderr, " (");
        if (LADSPA_IS_HINT_BOUNDED_BELOW(iHintDescriptor)) {
          fBound = psDescriptor->PortRangeHints[lIndex].LowerBound;
          if (LADSPA_IS_HINT_SAMPLE_RATE(iHintDescriptor)) {
            if (fBound == 0)
              fprintf(stderr, "0");
            else
              fprintf(stderr, "%g * sample rate", fBound);
          }
          else
            fprintf(stderr, "%g", fBound);
        }
        else
          fprintf(stderr, "...");
        fprintf(stderr, " to ");
        if (LADSPA_IS_HINT_BOUNDED_ABOVE(iHintDescriptor)) {
          fBound = psDescriptor->PortRangeHints[lIndex].UpperBound;
          if (LADSPA_IS_HINT_SAMPLE_RATE(iHintDescriptor)) {
            if (fBound == 0)
              fprintf(stderr, "0");
            else
              fprintf(stderr, "%g * sample rate", fBound);
          }
          else
            fprintf(stderr, "%g", fBound);
        }
        else
          fprintf(stderr, "...");
        fprintf(stderr, ")\n");
      }
      else
        fprintf(stderr, "\n");
    }
      
  if (!bFound)
    fprintf(stderr, "\tnone\n");
}

/*****************************************************************************/

/* Note that this procedure leaks memory like mad. */
static void
applyPlugin(const char               * pcInputFilename,
            const char               * pcOutputFilename,
            const LADSPA_Data          fExtraSeconds,
            const unsigned long        lPluginCount,
            const LADSPA_Descriptor ** ppsPluginDescriptors,
            LADSPA_Data             ** ppfPluginControlValues) {

  LADSPA_PortDescriptor iPortDescriptor;
  LADSPA_Handle * ppsPlugins;
  LADSPA_Data ** ppfBuffers;
  long lFrameSize;
  unsigned long lAudioInputCount;
  unsigned long lAudioOutputCount;
  unsigned long lPreviousAudioOutputCount;
  unsigned long lBufferCount;
  unsigned long lBufferIndex;
  unsigned long lControlIndex;
  unsigned long lInputFileChannelCount;
  unsigned long lOutputFileChannelCount;
  unsigned long lPluginIndex;
  unsigned long lPortIndex;
  unsigned long lSampleRate;
  long          lTail;
  LADSPA_Data fDummyControlOutput;

  /* Open input file and output file: 
     -------------------------------- */

  lOutputFileChannelCount
    = getPortCountByType(ppsPluginDescriptors[lPluginCount - 1],
                         LADSPA_PORT_AUDIO | LADSPA_PORT_OUTPUT);
  if (lOutputFileChannelCount == 0) {
    fprintf(stderr,
            "The last plugin in the chain has no audio outputs.\n");
    exit(1);
  }

  openInputFile(pcInputFilename, 
                &lInputFileChannelCount, 
                &lSampleRate);
  if (lInputFileChannelCount
      != getPortCountByType(ppsPluginDescriptors[0],
                            LADSPA_PORT_AUDIO | LADSPA_PORT_INPUT)) {
    fprintf(stderr,
            "Mismatch between channel count in input file and audio inputs "
            "on first plugin in chain.\n");
    exit(1);
  }

  openOutputFile(pcOutputFilename,
                 lOutputFileChannelCount,
                 lSampleRate);

  /* Count buffers and sanity-check the flow graph:
     ---------------------------------------------- */

  lBufferCount = 0;
  lPreviousAudioOutputCount = 0;
  for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++) {

    lAudioInputCount
      = getPortCountByType(ppsPluginDescriptors[lPluginIndex],
                           LADSPA_PORT_AUDIO | LADSPA_PORT_INPUT);
    lAudioOutputCount
      = getPortCountByType(ppsPluginDescriptors[lPluginIndex],
                           LADSPA_PORT_AUDIO | LADSPA_PORT_OUTPUT);

    if (lBufferCount < lAudioInputCount)
      lBufferCount = lAudioInputCount;

    if (lPluginIndex > 0) 
      if (lAudioInputCount != lPreviousAudioOutputCount) {
        fprintf(stderr,
                "There is a mismatch between the number of output channels "
                "on plugin \"%s\" (%ld) and the number of input channels on "
                "plugin \"%s\" (%ld).\n",
                ppsPluginDescriptors[lPluginIndex - 1]->Name,
                lPreviousAudioOutputCount,
                ppsPluginDescriptors[lPluginIndex]->Name,
                lAudioInputCount);
        exit(1);
      }

    lPreviousAudioOutputCount = lAudioOutputCount;

    if (lBufferCount < lAudioOutputCount)
      lBufferCount = lAudioOutputCount;
  }

  /* Create the buffers, create instances, wire them up:
     --------------------------------------------------- */

  ppsPlugins = (LADSPA_Handle *)calloc(lPluginCount, sizeof(LADSPA_Handle));
  ppfBuffers = (LADSPA_Data **)calloc(lBufferCount, sizeof(LADSPA_Data *));
  for (lBufferIndex = 0; lBufferIndex < lBufferCount; lBufferIndex++)
    ppfBuffers[lBufferIndex] 
      = (LADSPA_Data *)calloc(BUFFER_SIZE, sizeof(LADSPA_Data));

  for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++) {

    ppsPlugins[lPluginIndex]
      = ppsPluginDescriptors[lPluginIndex]
      ->instantiate(ppsPluginDescriptors[lPluginIndex],
                    lSampleRate);
    if (!ppsPlugins[lPluginIndex]) {
      fprintf(stderr,
              "Failed to instantiate plugin of type \"%s\".\n",
              ppsPluginDescriptors[lPluginIndex]->Name);
      exit(1);
    }

    /* Controls:
       --------- */

    lControlIndex = 0;
    for (lPortIndex = 0;
         lPortIndex < ppsPluginDescriptors[lPluginIndex]->PortCount; 
         lPortIndex++) {

      iPortDescriptor 
        = ppsPluginDescriptors[lPluginIndex]->PortDescriptors[lPortIndex];
      
      if (LADSPA_IS_PORT_CONTROL(iPortDescriptor)) {
        if (LADSPA_IS_PORT_INPUT(iPortDescriptor))
          ppsPluginDescriptors[lPluginIndex]->connect_port
            (ppsPlugins[lPluginIndex],
             lPortIndex,
             ppfPluginControlValues[lPluginIndex] + (lControlIndex++));
        if (LADSPA_IS_PORT_OUTPUT(iPortDescriptor))
          ppsPluginDescriptors[lPluginIndex]->connect_port
            (ppsPlugins[lPluginIndex],
             lPortIndex,
             &fDummyControlOutput);
      }
    }

    /* Input Buffers:
       -------------- */

    lBufferIndex = 0;
    for (lPortIndex = 0;
         lPortIndex < ppsPluginDescriptors[lPluginIndex]->PortCount; 
         lPortIndex++) {
      iPortDescriptor 
        = ppsPluginDescriptors[lPluginIndex]->PortDescriptors[lPortIndex];
      if (LADSPA_IS_PORT_INPUT(iPortDescriptor) 
          && LADSPA_IS_PORT_AUDIO(iPortDescriptor))
        ppsPluginDescriptors[lPluginIndex]->connect_port
          (ppsPlugins[lPluginIndex],
           lPortIndex,
           ppfBuffers[lBufferIndex++]);
    }
    

    /* Output Buffers:
       --------------- */

    lBufferIndex = 0;
    for (lPortIndex = 0;
         lPortIndex < ppsPluginDescriptors[lPluginIndex]->PortCount; 
         lPortIndex++) {
      iPortDescriptor 
        = ppsPluginDescriptors[lPluginIndex]->PortDescriptors[lPortIndex];
      if (LADSPA_IS_PORT_OUTPUT(iPortDescriptor) 
          && LADSPA_IS_PORT_AUDIO(iPortDescriptor))
        ppsPluginDescriptors[lPluginIndex]->connect_port
          (ppsPlugins[lPluginIndex],
           lPortIndex,
           ppfBuffers[lBufferIndex++]);
    }
  }

  /* Activate:
     --------- */

  for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++) 
    if (ppsPluginDescriptors[lPluginIndex]->activate != NULL)
      ppsPluginDescriptors[lPluginIndex]->activate(ppsPlugins[lPluginIndex]);

  /* Run:
     ---- */

  lTail = -1;
  while (lTail != 0) {

    if (lTail < 0) {
      lFrameSize = readIntoBuffers(ppfBuffers, BUFFER_SIZE);
      if (lFrameSize < BUFFER_SIZE) 
        lTail = (unsigned long)(fExtraSeconds * lSampleRate);
    }
    else {
      for (lBufferIndex = 0; lBufferIndex < lBufferCount; lBufferIndex++)
        memset(ppfBuffers[lBufferIndex], 0, sizeof(LADSPA_Data) * BUFFER_SIZE);
      lFrameSize = BUFFER_SIZE;
      if (lTail < lFrameSize)
        lFrameSize = lTail;
      lTail -= lFrameSize;
    }

    /* Run the plugins: */
    for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++) 
      ppsPluginDescriptors[lPluginIndex]
        ->run(ppsPlugins[lPluginIndex],
              lFrameSize);
    
    /* Write the output to disk. */
    writeFromBuffers(ppfBuffers, lFrameSize);

  }

  /* Deactivate:
     ----------- */

  for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++) 
    if (ppsPluginDescriptors[lPluginIndex]->deactivate != NULL)
      ppsPluginDescriptors[lPluginIndex]->deactivate(ppsPlugins[lPluginIndex]);

  /* Cleanup:
     -------- */

  for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++) 
    ppsPluginDescriptors[lPluginIndex]->cleanup(ppsPlugins[lPluginIndex]);

  /* Close the input and output files:
     --------------------------------- */

  closeFiles();

}

/*****************************************************************************/

/* Note that this function leaks memory and that dynamic libraries
   that are dlopen()ed are never dlclose()d. */
int 
main(const int iArgc, char * const ppcArgv[]) {

  char * pcEndPointer;
  const char * pcControlValue;
  const char * pcInputFilename;
  const char * pcOutputFilename;
  const LADSPA_Descriptor ** ppsPluginDescriptors;
  LADSPA_Data ** ppfPluginControlValues;
  LADSPA_Data fExtraSeconds;
  int bBadParameters;
  int bBadControls;
  LADSPA_Properties iProperties;
  unsigned long lArgumentIndex;
  unsigned long lControlValueCount;
  unsigned long lControlValueIndex;
  unsigned long lPluginCount;
  unsigned long lPluginCountUpperLimit;
  unsigned long lPluginIndex;
  void ** ppvPluginLibraries;

  bBadParameters = 0;
  fExtraSeconds = 0;

  /* Check for a -s flag, but only at the start. Cannot get use
     getopt() as it gets thoroughly confused when faced with negative
     numbers on the command line. */
  lArgumentIndex = 1;
  if (iArgc >= 3) {
    if (strcmp(ppcArgv[1], "-s") == 0) {
      fExtraSeconds = (LADSPA_Data)strtod(ppcArgv[2], &pcEndPointer);
      bBadControls = (ppcArgv[2] + strlen(ppcArgv[2]) 
                      != pcEndPointer);
      lArgumentIndex = 3;
    }
    else if (strncmp(ppcArgv[1], "-s", 2) == 0) {
      fExtraSeconds = (LADSPA_Data)strtod(ppcArgv[1] + 2, &pcEndPointer);
      bBadControls = (ppcArgv[1] + strlen(ppcArgv[1]) 
                      != pcEndPointer);
      lArgumentIndex = 2;
    }
  }
  
  /* We need to analyse the rest of the parameters. The first two
     should be input and output files involved. */
  if (lArgumentIndex + 4 > (unsigned long)iArgc) {
    /* There aren't enough parameters to include an input file, an
       output file and one plugin. */
    bBadParameters = 1;
  }
  else {

    pcInputFilename  = ppcArgv[lArgumentIndex];
    pcOutputFilename = ppcArgv[lArgumentIndex + 1];

    /* Now we need to look through any plugins and plugin parameters
       present. At this stage we're loading plugins and parameters,
       but not attempting to wire them up.

       First we construct some arrays to contain the data we're
       hopefully about to extract. Note that these arrays are usually
       larger than is needed, however they will be large enough.

       WARNING: Note that there is no attempt to tidy up the memory at
       the end of this function and libraries are not unloaded under
       error conditions. This is only a toy program. */

    lPluginCountUpperLimit = (iArgc - lArgumentIndex - 1) / 2;

    ppvPluginLibraries = ((void **)
                          calloc(lPluginCountUpperLimit,
                                 sizeof(void *)));
    ppsPluginDescriptors = ((const LADSPA_Descriptor **)
                            calloc(lPluginCountUpperLimit,
                                   sizeof(LADSPA_Descriptor *)));
    ppfPluginControlValues = ((LADSPA_Data **)
                              calloc(lPluginCountUpperLimit,
                                     sizeof(LADSPA_Data *)));
    lPluginIndex = 0;
    lArgumentIndex += 2;
    bBadControls = 0;
    while (lArgumentIndex < (unsigned long)iArgc && !bBadControls) {

      if (lArgumentIndex + 1 == (unsigned long)iArgc) {
        bBadParameters = 1;
        break;
      }

      /* Parameter should be a plugin file name followed by a
         label. Load the plugin. This call will exit() if the load
         fails. */
      ppvPluginLibraries[lPluginIndex]
        = loadLADSPAPluginLibrary(ppcArgv[lArgumentIndex]);
      ppsPluginDescriptors[lPluginIndex] 
        = findLADSPAPluginDescriptor(ppvPluginLibraries[lPluginIndex],
                                     ppcArgv[lArgumentIndex],
                                     ppcArgv[lArgumentIndex + 1]);

      /* Check the plugin is in-place compatible. */
      iProperties = ppsPluginDescriptors[lPluginIndex]->Properties;
      if (LADSPA_IS_INPLACE_BROKEN(iProperties)) {
        fprintf(stderr,
                "Plugin \"%s\" is not capable of in-place processing and "
                "therefore cannot be used by this program.\n",
                ppsPluginDescriptors[lPluginIndex]->Name);
        /* This is somewhat lazy - this isn't a difficult problem to
           get around. */
        return(1);
      }

      lControlValueCount
        = getPortCountByType(ppsPluginDescriptors[lPluginIndex],
                             LADSPA_PORT_INPUT | LADSPA_PORT_CONTROL);

      bBadControls = (lControlValueCount + lArgumentIndex + 2 
                      > (unsigned long)iArgc);
      if (lControlValueCount > 0 && !bBadControls) {
        ppfPluginControlValues[lPluginIndex]
          = (LADSPA_Data *)calloc(lControlValueCount, sizeof(LADSPA_Data));
        for (lControlValueIndex = 0; 
             lControlValueIndex < lControlValueCount && !bBadControls;
             lControlValueIndex++) {
          pcControlValue = ppcArgv[lArgumentIndex + 2 + lControlValueIndex];
          ppfPluginControlValues[lPluginIndex][lControlValueIndex]
            = (LADSPA_Data)strtod(pcControlValue, &pcEndPointer);
          bBadControls = (pcControlValue + strlen(pcControlValue)
                          != pcEndPointer);
        }
      }

      if (bBadControls)
        listControlsForPlugin(ppsPluginDescriptors[lPluginIndex]);

      lArgumentIndex += (2 + lControlValueCount);
      lPluginIndex++;
    }

    lPluginCount = lPluginIndex;

    if (!bBadControls) {

      /* We have all the data we need. Go go go. If this function
         fails it will exit(). */
      applyPlugin(pcInputFilename,
                  pcOutputFilename,
                  fExtraSeconds,
                  lPluginCount,
                  ppsPluginDescriptors,
                  ppfPluginControlValues);

      for (lPluginIndex = 0; lPluginIndex < lPluginCount; lPluginIndex++)
        unloadLADSPAPluginLibrary(ppvPluginLibraries[lPluginIndex]);
    }
  }

  if (bBadParameters) {
    fprintf(stderr,
            "Usage:\tapplyplugin [flags] <input audio file> "
            "<output audio file>\n"
            "\t<LADSPA plugin file name> <plugin label> "
            "<Control1> <Control2>...\n"
            "\t[<LADSPA plugin file name> <plugin label> "
            "<Control1> <Control2>...]...\n"
            "Flags:"
            "\t-s<seconds>  Add seconds of silence after end of input file.\n"
            "\n"
            "To find out what control values are needed by a plugin, "
            "use the\n"
            "\"analyseplugin\" program and check for control input ports.\n"
            "Note that the LADSPA_PATH environment variable is used "
            "to help find plugins.\n");
    return(1);
  }

  return(0);
}

/*****************************************************************************/

/* EOF */
