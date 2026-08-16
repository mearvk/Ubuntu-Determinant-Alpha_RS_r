/* no_unnamed.c test */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdlib.h>
#include "no_unnamed_cmd.h"

int
main (int argc, char **argv)
{
  struct gengetopt_args_info args_info;

  /* let's call our cmdline parser */
  if (no_unnamed_cmd_parser (argc, argv, &args_info) != 0)
    exit(1) ;

  return 0;
}
