#!/bin/sh

test_num=0
fail=0

# TAP output goes to fd 7, which is our original stdout
exec 7>&1
# Other stdout goes to our original stderr
exec >&2

require () {
    if ! "$@"; then
        echo "1..0 # SKIP - command failed: $*" >&7
        exit 77
    fi
}

require_apt_stretch () {
    mirror="$(perl -ne 'if (m{^deb\s+(https?://[-\w.:]+)/debian/?\s}) { print "$1\n"; exit; }' /etc/apt/sources.list /etc/apt/sources.list.d/*)"
    if [ -n "$mirror" ]; then
        echo >> /etc/apt/sources.list
        echo "deb $mirror/debian stretch main" >> /etc/apt/sources.list
    else
        echo "1..0 # SKIP - unable to guess how to set up an apt source for stretch" >&7
        exit 77
    fi

    require_apt
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
