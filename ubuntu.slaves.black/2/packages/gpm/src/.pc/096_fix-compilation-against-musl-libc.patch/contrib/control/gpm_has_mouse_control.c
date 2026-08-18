#include <sys/fcntl.h>
#include <sys/kd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>

int main (int argc, char **argv)
{
    int  fd;
    int  mode;
    fd = open ("/dev/tty0", O_RDONLY);
    if (fd == -1)
	fd = open ("/dev/vc/0", O_RDONLY);
    if (fd == -1)
	perror ("open");
    if (ioctl (fd, KDGETMODE, &mode) != 0)
	perror ("ioctl");
    exit(mode);
}

