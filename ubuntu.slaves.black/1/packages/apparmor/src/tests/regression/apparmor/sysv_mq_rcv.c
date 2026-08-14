#define _GNU_SOURCE
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "sysv_mq.h"

int timeout = 5; //seconds
key_t mqkey = MQ_KEY;
long mqtype = MQ_TYPE;
key_t semkey = SEM_KEY;

// missing getattr and setattr
int receive_message(int qid, long qtype)
{
	struct msg_buf mb;
	ssize_t nbytes;

	nbytes = msgrcv(qid, &mb, sizeof(mb.mtext), qtype,
			MSG_NOERROR | IPC_NOWAIT);
	if (nbytes < 0) {
		perror("FAIL - could not receive msg");
		return EXIT_FAILURE;
	}

	mb.mtext[nbytes] = 0;

	if (strncmp(mb.mtext, msg, BUF_SIZE) != 0) {
		fprintf(stderr, "FAIL - msg received does not match: %s - %s\n", mb.mtext, msg);
		return EXIT_FAILURE;
	}

	printf("PASS\n");
	return EXIT_SUCCESS;
}

int receive(int qid, long qtype, int semid)
{
	struct sembuf sop;
	sop.sem_num = 0;
	sop.sem_op = 0;
	sop.sem_flg = 0;

	struct timespec ts;
	ts.tv_sec = timeout;
	ts.tv_nsec = 0;

	if (semtimedop(semid, &sop, 1, &ts) < 0) {
		perror("FAIL - could not wait for semaphore");
		return EXIT_FAILURE;
	}

	return receive_message(qid, qtype);
}

static void usage(char *prog_name, char *msg)
{
	if (msg != NULL)
		fprintf(stderr, "%s\n", msg);

	fprintf(stderr, "Usage: %s [options]\n", prog_name);
	fprintf(stderr, "Options are:\n");
	fprintf(stderr, "-k        message queue key (default is %d)\n", MQ_KEY);
	fprintf(stderr, "-e        message queue type (default is %d)\n", MQ_TYPE);
	fprintf(stderr, "-c        path of the client binary\n");
	fprintf(stderr, "-u        run test as specified UID\n");
	fprintf(stderr, "-t        timeout in seconds\n");
	fprintf(stderr, "-s        semaphore key (default is %d)\n", SEM_KEY);
	exit(EXIT_FAILURE);
}

int main(int argc, char *argv[])
{
	char opt = 0;
	char *client = NULL;
	int uid;
	int qid;
	int semid;
	int rc = EXIT_SUCCESS;
	const int stringsize = 50;
	char smqkey[stringsize];
	char ssemkey[stringsize];

	while ((opt = getopt(argc, argv, "k:c:u:t:e:s:")) != -1) {
		switch (opt) {
		case 'k':
			mqkey = atoi(optarg);
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
		case 'e':
			mqtype = atoi(optarg);
			break;
		case 's':
			semkey = atoi(optarg);
			break;
		default:
			usage(argv[0], "Unrecognized option\n");
		}
	}


	qid = msgget(mqkey, IPC_CREAT | OBJ_PERMS);
	if (qid == -1) {
		perror("FAIL - could not msgget");
		return EXIT_FAILURE;
	}

	semid = semget(semkey, 1, IPC_CREAT | OBJ_PERMS);
	if (semid == -1) {
		perror("FAIL - could not get semaphore");
		rc = EXIT_FAILURE;
		goto out_mq;
	}

	union semun arg;
	arg.val = 1;
	if (semctl(semid, 0, SETVAL, arg) == -1) {
		perror("FAIL - could not get semaphore");
		rc = EXIT_FAILURE;
		goto out;
	}

	/* exec the client */
	int pid = fork();
	if (pid == -1) {
		perror("FAIL - could not fork");
		rc = EXIT_FAILURE;
		goto out;
	} else if (!pid) {
		if (client == NULL) {
			usage(argv[0], "client not specified");
			exit(EXIT_FAILURE);
			/* execution of the main thread continues
			 * in case the client will be manually executed
			 */
		}
		snprintf(smqkey, stringsize - 1, "%d", mqkey);
		snprintf(ssemkey, stringsize - 1, "%d", semkey);
		execl(client, client, smqkey, ssemkey, NULL);
		printf("FAIL %d - execl %s %d - %m\n", getuid(), client, mqkey);
		exit(EXIT_FAILURE);
	}

	rc = receive(qid, mqtype, semid);
out:
	if (semctl(semid, 0, IPC_RMID) == -1) {
		perror("FAIL - could not remove semaphore");
		rc = EXIT_FAILURE;
	}
out_mq:
	if (msgctl(qid, IPC_RMID, NULL) < 0) {
		perror("FAIL - could not remove msg queue");
		rc = EXIT_FAILURE;
	}

	return rc;
}
