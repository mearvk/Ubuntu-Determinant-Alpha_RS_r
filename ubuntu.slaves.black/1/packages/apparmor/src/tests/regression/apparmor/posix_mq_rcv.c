#include <mqueue.h>
#include <stdlib.h>
#include <signal.h>
#include <poll.h>
#include <sys/epoll.h>
#include <time.h>

#include "posix_mq.h"

int timeout = 5; //seconds
char *queuename = QNAME;

enum notify_options {
	DO_NOT_NOTIFY,
	MQ_NOTIFY,
	SELECT,
	POLL,
	EPOLL
};

int receive_message(mqd_t mqd, char needs_timeout) {
	ssize_t nbytes;
	struct mq_attr attr;
	char *buf = NULL;

	if (mq_getattr(mqd, &attr) == -1) {
		perror("FAIL - could not mq_getattr");
		goto out;
	}

	buf = malloc(attr.mq_msgsize);
	if (buf == NULL) {
		perror("FAIL - could not malloc");
		goto out;
	}

	if (needs_timeout) { /* do we need this or should we just use mq_timedreceive always? */
		struct timespec ts;
		clock_gettime(CLOCK_REALTIME, &ts);
		ts.tv_sec += timeout;
		nbytes = mq_timedreceive(mqd, buf, attr.mq_msgsize,
					 NULL, &ts);
	} else {
		attr.mq_flags |= O_NONBLOCK;
		if (mq_setattr(mqd, &attr, NULL) == -1){
			perror("FAIL - could not mq_setattr");
			goto out;
		}
		nbytes = mq_receive(mqd, buf, attr.mq_msgsize, NULL);
	}

	if (nbytes < 0) {
		perror("FAIL - could not receive msg");
		goto out;
	}

	buf[nbytes] = 0;

	if (strncmp(buf, msg, BUF_SIZE) != 0) {
		fprintf(stderr, "FAIL - msg received does not match: %s - %s\n", buf, msg);
		goto out;
	}

	printf("PASS\n");

out:
	free(buf);

	if (mq_close(mqd) == (mqd_t) -1) {
		perror("FAIL - could not close mq");
		exit(EXIT_FAILURE);
	}
	if (mq_unlink(queuename) == (mqd_t) -1) {
		perror("FAIL - could unlink mq");
		exit(EXIT_FAILURE);
	}

	exit(EXIT_SUCCESS);
}

static void handle_signal(union sigval sv) {
	mqd_t mqd = *((mqd_t *) sv.sival_ptr);
	receive_message(mqd, 0);
}

static void usage(char *prog_name, char *msg)
{
	if (msg != NULL)
		fprintf(stderr, "%s\n", msg);

	fprintf(stderr, "Usage: %s [options]\n", prog_name);
	fprintf(stderr, "Options are:\n");
	fprintf(stderr, "-n        get notified if there's an item in the queue\n");
	fprintf(stderr, "          available options are: mq_notify, select, poll and epoll\n");
	fprintf(stderr, "-k        message queue name (default is %s)\n", QNAME);
	fprintf(stderr, "-c        path of the client binary\n");
	fprintf(stderr, "-u        run test as specified UID\n");
	fprintf(stderr, "-t        timeout in seconds\n");
	exit(EXIT_FAILURE);
}

void receive_mq_notify(mqd_t mqd)
{
	struct sigevent sev;
	sev.sigev_notify = SIGEV_THREAD;
	sev.sigev_notify_function = handle_signal;
	sev.sigev_notify_attributes = NULL;
	sev.sigev_value.sival_ptr = &mqd;

	if (mq_notify(mqd, &sev) == -1) {
		perror(" FAIL - could not mq_notify");
		exit(EXIT_FAILURE);
	}
	sleep(timeout);
	fprintf(stderr, "FAIL - could not mq_notify: Connection timed out\n");
}

void receive_select(mqd_t mqd)
{
	fd_set read_fds;
	struct timeval tv;
	tv.tv_sec = timeout;
	tv.tv_usec = 0;

	FD_ZERO(&read_fds);
	FD_SET(mqd, &read_fds);

	if (select(mqd + 1, &read_fds, NULL, NULL, &tv) == -1) {
		perror("FAIL - could not select");
		exit(EXIT_FAILURE);
	} else {
		if (FD_ISSET(mqd, &read_fds))
			receive_message(mqd, 0);
	}
}

void receive_poll(mqd_t mqd)
{
	struct pollfd fds[1];
	fds[0].fd = mqd;
	fds[0].events = POLLIN;

	if (poll(fds, 1, timeout * 1000) == -1) {
		perror("FAIL - could not poll");
		exit(EXIT_FAILURE);
	} else {
		if (fds[0].revents & POLLIN)
			receive_message(mqd, 0);
	}
}

