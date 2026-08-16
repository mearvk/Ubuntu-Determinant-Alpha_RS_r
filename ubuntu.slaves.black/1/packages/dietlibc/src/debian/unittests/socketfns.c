#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <sys/un.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <poll.h>
#include <errno.h>
#include <stddef.h>

#define SOCK_NAME "diet.testsocket"

static void cleanup()
{
  unlink(SOCK_NAME);
}

static int parent(int sock, pid_t pid)
{
  int l_sock, r;
  struct sockaddr_un sun, sun2;
  pid_t received_pid;
  ssize_t len;
  size_t rcvbuf;
  socklen_t optlen, addrlen, addrlen2;
  struct pollfd poll_fds[1];
  struct msghdr msg;
  struct iovec iov[1];

  atexit(cleanup);
  signal(SIGTERM, cleanup);
  signal(SIGSEGV, cleanup);
  signal(SIGBUS, cleanup);
  signal(SIGILL, cleanup);

  l_sock = socket(AF_UNIX, SOCK_STREAM, 0);
  if (l_sock < 0) {
    perror("parent: socket");
    kill(pid, SIGTERM);
    return 1;
  }

  /* bind extra listening socket */
  unlink(SOCK_NAME);
  sun.sun_family = AF_UNIX;
  strcpy(sun.sun_path, SOCK_NAME);
  r = bind(l_sock, (struct sockaddr *)&sun, offsetof(struct sockaddr_un, sun_path) + strlen(SOCK_NAME) + 1);
  if (r < 0) {
    perror("parent: bind");
    kill(pid, SIGTERM);
    return 1;
  }

  /* listen on that socket */
  r = listen(l_sock, 5);
  if (r < 0) {
    perror("parent: listen");
    kill(pid, SIGTERM);
    return 1;
  }

  /* getsockopt on socketpair-socket */
  optlen = sizeof(rcvbuf);
  r = getsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvbuf, &optlen);
  if (r < 0) {
    perror("parent: getsockopt");
    kill(pid, SIGTERM);
    return 1;
  }

  /* set receive buffer */
  if (rcvbuf > 256)
    rcvbuf = 256;
  r = setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(optlen));
  if (r < 0) {
    perror("parent: setsockopt");
    kill(pid, SIGTERM);
    return 1;
  }

  /* receive pid over socketpair-socket */
  len = recv(sock, &received_pid, sizeof(pid_t), 0);
  if (len != sizeof(pid_t)) {
    perror("parent: recv[sp-socket]");
    kill(pid, SIGTERM);
    return 1;
  }
  if (received_pid != pid) {
    fprintf(stderr, "parent: pid from child mismatch: [received =] %lu <> [child pid =] %lu\n", (unsigned long)received_pid, (unsigned long)pid);
    kill(pid, SIGTERM);
    return 1;
  }

  r = 0;
  len = send(sock, &r, sizeof(r), 0);
  if (len != sizeof(int)) {
    perror("parent: send[sp-socket]");
    kill(pid, SIGTERM);
    return 1;
  }

  /* close socket */
  close(sock);

  /* accept connection */
  addrlen = sizeof(sun);
  memset(&sun, 0x77, sizeof(sun));
  sock = accept(l_sock, (struct sockaddr *)&sun, &addrlen);
  if (sock < 0) {
    perror("parent: accept");
    kill(pid, SIGTERM);
    return 1;
  }

  if (sun.sun_family != AF_UNIX) {
    fprintf(stderr, "accept returned non-UNIX socket\n");
    kill(pid, SIGTERM);
    return 1;
  }

  /* poll the new socket for reading */
  poll_fds[0].fd = sock;
  poll_fds[0].events = POLLIN;
  poll_fds[0].revents = 0;
  r = poll(poll_fds, 1, -1);
  if (r < 0) {
    perror("parent: poll");
    kill(pid, SIGTERM);
    return 1;
  }

  if (!(poll_fds[0].revents & POLLIN)) {
    fprintf(stderr, "parent: poll: returned revents != POLLIN [%d]\n", poll_fds[0].revents);
    kill(pid, SIGTERM);
    return 1;
  }

  /* receive from that socket */
  addrlen2 = sizeof(sun2);
  memset(&sun2, 0x33, sizeof(sun2));
  len = recvfrom(sock, &r, sizeof(int), 0, (struct sockaddr *)&sun2, &addrlen2);
  if (len < 0) {
    perror("parent: recvfrom");
    kill(pid, SIGTERM);
    return 1;
  }

  /* check whether data is expected */
  if (r != 42) {
    fprintf(stderr, "parent: recvfrom didn't give us 42...\n");
    kill(pid, SIGTERM);
    return 1;
  }

  /* close that socket, accept4 the next one */
  close(sock);

  addrlen = sizeof(sun);
  memset(&sun, 0xaa, sizeof(sun));
  sock = accept4(l_sock, (struct sockaddr *)&sun, &addrlen, SOCK_CLOEXEC);
  if (sock < 0) {
    perror("parent: accept4");
    kill(pid, SIGTERM);
    return 1;
  }

  if (sun.sun_family != AF_UNIX) {
    fprintf(stderr, "accept4 returned non-UNIX socket\n");
    kill(pid, SIGTERM);
    return 1;
  }

  /* ppoll the new socket for reading */
  poll_fds[0].fd = sock;
  poll_fds[0].events = POLLIN;
  poll_fds[0].revents = 0;
  r = ppoll(poll_fds, 1, NULL, NULL);
  if (r < 0) {
    perror("parent: ppoll");
    kill(pid, SIGTERM);
    return 1;
  }

  if (!(poll_fds[0].revents & POLLIN)) {
    fprintf(stderr, "parent: ppoll: returned revents != POLLIN [%d]\n", poll_fds[0].revents);
    kill(pid, SIGTERM);
    return 1;
  }

  memset(&sun2, 0x55, sizeof(sun2));
  iov[0].iov_base = &r;
  iov[0].iov_len = sizeof(int);
  msg.msg_name = (struct sockaddr *)&sun2;
  msg.msg_namelen = sizeof(sun2);
  msg.msg_iov = iov;
  msg.msg_iovlen = 1;
  msg.msg_control = NULL;
  msg.msg_controllen = 0;
  msg.msg_flags = 0;

  len = recvmsg(sock, &msg, 0);
  if (len != sizeof(int)) {
    perror("parent: recvmsg");
    kill(pid, SIGTERM);
    return 1;
  }

  if (r != 0x01abcdef) {
    fprintf(stderr, "parent: recvmsg didn't give us 0x01abcdef...\n");
    kill(pid, SIGTERM);
    return 1;
  }

  close(sock);
  close(l_sock);

