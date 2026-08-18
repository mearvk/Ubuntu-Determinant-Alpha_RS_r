/*
 * Copyright 2012 Red Hat, Inc.
 *
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the GNU General Public License v2 or (at your option) any later version.
 */

#include <inttypes.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <poll.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <time.h>
#include <stdarg.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <grp.h>

#include "dlm_daemon.h"


static int _log_stderr;

#define log_helper(fmt, args...) \
do { \
	if (_log_stderr) \
		fprintf(stderr, "%llu " fmt "\n", (unsigned long long)monotime(), ##args); \
} while (0)


/*
 * Restrict the commands that can be run.
 */

#define CMD_ID_LVCHANGE_REFRESH 1
#define CMD_ID_LVS 2

static int _get_cmd_id(char **av, int av_count)
{
	if ((av_count >= 3) &&
	    !strcmp(av[0], "lvm") &&
	    !strcmp(av[1], "lvchange") &&
	    !strcmp(av[2], "--refresh")) {
		return CMD_ID_LVCHANGE_REFRESH;
	}

	if ((av_count >= 2) &&
	    !strcmp(av[0], "lvm") &&
	    !strcmp(av[1], "lvs")) {
		return CMD_ID_LVS;
	}

	return 0;
}

/*
 * Keep track of running pids mainly because when the process
 * exits we get the pid, and need to look up the uuid from the
 * pid to return the uuid/pid/result back to the main daemon.
 */

#define MAX_RUNNING 32

struct running {
	char uuid[RUN_UUID_LEN];
	int pid;
	int cmd_id;
};

static struct running running_cmds[MAX_RUNNING];
static int running_count;

static int _save_running_cmd(char *uuid, int pid, int cmd_id)
{
	int i;

	for (i = 0; i < MAX_RUNNING; i++) {
		if (!running_cmds[i].pid) {
			running_cmds[i].pid = pid;
			running_cmds[i].cmd_id = cmd_id;
			memcpy(running_cmds[i].uuid, uuid, RUN_UUID_LEN);
			running_count++;
			return 0;
		}
	}
	log_helper("too many running commands");
	return -1;
}

static struct running *_get_running_cmd(int pid)
{
	int i;

	for (i = 0; i < MAX_RUNNING; i++) {
		if (running_cmds[i].pid == pid)
			return &running_cmds[i];
	}
	return NULL;
}

static struct running *_get_running_uuid(char *uuid)
{
	int i;

	for (i = 0; i < MAX_RUNNING; i++) {
		if (!strcmp(running_cmds[i].uuid, uuid))
			return &running_cmds[i];
	}
	return NULL;
}

static void _clear_running_cmd(struct running *running)
{
	running_count--;
	running->pid = 0;
	running->cmd_id = 0;
	memset(running->uuid, 0, RUN_UUID_LEN);
}

/* runs in child process that was forked by helper */

static void exec_command(char *cmd_str, int out_fd)
{
	char cmd_buf[16];
	char arg[ONE_ARG_LEN];
	char *av[MAX_AV_COUNT + 1]; /* +1 for NULL */
	int av_count = 0;
	int i, rv, arg_len, cmd_len, cmd_id;

	for (i = 0; i < MAX_AV_COUNT + 1; i++)
		av[i] = NULL;

	if (!cmd_str[0])
		return;

	/* this should already be done, but make sure */
	cmd_str[RUN_COMMAND_LEN - 1] = '\0';

	memset(&arg, 0, sizeof(arg));
	arg_len = 0;
	cmd_len = strlen(cmd_str);

	for (i = 0; i < cmd_len; i++) {
		if (!cmd_str[i])
			break;

		if (av_count == MAX_AV_COUNT)
			break;

		if (cmd_str[i] == '\\') {
			if (i == (cmd_len - 1))
				break;
			i++;

			if (cmd_str[i] == '\\') {
				arg[arg_len++] = cmd_str[i];
				continue;
			}
			if (isspace(cmd_str[i])) {
				arg[arg_len++] = cmd_str[i];
				continue;
			} else {
				break;
			}
		}

		if (isalnum(cmd_str[i]) || ispunct(cmd_str[i])) {
			arg[arg_len++] = cmd_str[i];
		} else if (isspace(cmd_str[i])) {
			if (arg_len)
				av[av_count++] = strdup(arg);

			memset(arg, 0, sizeof(arg));
			arg_len = 0;
		} else {
			break;
		}
	}

	if ((av_count < MAX_AV_COUNT) && arg_len) {
		av[av_count++] = strdup(arg);
	}

	/*
	for (i = 0; i < MAX_AV_COUNT + 1; i++) {
		if (!av[i])
			break;

		log_helper("command av[%d] \"%s\"", i, av[i]);
	}
	*/

	cmd_id = _get_cmd_id(av, av_count);

	/* tell the parent the command we have identified to run */
	memset(cmd_buf, 0, sizeof(cmd_buf));
	snprintf(cmd_buf, sizeof(cmd_buf), "cmd_id %d", cmd_id);
	rv = write(out_fd, cmd_buf, sizeof(cmd_buf));
	if (rv < 0)
		log_helper("write cmd_buf from child error %d", rv);
	close(out_fd);

	/* if we return before exec, the child does exit(1) (failure) */
	if (!cmd_id)
		return;

	execvp(av[0], av);
}

static int read_request(int fd, struct run_request *req)
{
	int rv;
 retry:
	rv = read(fd, req, sizeof(struct run_request));
	if (rv == -1 && errno == EINTR)
		goto retry;

	if (rv != sizeof(struct run_request))
		return -1;
	return 0;
}

static int send_status(int fd)
{
	struct run_reply rep;
	int rv;

	memset(&rep, 0, sizeof(rep));

	rv = write(fd, &rep, sizeof(rep));

	if (rv == sizeof(rep))
		return 0;
	return -1;
}

static int send_result(struct running *running, int fd, int pid, int result)
{
	struct run_reply rep;
	int rv;

	memset(&rep, 0, sizeof(rep));

	rep.header.type = DLM_MSG_RUN_REPLY;

	memcpy(rep.uuid, running->uuid, RUN_UUID_LEN);
	rep.info.local_pid = pid;
	rep.info.local_result = result;

	rv = write(fd, &rep, sizeof(rep));

	if (rv == sizeof(rep))
		return 0;
	return -1;
}

#define HELPER_STATUS_INTERVAL 30
#define STANDARD_TIMEOUT_MS (HELPER_STATUS_INTERVAL*1000)
#define RECOVERY_TIMEOUT_MS 1000

/* run by the child helper process forked by dlm_controld in setup_helper */

int run_helper(int in_fd, int out_fd, int log_stderr)
{
	struct pollfd pollfd;
	struct run_request req;
	struct running *running;
	struct dlm_header *hd = (struct dlm_header *)&req;
	char cmd_buf[16];
	siginfo_t info;
	unsigned int fork_count = 0;
	unsigned int done_count = 0;
	time_t now, last_send, last_good = 0;
	int timeout = STANDARD_TIMEOUT_MS;
	int rv, pid, cmd_id;

	_log_stderr = log_stderr;

	rv = setgroups(0, NULL);
	if (rv < 0)
		log_helper("error clearing helper groups errno %i", errno);

	memset(&pollfd, 0, sizeof(pollfd));
	pollfd.fd = in_fd;
	pollfd.events = POLLIN;

	now = monotime();
	last_send = now;
	rv = send_status(out_fd);
	if (!rv)
		last_good = now;

	openlog("dlm_controld", LOG_CONS | LOG_PID, LOG_LOCAL4);

	while (1) {
		rv = poll(&pollfd, 1, timeout);
		if (rv == -1 && errno == EINTR)
			continue;

		if (rv < 0)
			exit(0);

		now = monotime();

		if (now - last_good >= HELPER_STATUS_INTERVAL &&
		    now - last_send >= 2) {
			last_send = now;
			rv = send_status(out_fd);
			if (!rv)
				last_good = now;
		}

		memset(&req, 0, sizeof(req));

		if (pollfd.revents & POLLIN) {
			rv = read_request(in_fd, &req);
			if (rv)
				continue;

			if (hd->type == DLM_MSG_RUN_REQUEST) {
				int cmd_pipe[2];

				if (running_count >= MAX_RUNNING) {
					log_helper("too many running commands");
					exit(1);
				}

				/*
				 * Child writes cmd_buf to cmd_pipe, parent reads
				 * cmd_buf from cmd_pipe.  cmd_buf contains the
				 * string "cmd_id <num>" where <num> is CMD_ID_NUM
				 * identifying the command being run by the child.
				 */

				if (pipe(cmd_pipe))
					exit(1);

				pid = fork();
				if (!pid) {
					close(cmd_pipe[0]);
					exec_command(req.command, cmd_pipe[1]);
					exit(1);
				}

				close(cmd_pipe[1]);

				memset(cmd_buf, 0, sizeof(cmd_buf));
				cmd_id = 0;

				rv = read(cmd_pipe[0], cmd_buf, sizeof(cmd_buf));
				if (rv < 0)
					log_helper("helper read child cmd_id error %d", rv);

				close(cmd_pipe[0]);

				sscanf(cmd_buf, "cmd_id %d", &cmd_id);

				_save_running_cmd(req.uuid, pid, cmd_id);

				fork_count++;

				log_helper("helper run %s pid %d cmd_id %d running %d fork_count %d done_count %d %s",
					   req.uuid, pid, cmd_id, running_count, fork_count, done_count, req.command);

			} else if (hd->type == DLM_MSG_RUN_CANCEL) {

				/* TODO: should we also send kill to the pid? */

				if (!(running = _get_running_uuid(req.uuid)))
					log_helper("no running cmd for cancel uuid");
				else {
					log_helper("cancel running cmd uuid %s pid %d", running->uuid, running->pid);
					_clear_running_cmd(running);
				}
			}
		}

		if (pollfd.revents & (POLLERR | POLLHUP | POLLNVAL))
			exit(0);

		/* collect child exits until no more children exist (ECHILD)
		   or none are ready (WNOHANG) */

		while (1) {
			memset(&info, 0, sizeof(info));

			rv = waitid(P_ALL, 0, &info, WEXITED | WNOHANG);

			if ((rv < 0) && (errno == ECHILD)) {
				/*
				log_helper("helper no children exist fork_count %d done_count %d", fork_count, done_count);
				*/
				timeout = STANDARD_TIMEOUT_MS;
			}

			else if (!rv && !info.si_pid) {
				log_helper("helper no children ready fork_count %d done_count %d", fork_count, done_count);
				timeout = RECOVERY_TIMEOUT_MS;
			}

			else if (!rv && info.si_pid) {
				done_count++;

				if (!(running = _get_running_cmd(info.si_pid))) {
					log_helper("running cmd for pid %d result %d not found",
						   info.si_pid, info.si_status);
					continue;
				} else {
					log_helper("running cmd for pid %d result %d done",
						   info.si_pid, info.si_status);
				}

				if (info.si_status) {
					syslog(LOG_ERR, "%llu run error %s id %d pid %d status %d code %d",
					       (unsigned long long)monotime(),
					       running->uuid, running->cmd_id, running->pid,
					       info.si_status, info.si_code);
				}

				send_result(running, out_fd, info.si_pid, info.si_status);

				_clear_running_cmd(running);
				continue;
			}

			else {
				log_helper("helper waitid rv %d errno %d fork_count %d done_count %d",
					  rv, errno, fork_count, done_count);
			}

			break;
		}
	}

	closelog();
	return 0;
}
