What follows is a simple scenario:

    SCENARIO A simple yarn document
    WHEN I run "date -d 2019-01-01 +%Y-%m-%d"
    THEN the output should be "2019-01-01"

And below is the implementation:

    IMPLEMENTS WHEN I run "(.*)"
    ${MATCH_1} > $DATADIR/stdout

    IMPLEMENTS THEN the output should be "(.*)"
    test "${MATCH_1}" = "$(cat $DATADIR/stdout)"
