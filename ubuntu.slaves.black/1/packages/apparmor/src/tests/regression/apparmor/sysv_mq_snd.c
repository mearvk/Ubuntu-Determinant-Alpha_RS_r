#include "sysv_mq.h"

int main(int argc, char *argv[])
{
	key_t mqkey = MQ_KEY;
	key_t semkey = SEM_KEY;
	long qtype = 1;
	int qid, semid;
	struct msg_buf mb;

	if (argc != 1 && argc != 3) {
		fprintf(stderr, "FAIL sender - specify values for message queue"
			" key and semaphore key, respectively \n");
		return EXIT_FAILURE;
	}
	if (argc > 1) {
		mqkey = atoi(argv[1]);
		semkey = atoi(argv[2]);
	}

	qid = msgget(mqkey, IPC_CREAT | OBJ_PERMS);
	if (qid == -1) {
		perror("FAIL sender - could not msgget");
		exit(EXIT_FAILURE);
	}

	semid = semget(semkey, 1, IPC_CREAT | OBJ_PERMS);
	if (semid == -1) {
		perror("FAIL sender - could not get semaphore");
		exit(EXIT_FAILURE);
	}

	snprintf(mb.mtext, sizeof(mb.mtext), "%s", msg);
	mb.mtype = qtype;

	if (msgsnd(qid, &mb, sizeof(struct msg_buf),
		   IPC_NOWAIT) == -1) {
		perror("FAIL sender - could not msgsnd");
		exit(EXIT_FAILURE);
	}

	/* notify using semaphore */

	struct sembuf sop;
	sop.sem_num = 0;
	sop.sem_op = -1;
	sop.sem_flg = 0;

	if (semop(semid, &sop, 1) == -1) {
		perror("FAIL sender - could not notify using semaphore");
		exit(EXIT_FAILURE);
	}

	return EXIT_SUCCESS;
}