void receive_epoll(mqd_t mqd)
{
	int epfd = epoll_create(1);
	if (epfd == -1) {
		perror("FAIL - could not create epoll");
		exit(EXIT_FAILURE);
	}

	struct epoll_event ev, rev[1];
	ev.events = EPOLLIN;
	ev.data.fd = mqd;
	if (epoll_ctl(epfd, EPOLL_CTL_ADD, mqd, &ev) == -1) {
		perror("FAIL - could not add mqd to epoll");
		exit(EXIT_FAILURE);
	}

	if (epoll_wait(epfd, rev, 1, timeout * 1000) == -1) {
		perror("FAIL - could not epoll_wait");
		exit(EXIT_FAILURE);
	} else {
		if (rev[0].data.fd == mqd && rev[0].events & EPOLLIN)
			receive_message(mqd, 0);
	}
}

void receive(enum notify_options notify, mqd_t mqd)
{
	switch(notify) {
	case DO_NOT_NOTIFY:
		receive_message(mqd, 1);
		return;
	case MQ_NOTIFY:
		receive_mq_notify(mqd);
		break;
	case SELECT:
		receive_select(mqd);
		break;
	case POLL:
		receive_poll(mqd);
		break;
	case EPOLL:
		receive_epoll(mqd);
		break;
	}
}

int main(int argc, char *argv[])
{
	char opt = 0;
	enum notify_options notify = DO_NOT_NOTIFY;
	mqd_t mqd;
	char *client = NULL;
	int uid;
	struct mq_attr attr;
	attr.mq_flags = 0;
	attr.mq_maxmsg = 10;
	attr.mq_msgsize = BUF_SIZE;
	attr.mq_curmsgs = 0;

	while ((opt = getopt(argc, argv, "n:k:c:u:t:")) != -1) {
		switch (opt) {
		case 'n':
			if (strcmp(optarg, "mq_notify") == 0)
				notify = MQ_NOTIFY;
			else if (strcmp(optarg, "select") == 0)
				notify = SELECT;
			else if (strcmp(optarg, "poll") == 0)
				notify = POLL;
			else if (strcmp(optarg, "epoll") == 0)
				notify = EPOLL;
			else
				usage(argv[0], "invalid option for -n");
			break;
		case 'k':
			queuename = optarg;
			if (queuename == NULL)
				usage(argv[0], "-k option must specify the queue name\n");
			break;
		case 'c':
			client = optarg;
			if (client == NULL)
				usage(argv[0], "-c option must specify the client binary\n");
			break;
		case 'u':
			/* change file mode on output before setuid drops
			 * privs. This is required to make sure we can
			 * write to the output file and in some cases
			 * even exec with our inherited output file
			 *
			 * This assume test infrastructure creates the
			 * file as root and dups stderr to stdout
			 */
			if (fchmod(fileno(stdout), 0666) == -1) {
				perror("FAIL - could not set output file mode");
				exit(EXIT_FAILURE);
			}
			if (fchmod(fileno(stderr), 0666) == -1) {
				perror("FAIL - could not set output file mode");
				exit(EXIT_FAILURE);
			}
			uid = atoi(optarg);
			if (setuid(uid) < 0) {
				perror("FAIL - could not setuid");
				exit(EXIT_FAILURE);
			}
			break;
		case 't':
			timeout = atoi(optarg);
			break;
		default:
			usage(argv[0], "Unrecognized option\n");
		}
	}

	mqd = mq_open(queuename, O_CREAT | O_RDONLY, OBJ_PERMS, &attr);
	if (mqd == (mqd_t) -1) {
		perror("FAIL - could not open mq");
		exit(EXIT_FAILURE);
	}

	/* exec the client */
	int pid = fork();
	if (pid == -1) {
		perror("FAIL - could not fork");
		exit(EXIT_FAILURE);
	} else if (!pid) {
		if (client == NULL) {
			usage(argv[0], "client not specified");
			exit(EXIT_FAILURE);
			/* execution of the main thread continues
			 * in case the client will be manually executed
			 */
		}
		execl(client, client, queuename, NULL);
		printf("FAIL %d - execlp %s %s- %m\n", getuid(), client, queuename);
		exit(EXIT_FAILURE);
	}

	receive(notify, mqd);

	/* when the notification fails because of timeout, it ends up here
	 * so, clean up the mqueue
	 */

	if (mq_close(mqd) == (mqd_t) -1) {
		perror("FAIL - could not close mq");
		exit(EXIT_FAILURE);
	}
	if (mq_unlink(queuename) == (mqd_t) -1) {
		perror("FAIL - could unlink mq");
		exit(EXIT_FAILURE);
	}

	return 0;
}
