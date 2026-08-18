include(CheckIncludeFile)
include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckTypeSize)
include(CheckStructHasMember)
include(CheckPrototypeDefinition)
include(TestBigEndian)
include(CheckCSourceRuns)

set(PACKAGE ${PROJECT_NAME})
set(VERSION ${PROJECT_VERSION})
set(DATADIR ${DATA_INSTALL_DIR})
set(LIBDIR ${LIB_INSTALL_DIR})
set(PLUGINDIR "${PLUGIN_INSTALL_DIR}-${LIBRARY_SOVERSION}")
set(SYSCONFDIR ${SYSCONF_INSTALL_DIR})

set(BINARYDIR ${CMAKE_BINARY_DIR})
set(SOURCEDIR ${CMAKE_SOURCE_DIR})

function(COMPILER_DUMPVERSION _OUTPUT_VERSION)
    # Remove whitespaces from the argument.
    # This is needed for CC="ccache gcc" cmake ..
    string(REPLACE " " "" _C_COMPILER_ARG "${CMAKE_C_COMPILER_ARG1}")

    execute_process(
        COMMAND
            ${CMAKE_C_COMPILER} ${_C_COMPILER_ARG} -dumpversion
        OUTPUT_VARIABLE _COMPILER_VERSION
    )

    string(REGEX REPLACE "([0-9])\\.([0-9])(\\.[0-9])?" "\\1\\2"
           _COMPILER_VERSION "${_COMPILER_VERSION}")

    set(${_OUTPUT_VERSION} ${_COMPILER_VERSION} PARENT_SCOPE)
endfunction()

