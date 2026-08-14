#ifndef POSIX_MQ_H_
#define POSIX_MQ_H_

#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <semaphore.h>

#define QNAME "/testmq"
#define SHM_PATH "/unnamedsemtest"
#define SEM_PATH "/namedsemtest"
#define OBJ_PERMS (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH)

#define BUF_SIZE 1024
struct shmbuf { // Buffer in shared memory
	sem_t sem;
	int cnt; // Number of bytes used in 'buf'
	char buf[BUF_SIZE]; // Data being transferred
};

struct msgbuf {
	long mtype;
	char mtext[BUF_SIZE];
};

char *msg = "hello world";

#endif /* #ifndef POSIX_MQ_H_ */
