/*
  Copyright (c) 2009-2017 Dave Gamble and cJSON contributors
  SPDX-License-Identifier: MIT

  This is a PLACEHOLDER file. The full cJSON implementation (~1700 lines)
  is fetched at build time by the Makefile from:
    https://github.com/DaveGamble/cJSON

  To fetch it (needs network access), run from tools/ai/web:
    make cjson-fetch
  or fetch manually:
    curl -fsSL https://raw.githubusercontent.com/DaveGamble/cJSON/master/cJSON.c -o cjson/cJSON.c
    curl -fsSL https://raw.githubusercontent.com/DaveGamble/cJSON/master/cJSON.h -o cjson/cJSON.h

  cJSON is a lightweight JSON parser for C. MIT licensed.
  Used by dave_web to parse Chrome DevTools Protocol responses
  and to generate JSON output for links and metadata.
*/

/* BUILD WILL FAIL UNTIL THE REAL cJSON.c IS VENDORED. */
#error "cJSON.c is a placeholder. Run 'make cjson-fetch' (needs network) or vendor cJSON manually. See README.md."