if(CMAKE_COMPILER_IS_GNUCC AND NOT MINGW AND NOT OS2)
    compiler_dumpversion(GNUCC_VERSION)
    if (NOT GNUCC_VERSION EQUAL 34)
        set(CMAKE_REQUIRED_FLAGS "-fvisibility=hidden")
        check_c_source_compiles(
"void __attribute__((visibility(\"default\"))) test() {}
int main(void){ return 0; }
" WITH_VISIBILITY_HIDDEN)
        set(CMAKE_REQUIRED_FLAGS "")
    endif (NOT GNUCC_VERSION EQUAL 34)
endif(CMAKE_COMPILER_IS_GNUCC AND NOT MINGW AND NOT OS2)

# HEADERS
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(pwd.h HAVE_PWD_H)
check_include_file(shadow.h HAVE_SHADOW_H)
check_include_file(grp.h HAVE_GRP_H)
check_include_file(nss.h HAVE_NSS_H)
check_include_file(nss_common.h HAVE_NSS_COMMON_H)

# FUNCTIONS
check_function_exists(strncpy HAVE_STRNCPY)
check_function_exists(vsnprintf HAVE_VSNPRINTF)
check_function_exists(snprintf HAVE_SNPRINTF)

check_function_exists(getpwnam_r HAVE_GETPWNAM_R)
check_function_exists(getpwuid_r HAVE_GETPWUID_R)
check_function_exists(getpwent_r HAVE_GETPWENT_R)

check_function_exists(setspent HAVE_SETSPENT)
check_function_exists(getspnam HAVE_GETSPNAM)

check_function_exists(getgrnam_r HAVE_GETGRNAM_R)
check_function_exists(getgrgid_r HAVE_GETGRGID_R)
check_function_exists(getgrent_r HAVE_GETGRENT_R)

check_function_exists(getgrouplist HAVE_GETGROUPLIST)

check_function_exists(gethostbyaddr_r HAVE_GETHOSTBYADDR_R)
check_function_exists(gethostbyname_r HAVE_GETHOSTBYNAME_R)

check_function_exists(gethostbyname2 HAVE_GETHOSTBYNAME2)
check_function_exists(gethostbyname2_r HAVE_GETHOSTBYNAME2_R)

check_function_exists(getprogname HAVE_GETPROGNAME)
check_function_exists(getexecname HAVE_GETEXECNAME)

if (WIN32)
    check_function_exists(_vsnprintf_s HAVE__VSNPRINTF_S)
    check_function_exists(_vsnprintf HAVE__VSNPRINTF)
    check_function_exists(_snprintf HAVE__SNPRINTF)
    check_function_exists(_snprintf_s HAVE__SNPRINTF_S)
endif (WIN32)

if (UNIX)
    if (NOT LINUX)
        # libsocket (Solaris)
        check_library_exists(socket getaddrinfo "" HAVE_LIBSOCKET)
        if (HAVE_LIBSOCKET)
            list(APPEND _REQUIRED_LIBRARIES socket)
        endif (HAVE_LIBSOCKET)

        # libnsl/inet_pton (Solaris)
        check_library_exists(nsl inet_pton "" HAVE_LIBNSL)
        if (HAVE_LIBNSL)
            list(APPEND _REQUIRED_LIBRARIES nsl)
        endif (HAVE_LIBNSL)
    endif (NOT LINUX)

    check_function_exists(getaddrinfo HAVE_GETADDRINFO)
endif (UNIX)

if (SOLARIS)
    check_function_exists(__posix_getpwnam_r HAVE___POSIX_GETPWNAM_R)
    check_function_exists(__posix_getpwuid_r HAVE___POSIX_GETPWUID_R)

    check_function_exists(__posix_getgrgid_r HAVE___POSIX_GETGRGID_R)
    check_function_exists(__posix_getgrnam_r HAVE___POSIX_GETGRNAM_R)
endif (SOLARIS)

check_function_exists(asprintf HAVE_ASPRINTF)
if (UNIX AND HAVE_ASPRINTF)
    add_definitions(-D_GNU_SOURCE)
endif (UNIX AND HAVE_ASPRINTF)

set(CMAKE_REQUIRED_DEFINITIONS -D_POSIX_PTHREAD_SEMANTICS)
check_prototype_definition(getpwent_r
    "struct passwd *getpwent_r(struct passwd *src, char *buf, int buflen)"
    "NULL"
    "unistd.h;pwd.h"
    HAVE_SOLARIS_GETPWENT_R)

check_prototype_definition(getpwnam_r
    "int getpwnam_r(const char *name, struct passwd *pwd, char *buf, int buflen, struct passwd **ppwd)"
    "-1"
    "unistd.h;pwd.h"
    HAVE_SOLARIS_GETPWNAM_R)

check_prototype_definition(getpwuid_r
    "int getpwuid_r(uid_t uid, struct passwd *pwd, char *buf, int buflen, struct passwd **ppwd)"
    "-1"
    "unistd.h;pwd.h"
    HAVE_SOLARIS_GETPWUID_R)

check_prototype_definition(getgrent_r
    "struct group *getgrent_r(struct group *src, char *buf, int buflen)"
    "NULL"
    "unistd.h;grp.h"
    HAVE_SOLARIS_GETGRENT_R)

check_prototype_definition(getgrnam_r
    "int getgrnam_r(const char *name, struct group *grp, char *buf, int buflen, struct group **pgrp)"
    "-1"
    "unistd.h;grp.h"
    HAVE_SOLARIS_GETGRNAM_R)

check_prototype_definition(getgrgid_r
    "int getgrgid_r(gid_t gid, struct group *grp, char *buf, int buflen, struct group **pgrp)"
    "-1"
    "unistd.h;grp.h"
    HAVE_SOLARIS_GETGRGID_R)

check_prototype_definition(sethostent
    "int sethostent(int stayopen)"
    "-1"
    "unistd.h;netdb.h"
    HAVE_SOLARIS_SETHOSTENT)

check_prototype_definition(endhostent
    "int endhostent(void)"
    "-1"
    "unistd.h;netdb.h"
    HAVE_SOLARIS_ENDHOSTENT)

check_prototype_definition(gethostname
    "int gethostname(char *name, int len)"
    "-1"
    "unistd.h;netdb.h"
    HAVE_SOLARIS_GETHOSTNAME)
set(CMAKE_REQUIRED_DEFINITIONS)

check_prototype_definition(setgrent
    "int setgrent(void)"
    "-1"
    "unistd.h;grp.h"
    HAVE_BSD_SETGRENT)

check_prototype_definition(getnameinfo
    "int getnameinfo (const struct sockaddr *sa, socklen_t salen, char *host, socklen_t __hostlen, char *serv, socklen_t servlen, int flags)"
    "-1"
    "unistd.h;netdb.h"
    HAVE_LINUX_GETNAMEINFO)

check_prototype_definition(getnameinfo
    "int getnameinfo (const struct sockaddr *sa, socklen_t salen, char *host, socklen_t __hostlen, char *serv, socklen_t servlen, unsigned int flags)"
    "-1"
    "unistd.h;netdb.h"
    HAVE_LINUX_GETNAMEINFO_UNSIGNED)

# STRUCT MEMBERS
check_struct_has_member("struct sockaddr" sa_len "sys/socket.h netinet/in.h" HAVE_STRUCT_SOCKADDR_SA_LEN)
check_struct_has_member("struct passwd" pw_class "pwd.h" HAVE_STRUCT_PASSWD_PW_CLASS)
check_struct_has_member("struct passwd" pw_change "pwd.h" HAVE_STRUCT_PASSWD_PW_CHANGE)
check_struct_has_member("struct passwd" pw_expire "pwd.h" HAVE_STRUCT_PASSWD_PW_EXPIRE)

# IPV6
check_c_source_compiles("
    #include <stdlib.h>
    #include <sys/socket.h>
    #include <netdb.h>
    #include <netinet/in.h>
    #include <net/if.h>

int main(void) {
    struct sockaddr_storage sa_store;
    struct addrinfo *ai = NULL;
    struct in6_addr in6addr;
    int idx = if_nametoindex(\"iface1\");
    int s = socket(AF_INET6, SOCK_STREAM, 0);
    int ret = getaddrinfo(NULL, NULL, NULL, &ai);
    if (ret != 0) {
        const char *es = gai_strerror(ret);
    }

    freeaddrinfo(ai);
    {
        int val = 1;
#ifdef HAVE_LINUX_IPV6_V6ONLY_26
#define IPV6_V6ONLY 26
#endif
        ret = setsockopt(s, IPPROTO_IPV6, IPV6_V6ONLY,
                         (const void *)&val, sizeof(val));
    }

    return 0;
}" HAVE_IPV6)

check_c_source_compiles("
void log_fn(const char *format, ...) __attribute__ ((format (printf, 1, 2)));

int main(void) {
    return 0;
}" HAVE_ATTRIBUTE_PRINTF_FORMAT)

check_c_source_compiles("
void test_constructor_attribute(void) __attribute__ ((constructor));

void test_constructor_attribute(void)
{
     return;
}

int main(void) {
     return 0;
}" HAVE_CONSTRUCTOR_ATTRIBUTE)

check_c_source_compiles("
void test_destructor_attribute(void) __attribute__ ((destructor));

void test_destructor_attribute(void)
{
    return;
}

int main(void) {
    return 0;
}" HAVE_DESTRUCTOR_ATTRIBUTE)

find_library(DLFCN_LIBRARY dl)
if (DLFCN_LIBRARY)
    list(APPEND _REQUIRED_LIBRARIES ${DLFCN_LIBRARY})
else()
    check_function_exists(dlopen HAVE_DLOPEN)
    if (NOT HAVE_DLOPEN)
        message(FATAL_ERROR "FATAL: No dlopen() function detected")
    endif()
endif()

# ENDIAN
if (NOT WIN32)
    test_big_endian(WORDS_BIGENDIAN)
endif (NOT WIN32)

if (NOT CMAKE_CROSSCOMPILING)
    # check whether getaddrinfo() returns "node" in "ai_canonname" for IP-addresses
    check_c_source_runs("#include <stddef.h>
    #include <string.h>
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <netdb.h>

    int main(void) {
        struct addrinfo hints;
        struct addrinfo *res = NULL;

        memset(&hints, 0, sizeof(struct addrinfo));
        hints.ai_family = AF_INET;
        hints.ai_socktype = SOCK_STREAM;
        hints.ai_flags = AI_NUMERICHOST | AI_NUMERICSERV;

        if (getaddrinfo(\"0.0.0.0\", \"389\", &hints, &res) != 0) {
            return 2;
        }

        if (res == NULL) {
            return 3;
        }

        return strncmp(res->ai_canonname, \"0.0.0.0\", sizeof(\"0.0.0.0\")) != 0;
    }" HAVE_GETADDRINFO_SETS_CANONNAME_FOR_IPADDRESSES)

    # Check whether getaddrinfo() returns EAI_SERVICE when the requested
    # service is not available for the requested socket type.
    check_c_source_runs("#include <stddef.h>
    #include <string.h>
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <netdb.h>

    int main(void) {
        struct addrinfo hints;
        struct addrinfo *res = NULL;
        int rc;

        memset(&hints, 0, sizeof(struct addrinfo));
        hints.ai_family = AF_UNSPEC;    /* Allow IPv4 or IPv6 */
        hints.ai_socktype = SOCK_DGRAM; /* Datagram socket */
        hints.ai_flags = AI_PASSIVE | AI_NUMERICSERV;    /* For wildcard IP address */
        hints.ai_protocol = 0;          /* Any protocol */
        hints.ai_canonname = NULL;

        rc = getaddrinfo(NULL, \"echo\", &hints, &res);
        return rc != EAI_SERVICE;
    }" HAVE_GETADDRINFO_USES_EAI_SERVICE)

    # Check for non-NULL gethostent()
    check_c_source_runs("#include <stddef.h>
    #include <netdb.h>
    int main(void) {
        struct hostent *hostent = NULL;
        sethostent(0);
        hostent = gethostent();
        endhostent();
        return hostent == NULL;
    }" HAVE_NONNULL_GETHOSTENT)
endif (NOT CMAKE_CROSSCOMPILING)

set(NWRAP_REQUIRED_LIBRARIES ${_REQUIRED_LIBRARIES} CACHE INTERNAL "nss_wrapper required system libraries")
