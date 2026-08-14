#ifndef SYSV_MQ_H_
#define SYSV_MQ_H_

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/msg.h>
#include <sys/stat.h>

#define MQ_KEY (123)
#define MQ_TYPE (0)
#define SHM_KEY (456)
#define SEM_KEY (789)
#define OBJ_PERMS (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH)

#define BUF_SIZE 1024
struct msg_buf {
	long mtype;
	char mtext[BUF_SIZE];
};

union semun {
	int              val;
	struct semid_ds *buf;
	unsigned short  *array;
	struct seminfo  *__buf;
};


char *msg = "hello world";

#endif /* #ifndef SYSV_MQ_H_ */
