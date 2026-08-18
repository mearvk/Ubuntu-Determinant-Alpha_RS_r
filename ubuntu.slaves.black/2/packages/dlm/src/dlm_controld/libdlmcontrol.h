/*
 * Copyright 2004-2012 Red Hat, Inc.
 *
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the GNU General Public License v2 or (at your option) any later version.
 */

#ifndef _LIBDLMCONTROL_H_
#define _LIBDLMCONTROL_H_

#define DLMC_DUMP_SIZE		(1024 * 1024)

#define DLMC_NF_MEMBER		0x00000001 /* node is member in cg */
#define DLMC_NF_START		0x00000002 /* start message recvd for cg */
#define DLMC_NF_DISALLOWED	0x00000004 /* node disallowed in cg */
#define DLMC_NF_NEED_FENCING	0x00000008
#define DLMC_NF_CHECK_FS	0x00000010

struct dlmc_node {
	int nodeid;
	uint32_t flags;
	uint32_t added_seq;
	uint32_t removed_seq;
	int fail_reason;
	uint64_t fail_walltime;
	uint64_t fail_monotime;
};

#define DLMC_LS_WAIT_RINGID	1
#define DLMC_LS_WAIT_QUORUM	2
#define DLMC_LS_WAIT_FENCING	3
#define DLMC_LS_WAIT_FSDONE	4

struct dlmc_change {
	int member_count;
	int joined_count;
	int remove_count;
	int failed_count;
	int wait_condition;	/* DLMC_LS_WAIT or needed message count */
	int wait_messages;	/* 0 no, 1 yes */
	uint32_t seq;
	uint32_t combined_seq;
};

#define DLMC_LF_JOINING		0x00000001
#define DLMC_LF_LEAVING		0x00000002
#define DLMC_LF_KERNEL_STOPPED	0x00000004
#define DLMC_LF_FS_REGISTERED	0x00000008
#define DLMC_LF_NEED_PLOCKS	0x00000010
#define DLMC_LF_SAVE_PLOCKS	0x00000020

struct dlmc_lockspace {
	struct dlmc_change cg_prev;	/* completed change (started_change) */
	struct dlmc_change cg_next;	/* in-progress change (changes list) */
	uint32_t flags;
	uint32_t global_id;
	char name[DLM_LOCKSPACE_LEN+1];
};

/* dlmc_lockspace_nodes() types

   MEMBERS: members in completed (prev) change,
            zero if there's no completed (prev) change
   NEXT:    members in in-progress (next) change,
            zero if there's no in-progress (next) change
   ALL:     NEXT + nonmembers if there's an in-progress (next) change,
            MEMBERS + nonmembers if there's no in-progress (next) change, but
            there is a completed (prev) change
            nonmembers if there's no in-progress (next) or completed (prev)
            change (possible?)

   dlmc_node_info() returns info for in-progress (next) change, if one exists,
   otherwise it returns info for completed (prev) change.
*/

#define DLMC_NODES_ALL		1
#define DLMC_NODES_MEMBERS	2
#define DLMC_NODES_NEXT		3

#define DLMC_STATUS_VERBOSE	0x00000001

int dlmc_dump_debug(char *buf);
int dlmc_dump_config(char *buf);
int dlmc_dump_run(char *buf);
int dlmc_dump_log_plock(char *buf);
int dlmc_dump_plocks(char *name, char *buf);
int dlmc_lockspace_info(char *lsname, struct dlmc_lockspace *ls);
int dlmc_node_info(char *lsname, int nodeid, struct dlmc_node *node);
int dlmc_lockspaces(int max, int *count, struct dlmc_lockspace *lss);
int dlmc_lockspace_nodes(char *lsname, int type, int max, int *count,
			 struct dlmc_node *nodes);
int dlmc_print_status(uint32_t flags);
int dlmc_reload_config(void);
int dlmc_set_config(char *command);

#define DLMC_RESULT_REGISTER	1
#define DLMC_RESULT_NOTIFIED	2

int dlmc_fs_connect(void);
void dlmc_fs_disconnect(int fd);
int dlmc_fs_register(int fd, char *name);
int dlmc_fs_unregister(int fd, char *name);
int dlmc_fs_notified(int fd, char *name, int nodeid);
int dlmc_fs_result(int fd, char *name, int *type, int *nodeid, int *result);

int dlmc_deadlock_check(char *name);
int dlmc_fence_ack(char *name);


#define DLMC_RUN_UUID_LEN DLM_LOCKSPACE_LEN
#define DLMC_RUN_COMMAND_LEN 1024

/*
 * Run a command on all nodes running dlm_controld.
 *
 * The node where dlmc_run_start() is called will
 * send a corosync message to all nodes running
 * dlm_controld, telling them to run the specified
 * command.
 *
 * On all the nodes, a dlm_controld helper process will
 * fork/exec the specified command, and will send a
 * corosync message with the result of the command.
 *
 * (A flag specifies whether the starting node itself
 * runs the command.  A nodeid arg can specify one node
 * to run the command.)
 *
 * The starting node will collect the results from
 * the replies.
 *
 * The node where dlmc_run_start() was called can
 * run dlmc_run_check() to check the cummulative
 * result of the command from all the nodes.
 */

/*
 * dlmc_run_start() flags
 *
 * NODE_NONE: do not run the command on the starting node
 *            (where dlmc_run_start is called)
 * NODE_FIRST: run the command on the starting node right
 *             when dlmc_run_start is called.
 * NODE_RECV: run the command on the starting node when
 *            it receives its own run request message.
 */
#define DLMC_FLAG_RUN_START_NODE_NONE		0x00000001
#define DLMC_FLAG_RUN_START_NODE_FIRST		0x00000002
#define DLMC_FLAG_RUN_START_NODE_RECV		0x00000004

/*
 * dlmc_run_check() flags
 *
 * CLEAR: clear/free the run record when check sees it is done.
 *
 * CANCEL: clear/free a local run record even if it's not done.
 */
#define DLMC_FLAG_RUN_CHECK_CLEAR		0x00000001
#define DLMC_FLAG_RUN_CHECK_CANCEL		0x00000002

/*
 * dlmc_run_check() result/status flags
 *
 * WAITING: have not received all expected replies
 * DONE: have received all expected replies
 * FAILED: have seen one or more replies with failed result
 */
#define DLMC_RUN_STATUS_WAITING			0x00000001
#define DLMC_RUN_STATUS_DONE			0x00000002
#define DLMC_RUN_STATUS_FAILED			0x00000004

int dlmc_run_start(char *run_command, int len, int nodeid, uint32_t flags, char *run_uuid);

int dlmc_run_check(char *run_uuid, int len, int wait_sec, uint32_t flags,
		   uint32_t *check_status);

#endif

