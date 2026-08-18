#! /bin/sh

for d in debian/tmp debian/tmp-ncurses; do
    LIB="$(echo "$PWD/$d"/usr/lib/*)"
    INC="$PWD/$d/usr/include"

    gcc debian/tests/test.c -Wall -L"$LIB" -I"$INC" -lcunit -o "$ADTTMP/test"
    LD_LIBRARY_PATH="$LIB" "$ADTTMP/test"
done
