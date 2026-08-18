/*
 * general purpose mouse support for Linux
 *
 * *Startup and Daemon functions*
 *
 * Copyright (c) 2002-2008    Nico Schottelius <nico@schottelius.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 ********/

#include <stdlib.h>     /* atexit() */
#include <string.h>     /* strlen() */
#include <errno.h>      /* errno */
#include <unistd.h>     /* unlink,geteuid */
#include <sys/types.h>  /* geteuid, mknod */
#include <sys/stat.h>   /* mknod */
#include <fcntl.h>      /* mknod */


#include "headers/gpmInt.h"
#include "headers/message.h"
#include "headers/daemon.h"

void startup(int argc, char **argv)
{
   int i, j, opt;
   char *p;

   /* log to debug, who we are */
   gpm_report(GPM_PR_DEBUG, GPM_MESS_VERSION);

   /* basic settings */
   option.run_status    = GPM_RUN_STARTUP;      /* 10,9,8,... let's go */
   option.autodetect    = 0;                    /* no mouse autodection */
   option.progname      = argv[0];              /* who we are */
   option.consolename   = Gpm_get_console();    /* get consolename */

   /* basic2: are not necessary for oops()ing, if not root */
   option.no_mice       = 0;                    /* counts -m + -t */
   option.micelist      = NULL;                 /* no mice found yet */
   option.repeater      = 0;                    /* repeat data */
   option.repeater_type = NULL;                 /* type of */


   cmdline(argc, argv);                         /* parse command line */

   if (geteuid() != 0) gpm_report(GPM_PR_OOPS,GPM_MESS_ROOT); /* root or exit */

   /* Planned for gpm-1.30, but only with devfs */
   /* if(option.autodetect) autodetect(); */

   
   /****************** OLD CODE from gpn.c ***********************/
   
   openlog(option.progname, LOG_PID,
                  option.run_status != GPM_RUN_DEBUG ? LOG_DAEMON : LOG_USER);
   loadlut(opt_lut);

   if (option.repeater) {
      if(mkfifo(GPM_NODE_FIFO,0666) && errno!=EEXIST)
         gpm_report(GPM_PR_OOPS,GPM_MESS_CREATE_FIFO,GPM_NODE_FIFO);
      if((fifofd=open(GPM_NODE_FIFO, O_RDWR|O_NONBLOCK)) < 0)
         gpm_report(GPM_PR_OOPS, GPM_MESS_OPEN, GPM_NODE_FIFO);
   }

   /* duplicate initialization */
   for (i=1; i <= 1+opt_double; i++) {
      which_mouse=mouse_table+i; /* used to access options */
      if ((which_mouse->opt_accel) < 1) exit(usage("acceleration"));
      if ((which_mouse->opt_delta) < 2) exit(usage("delta"));
      if (strlen(which_mouse->opt_sequence) <= 0)
         exit(usage("sequence"));

      /* choose the sequence */
      for (j = 0; j < 9; j++)
         which_mouse->opt_buts[j] = 1 << j;

      for (p = which_mouse->opt_sequence, j = 0; *p != '\0'; p++, j++) {
         if ((*p < '0') || (*p > '9'))
             exit(usage("button sequence"));
         which_mouse->opt_buts[j] = (1 << (*p - '1'));
      }

      if (which_mouse->opt_glidepoint_tap > 9)
         exit(usage("glidepoint tap button"));
      if (which_mouse->opt_glidepoint_tap)
         which_mouse->opt_glidepoint_tap = which_mouse->opt_buts[which_mouse->opt_glidepoint_tap - 1];

      /* look for the mouse type */
      (which_mouse->m_type) = find_mouse_by_name((which_mouse->opt_type));
      if (!(which_mouse->m_type)) /* not found */
         exit(M_listMice());
   }

   /* Check repeater status */
   if (option.repeater) {
      if (strcmp(option.repeater_type,"raw") == 0)
         opt_rawrep = 1;
      else {
         /* look for the type */
         repeated_type = find_mouse_by_name(option.repeater_type);

         if(!repeated_type) exit(M_listTypes()); /* not found */

         if (!(repeated_type->repeat_fun)) /* unsupported translation */
            gpm_report(GPM_PR_OOPS,GPM_MESS_NO_REPEAT,option.repeater_type);
      }
   }

   if (option.run_status == GPM_RUN_STARTUP ) { /* else is debugging */
      if (daemon(0,0))
         gpm_report(GPM_PR_OOPS,GPM_MESS_FORK_FAILED);   /* error  */

      option.run_status = GPM_RUN_DAEMON; /* child  */
   }

   /* damon init: check whether we run or not, display message */
   check_uniqueness();
   gpm_report(GPM_PR_INFO,GPM_MESS_STARTED);

   //return mouse_table[1].fd; /* the second is handled in the main() */

   /****************** OLD CODE from gpn.c  END ***********************/

   init_mice(option.micelist);                  /* reads option.micelist */
   atexit(gpm_exited);                          /* call gpm_exited at the end */
}
