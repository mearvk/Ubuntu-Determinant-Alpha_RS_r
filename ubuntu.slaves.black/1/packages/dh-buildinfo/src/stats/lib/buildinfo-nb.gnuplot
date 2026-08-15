#!/usr/bin/env gnuplot

set timefmt "%Y-%m-%d"

set xdata time
set format x "%m/%d"

set data style linespoints

set term postscript eps color
set output "public_html/buildinfo/npkg.eps"

plot "stats/buildinfo" using 1:2
