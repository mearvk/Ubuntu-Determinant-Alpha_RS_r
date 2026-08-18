#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <ini.h>
#include "parseargs.h"

bool ini_handler_lineno = false;

int parseargs(int argc, char **argv)
{
    while (1) {
        int option_index = 0;
        static const struct option long_options[] = {
            {"ini_allow_multiline",             required_argument, NULL, 0},
            {"ini_allow_bom",                   required_argument, NULL, 0},
            {"ini_start_comment_prefixes",      required_argument, NULL, 0},
            {"ini_allow_inline_comments",       required_argument, NULL, 0},
            {"ini_inline_comment_prefixes",     required_argument, NULL, 0},
            {"ini_use_stack",                   required_argument, NULL, 0},
            {"ini_max_line",                    required_argument, NULL, 0},
            {"ini_allow_realloc",               required_argument, NULL, 0},
            {"ini_initial_alloc",               required_argument, NULL, 0},
            {"ini_stop_on_first_error",         required_argument, NULL, 0},
//          {"ini_call_handler_on_new_section", required_argument, NULL, 0},
            {"ini_handler_lineno",              required_argument, NULL, 0},
            {"ini_allow_no_value",              required_argument, NULL, 0},
            {0,                                 0,                 NULL, 0}
        };

        static const struct {
            void *val;
            char type;
        } optargs[] = {
            {&ini_allow_multiline,             'b'},
            {&ini_allow_bom,                   'b'},
            {&ini_start_comment_prefixes,      's'},
            {&ini_allow_inline_comments,       'b'},
            {&ini_inline_comment_prefixes,     's'},
            {&ini_use_stack,                   'b'},
            {&ini_max_line,                    'i'},
            {&ini_allow_realloc,               'b'},
            {&ini_initial_alloc,               'i'},
            {&ini_stop_on_first_error,         'b'},
//          {&ini_call_handler_on_new_section, 'b'},
            {&ini_handler_lineno,              'b'},
            {&ini_allow_no_value,              'b'},
            {0,                                  0}
        };

        int c = getopt_long(argc, argv, "", long_options, &option_index);
        if (c == -1)
            break;

        switch (c) {
            case 0:
                switch (optargs[option_index].type) {
                    case 's':
                        *((char **) optargs[option_index].val) = strdup(optarg);
                        break;
                    case 'i':
                        *((int *) optargs[option_index].val) = atoi(optarg);
                        break;
                    case 'b':
                        *((bool *) optargs[option_index].val) = atoi(optarg);
                        break;
                    default:
                        break;
                }
                break;

            default:
                printf("?? getopt returned character code 0%o ??\n", c);
                return 1;
        }
    }
    return 0;
}
