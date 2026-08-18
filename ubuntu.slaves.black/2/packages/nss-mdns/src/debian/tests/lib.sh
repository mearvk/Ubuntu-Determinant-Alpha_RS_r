#!/bin/sh

test_num=0
fail=0

# TAP output goes to fd 7, which is our original stdout
exec 7>&1
# Other stdout goes to our original stderr
exec >&2

host_getent=
host_suffix=

require () {
    if ! "$@"; then
        echo "1..0 # SKIP - command failed: $*" >&7
        exit 77
    fi
}

require_host_getent () {
    local arch="${1-}"

    if [ -z "${arch}" ]; then
        arch="${DEB_HOST_ARCH-}"
    fi

    if [ -z "${arch}" ]; then
        host_getent=getent
        return 0
    fi

    (
        cd "$AUTOPKGTEST_TMP"

        if ! apt-get -y update; then
            echo "1..0 # SKIP - apt not configured?" >&7
            exit 77
        fi

        if ! apt-get -y download "libc-bin:$arch"; then
            echo "1..0 # SKIP - cannot download libc-bin:$arch" >&7
            exit 77
        fi

        dpkg-deb -x libc-bin_*_"${arch}".deb libc-bin

    )

    host_getent="$AUTOPKGTEST_TMP/libc-bin/usr/bin/getent"
}

require_apt () {
    local arch="${1-}"

    if [ -n "${DEB_HOST_ARCH-}" ]; then
        host_suffix=":${DEB_HOST_ARCH}"
    fi

    if ! apt-get -y update; then
        echo "1..0 # SKIP - apt not configured?" >&7
        exit 77
    fi

    if [ -n "$arch" ]; then
        if ! apt-get -y install libc6:$arch; then
            echo "1..0 # SKIP - cannot install libc6:$arch" >&7
            exit 77
        fi
    else
        if ! apt-get -y install hello; then
            echo "1..0 # SKIP - apt not configured?" >&7
            exit 77
        fi
    fi
}

require_systemd () {
    if ! [ -d /run/systemd/system ]; then
        echo "1..0 # SKIP - init is not systemd, cannot use libnss-resolve" >&7
        exit 77
    fi
}

assert_succeeds () {
    assert_status 0 "$@"
}

assert_status () {
    local expected="$1"
    local e

    shift
    test_num=$(( $test_num + 1 ))

    echo "# $*"
    if "$@"; then
        if [ "x$expected" = x0 ]; then
            echo "ok $test_num - “$*”" >&7
        else
            echo "not ok $test_num - “$*” succeeded but should have failed" >&7
            fail=1
        fi
    else
        e="$?"
        if [ "x$expected" = "x$e" ] || [ "x$expected" = xfailure ]; then
            echo "ok $test_num - “$*” failed with status $e as expected" >&7
        else
            echo "not ok $test_num - “$*” expected status $expected, got $e" >&7
            fail=1
        fi
    fi
}

assert_output () {
    local expected="$1"
    shift
    local really

    test_num=$(( $test_num + 1 ))
    echo "# $*"

    if really="$("$@")"; then
        if [ "x$expected" = "x$really" ]; then
            echo "ok $test_num - “$*” returned “$really” as expected" >&7
        else
            echo "not ok $test_num - expected “$*” to output “$*”, got “$really”" >&7
            fail=1
        fi
    else
        e="$?"
        echo "not ok $test_num - “$*” failed with exit status $e" >&7
        fail=1
    fi
}

assert_hosts () {
    local expected="$1"
    local really="$(perl -ne 'print if /^hosts:/' /etc/nsswitch.conf)"
    test_num=$(( $test_num + 1 ))

    if [ "x$expected" = "x$really" ]; then
        echo "ok $test_num - “$really” in nsswitch.conf as expected" >&7
    else
        echo "not ok $test_num - expected “$expected” in nsswitch.conf, got “$really”" >&7
        fail=1
    fi
}

get_resolve_rune () {
    perl -ne 'print $1 if /^hosts:.*\s(resolve(?:\s+\[!?[A-Z]+=[a-z]+\])?)/' /etc/nsswitch.conf
}

ok () {
    test_num=$(( $test_num + 1 ))
    echo "ok $test_num - $*" >&7
}

skip_to_the_end () {
    test_num=$(( $test_num + 1 ))
    echo "not ok $test_num # SKIP $*" >&7
    finish
}

finish () {
    echo "1..$test_num" >&7
    exit "$fail"
}

# vim:set sw=4 sts=4 et:
