[= AutoGen5 Template c=fork.c -*- Mode: C -*- =]
[= #
 *  fork.tpl: template for passing arguments to autogen forked process.
 *
 *  This file is part of AutoGen.
 *  AutoGen Copyright (C) 1992-2018 by Bruce Korb - all rights reserved
 *
 *  AutoGen is free software: you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  AutoGen is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *  See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program.  If not, see <http://www.gnu.org/licenses/>.
 =][=

(define up-c-name  (lambda (ag-name)
  (string-upcase! (string->c-name! (get ag-name)))  ))

(dne " *  " "/*  ")=]
 *
 *  This module will fire up autogen and have it read definitions
 *  from its standard-in.
 */

static char const fs_err_fmt[] = "%s fs ERROR %d (%s) on %s\n";

/**
 * increase size of argument vector.  Allocation will always be a
 * multiple of 8 times sizeof(void *).
 */
static void
get_argv_space(void)
{
    static void * av = NULL;                    //!< static arg vector
    int    act = (int)xml2agOptions.origArgCt;  //!< current count

    /*
     * First time through, use "malloc" not "realloc".
     */
    if (av == NULL) {
        size_t csz = act * sizeof(void *); //! current size
        /*
         * "act" will always be one less than a multiple of 8 and
         * at least one larger than before.  After first time through,
         * each call will increment by 8.
         */
        act = (act + 10) & ~0x0007;
        av  = malloc(act-- * sizeof(void *));
        if (av == NULL)
            goto no_memory;
        memcpy(av, xml2agOptions.origArgVect, csz);

    } else {
        act += 8;
        av   = realloc(av, (act + 1) * sizeof(void *));
        if (av == NULL)
            goto no_memory;
    }

    xml2agOptions.origArgCt   = act;
    xml2agOptions.origArgVect = av;
    return;

 no_memory:
    fprintf(stderr, "No memory for %d args\n", act+1);
    exit(EXIT_FAILURE);
}

static void
add_arg(char const * arg, int ix)
{
    if (ix >= (int)xml2agOptions.origArgCt)
        get_argv_space();

    xml2agOptions.origArgVect[ix] = VOIDP(arg);
}

static int
become_child(int * fd, char const * in_file)
{
    if (pipe(fd) != 0) {
        fprintf(stderr, fs_err_fmt, xml2agOptions.pzProgName,
                errno, strerror( errno ), "pipe(2)");
        exit(EXIT_FAILURE);
    }

    fflush(stdout);
    fflush(stdin);

    switch (fork()) {
    case -1:
        fprintf(stderr, fs_err_fmt, xml2agOptions.pzProgName,
                errno, strerror( errno ), "fork(2)");
        exit(EXIT_FAILURE);

    case 0:
        fclose(stdin);
        if (dup2(fd[0], STDIN_FILENO) != STDIN_FILENO) {
            fprintf(stderr, fs_err_fmt, xml2agOptions.pzProgName,
                    errno, strerror( errno ), "dup2(2) w/ STDIN_FILENO");
            exit(EXIT_FAILURE);
        }
        close(fd[1]);
        break;

    default:
        errno = 0;
        ag_pipe_fp = fdopen(fd[1], "w");
        if (ag_pipe_fp == NULL) {
            fprintf(stderr, fs_err_fmt, xml2agOptions.pzProgName,
                    errno, strerror( errno ), "fdopen(2) w/ pipe[1]");
            exit(EXIT_FAILURE);
        }
        close(fd[0]);
        return 0;
    }

    if (! HAVE_OPT( BASE_NAME )) {
        if (in_file == NULL)
            in_file = "stdin";
        else {
            char * pz = strrchr(in_file, '.');
            if (pz != NULL) {
                in_file = pz = strdup(in_file);
                pz = strrchr(pz, '.');
                *pz = '\0';
            }
        }
        SET_OPT_BASE_NAME(in_file);
    }

    return 1;
}

void
fork_ag(char const * in_file)
{
    int fd[2];

    if (! become_child(fd, in_file))
        return; // parent process returns

    get_argv_space();

    {
        static char const zAg[] = "autogen";
        char * pzArg;
        int    ix    = 1;

        {
            char * pz = malloc(strlen( xml2agOptions.pzProgPath ) + 7);
            char * p  = strrchr(xml2agOptions.pzProgPath, '/');

            if (p == NULL) {
                strcpy(pz, zAg);
            } else {
                size_t len = (size_t)(p - xml2agOptions.pzProgPath) + 1;
                memcpy(pz, xml2agOptions.pzProgPath, len);
                strcpy(pz + len, zAg);
            }

            add_arg(pz, 0);
        }[=

        FOR flag                   =][=
          IF (define opt-name (up-c-name "name"))

             (and
                 (not (~~ opt-name "OVERRIDE_TPL|OUTPUT"))
                 (not (exist? "documentation"))
             )  =][=

            INVOKE handle-option   =][=
          ENDIF (not override)     =][=
        ENDFOR                     =]

        xml2agOptions.origArgVect[ix] = NULL;
        execvp(xml2agOptions.origArgVect[0], xml2agOptions.origArgVect);

        /*
         *  IF the first try fails, it may be because xml2ag and autogen have
         *  different paths.  Try again with just plain "autogen" and let
         *  the OS search "PATH" for the program.
         */
        execvp(zAg, xml2agOptions.origArgVect);
        fprintf(stderr, fs_err_fmt, xml2agOptions.pzProgName,
                errno, strerror(errno), "execvp(2)");
        exit(EXIT_FAILURE);
    }
}

/*
 * Local Variables:
 * c-file-style: "stroustrup"
 * indent-tabs-mode: nil
 * End:
 * end of [= (out-name) =] */
[=

DEFINE handle-option =]

        if (HAVE_OPT([=(. opt-name)=])) {[=

          CASE arg-type            =][=

          ==*  key                 =]
            static char const * kwlist[] = {
[=(shellf "${CLexe:-columns} -I16 -f'\"%%s\"' -S, --spread=2 <<_EOF_\n%s\n_EOF_"
   (join "\n" (stack "keyword"))  )=] };
            pzArg = malloc([= (+ 4 (string-length (get "name")))
                    =] + strlen( kwlist[ OPT_VALUE_[=(. opt-name)=] ] ));
            sprintf(pzArg, "--[=name=]=%s", kwlist[ OPT_VALUE_[=
                    (. opt-name)=] ]);
            add_arg(pzArg, ix++);[=

          ==*  num                 =]
            pzArg = malloc((size_t)[= (+ 16 (string-length (get "name"))) =]);
            sprintf(pzArg, "--[=name=]=%d", (int)OPT_VALUE_[=(. opt-name)=]);
            add_arg(pzArg, ix++);[=

          ==*  bool                =]
            static char z[] = "--[=name=]=false";
            if (OPT_VALUE_[=(. opt-name)=])
                strcpy(z + [= (+ 3 (string-length (get "name"))) =], "true");
            add_arg(z, ix++);[=

          ==*  str                 =][=
               IF (exist? "max")   =]
            int  optCt = STACKCT_OPT([=(. opt-name)=]);
            char const ** ppOA  = STACKLST_OPT([=(. opt-name)=]);
            do  {
                char const * pA = *(ppOA++);
                pzArg = malloc([= (+ 4 (string-length (get "name")))
                                =] + strlen(pA));
                sprintf(pzArg, "--[=name=]=%s", pA);
                add_arg(pzArg, ix++);
            } while (--optCt > 0);[=
               ELSE !exists-max    =]
            pzArg = malloc([= (+ 4 (string-length (get "name")))
                            =] + strlen( OPT_ARG( [=(. opt-name)=] )));
            sprintf(pzArg, "--[=name=]=%s", OPT_ARG( [=(. opt-name)=] ));
            add_arg(pzArg, ix++);[=
               ENDIF exists-max    =][=

          ==   ""                  =]
            add_arg("--[=name=]", ix++);[=

          ESAC arg-type            =]
        }[=

ENDDEF handle-option

end of fork.tpl \=]
