#ifndef XMC_BUILD_POSIX_COMPAT_H
#define XMC_BUILD_POSIX_COMPAT_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 200809L
#endif

#include <limits.h>
#include <strings.h>

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

#endif
