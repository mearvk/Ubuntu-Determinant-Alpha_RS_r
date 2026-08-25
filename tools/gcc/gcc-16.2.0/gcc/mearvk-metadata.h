/* MEARVK GCC build metadata support.
   Copyright (C) 2026 MEARVK LTD integration work.

   This file is an integration component for GCC.  It does not replace or
   modify GCC's upstream copyright or license notices.

   GCC remains governed by its upstream licensing documents.  */

#ifndef GCC_MEARVK_METADATA_H
#define GCC_MEARVK_METADATA_H

#ifdef __cplusplus
extern "C" {
#endif

#define MEARVK_METADATA_SCHEMA "1"
#define MEARVK_METADATA_SECTION ".note.mearvk.metadata"

/* Emit a stable, newline-delimited metadata record to OUT.
   Empty values are omitted.  Returns nonzero on success.  */
int me_metadata_emit (void *out,
                      const char *edition,
                      const char *version,
                      const char *company,
                      const char *creation_date,
                      const char *fiduciary,
                      const char *authority,
                      const char *source);

#ifdef __cplusplus
}
#endif

#endif /* GCC_MEARVK_METADATA_H */
