#!/bin/sh

GPM=/usr/sbin/gpm
CFG=/etc/gpm.conf

cmdln=
if [ -f $CFG ]; then
  . $CFG
  if [ -n "$device" ]; then cmdln="$cmdln -m $device"; fi
  if [ -n "$type" ]; then cmdln="$cmdln -t $type"; fi
  if [ -n "$responsiveness" ]; then cmdln="$cmdln -r $responsiveness"; fi
  if [ -n "$sample_rate" ]; then cmdln="$cmdln -s $sample_rate"; fi
  # Yes, this /IS/ correct! There is no space after -R!!!!!!
  # I reserve the right to throw manpages at anyone who disagrees.
  if [ -n "$repeat_type" ] && [ "$repeat_type" != "none" ]; then
    cmdln="$cmdln -R$repeat_type"
  fi
  if [ -n "$append" ]; then cmdln="$cmdln $append"; fi
  # If both the second device and type are specified, use it.
  if [ -n "$device2" ] && [ -n "$type2" ] ; then
    cmdln="$cmdln -M -m $device2 -t $type2"
  fi
fi

$GPM $cmdln

# The following sleep call is solely needed, because gpm doesn't
# create its pid file as fast as the short-tempered systemd expects it
# to do.  *sigh*
sleep 1
