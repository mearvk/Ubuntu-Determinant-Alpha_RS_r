/* MEARVK GCC build metadata support.
   Copyright (C) 2026 MEARVK LTD integration work.

   GCC remains governed by its upstream licensing documents.  */

#include "config.h"
#include "system.h"
#include "mearvk-metadata.h"

#include <stdio.h>
#include <string.h>

static int
emit_field (FILE *fp, const char *name, const char *value)
{
  if (!value || !*value)
    return 1;

  /* Metadata values are deliberately conservative: reject control
     characters so a field cannot manufacture additional records.  */
  for (const unsigned char *p = (const unsigned char *) value; *p; ++p)
    if (*p < 0x20 || *p == 0x7f)
      return 0;

  return fprintf (fp, "%s=%s\n", name, value) >= 0;
}

int
me_metadata_emit (void *out,
                  const char *edition,
                  const char *version,
                  const char *company,
                  const char *creation_date,
                  const char *fiduciary,
                  const char *authority,
                  const char *source)
{
  FILE *fp = static_cast<FILE *> (out);

  if (!fp)
    return 0;

  if (fprintf (fp, "MEARVK-META\n") < 0
      || fprintf (fp, "schema=%s\n", MEARVK_METADATA_SCHEMA) < 0
      || !emit_field (fp, "edition", edition)
      || !emit_field (fp, "version", version)
      || !emit_field (fp, "company", company)
      || !emit_field (fp, "creation_date", creation_date)
      || !emit_field (fp, "fiduciary", fiduciary)
      || !emit_field (fp, "authority", authority)
      || !emit_field (fp, "source", source))
    return 0;

  return 1;
}