again:
  waitpid(pid, &r, 0);
  if (received_pid == (pid_t)-1 && errno == EINTR)
    goto again;
  if (received_pid != pid || !WIFEXITED(r) || WEXITSTATUS(r) != 0) {
    fprintf(stderr, "parent: child terminated abnormally\n");
    return 1;
  }

  return 0;
}

static int child(int sock)
{
  int r;
  struct sockaddr_un sun;
  pid_t sent_pid;
  ssize_t len;
  struct msghdr msg;
  struct iovec iov[1];

  sent_pid = getpid();
  len = send(sock, &sent_pid, sizeof(pid_t), 0);
  if (len != sizeof(pid_t)) {
    perror("child: send");
    return 1;
  }
  len = recv(sock, &r, sizeof(int), 0);
  if (len != sizeof(int)) {
    perror("child: recv");
    return 1;
  }
  if (r != 0) {
    fprintf(stderr, "child: recv: received %d instead of 0\n", r);
    return 1;
  }
  close(sock);

  sock = socket(AF_UNIX, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("child: socket");
    return 1;
  }

  sun.sun_family = AF_UNIX;
  strcpy(sun.sun_path, SOCK_NAME);
  r = connect(sock, (struct sockaddr *)&sun, offsetof(struct sockaddr_un, sun_path) + strlen(SOCK_NAME) + 1);
  if (r < 0) {
    perror("child: connect");
    return 1;
  }

  r = 42;
  len = sendto(sock, &r, sizeof(int), 0, NULL, 0);
  if (len < 0) {
    perror("child: sendto");
    return 1;
  }

  close(sock);

  sock = socket(AF_UNIX, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("child: socket[2]");
    return 1;
  }

  sun.sun_family = AF_UNIX;
  strcpy(sun.sun_path, SOCK_NAME);
  r = connect(sock, (struct sockaddr *)&sun, offsetof(struct sockaddr_un, sun_path) + strlen(SOCK_NAME) + 1);
  if (r < 0) {
    perror("child: connect[2]");
    return 1;
  }

  r = 0x01abcdef;
  iov[0].iov_base = &r;
  iov[0].iov_len = sizeof(int);
  msg.msg_name = NULL;
  msg.msg_namelen = 0;
  msg.msg_iov = iov;
  msg.msg_iovlen = 1;
  msg.msg_control = NULL;
  msg.msg_controllen = 0;
  msg.msg_flags = 0;
  len = sendmsg(sock, &msg, 0);
  if (len != sizeof(int)) {
    perror("child: sendmsg");
    return 1;
  }

  return 0;
}

int main(int argc, char **argv)
{
  int r;
  int sv[2];
  pid_t pid;

  r = socketpair(AF_UNIX, SOCK_STREAM, 0, sv);
  if (r < 0) {
    perror("socketpair");
    return 1;
  }

  pid = fork();
  if (pid < 0) {
    perror("fork");
    return 1;
  }
  close(sv[pid!=0]);
  if (pid > 0) {
    /* parent */
    return parent(sv[0], pid);
  } else {
    /* child */
    return child(sv[1]);
  }
}
