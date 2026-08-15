#!/usr/bin/env gnuplot

set timefmt "%Y-%m-%d"

set xdata time
set format x "%m/%d"

set data style linespoints

set term postscript eps color
set output "public_html/buildinfo/nfiles.eps"

plot "stats/buildinfo-nb-files" using 1:2
