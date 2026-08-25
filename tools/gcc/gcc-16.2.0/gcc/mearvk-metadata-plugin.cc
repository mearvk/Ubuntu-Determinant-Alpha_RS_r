/* MEARVK GCC metadata plugin reference implementation.
   Copyright (C) 2026 MEARVK LTD integration work.

   This plugin is intentionally additive: GCC's own provenance, notices,
   and licensing remain authoritative.  The plugin supplies a stable
   metadata record for C and C++ compilation units.

   Build/load through GCC's documented plugin mechanism when testing the
   integration before folding the implementation into a configured GCC
   build.  */

#include "gcc-plugin.h"
#include "plugin-version.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>

int plugin_is_GPL_compatible;

static const char *edition;
static const char *version_value;
static const char *company;
static const char *fiduciary;
static const char *authority;
static const char *source;

static const char *
env_or_default (const char *name, const char *fallback)
{
  const char *value = std::getenv (name);
  return value && *value ? value : fallback;
}

static void
emit_metadata (void *, void *)
{
  const char *output = std::getenv ("MEARVK_METADATA_OUTPUT");
  if (!output || !*output)
    return;

  FILE *fp = std::fopen (output, "w");
  if (!fp)
    return;

  std::time_t now = std::time (nullptr);
  char date[64] = {};
  std::tm tm_value = {};
#if defined(_WIN32)
  gmtime_s (&tm_value, &now);
#else
  gmtime_r (&now, &tm_value);
#endif
  std::strftime (date, sizeof date, "%Y-%m-%dT%H:%M:%SZ", &tm_value);

  std::fprintf (fp, "MEARVK-META\n");
  std::fprintf (fp, "schema=1\n");
  std::fprintf (fp, "compiler=gcc\n");
  std::fprintf (fp, "compiler_version=%s\n", env_or_default ("MEARVK_GCC_VERSION", "16.2.0"));
  std::fprintf (fp, "language=c-or-c++\n");
  std::fprintf (fp, "edition=%s\n", edition ? edition : "");
  std::fprintf (fp, "version=%s\n", version_value ? version_value : "");
  std::fprintf (fp, "company=%s\n", company ? company : "");
  std::fprintf (fp, "creation_date=%s\n", date);
  std::fprintf (fp, "fiduciary=%s\n", fiduciary ? fiduciary : "");
  std::fprintf (fp, "authority=%s\n", authority ? authority : "");
  std::fprintf (fp, "source=%s\n", source ? source : "");

  std::fclose (fp);
}

int
plugin_init (struct plugin_name_args *plugin_info,
             struct plugin_gcc_version *)
{
  edition = env_or_default ("MEARVK_METADATA_EDITION", "");
  version_value = env_or_default ("MEARVK_METADATA_VERSION", "");
  company = env_or_default ("MEARVK_METADATA_COMPANY", "");
  fiduciary = env_or_default ("MEARVK_METADATA_FIDUCIARY", "");
  authority = env_or_default ("MEARVK_METADATA_AUTHORITY", "");
  source = env_or_default ("MEARVK_METADATA_SOURCE", "");

  register_callback (plugin_info->base_name,
                     PLUGIN_FINISH_UNIT,
                     emit_metadata,
                     nullptr);

  return 0;
}
