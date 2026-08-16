#!/bin/sh

reboot_id=-1
json=no

while [ $# -gt 0 ]
do
    key="$1"
    case $key in
	-b|--boot)
	    reboot_id="$2"
	    shift
	    shift
	    ;;
	--json)
	    json=yes
	    shift
    esac
done

newboot_id=$((reboot_id+1))

reboot_start=$(journalctl -q -b $reboot_id -o short-unix --no-pager -u systemd-logind SHUTDOWN=reboot | sed 's/ .*//')
if [ -z "$reboot_start" ] ; then
    printf "No reboot marker was found, please reboot using:\n sudo dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.Reboot boolean:false\n" >&2
    exit 1
fi

journal_end=$(journalctl -q -b $reboot_id -o short-unix --no-pager -u systemd-journald -r -n 1 | sed 's/ .*//')
boot_start=$(journalctl -q -b $newboot_id -o short-unix -k | head -n 1 |  sed 's/ .*//')


tx_time=$(echo $journal_end - $reboot_start | bc)
void_time=$(echo $boot_start - $journal_end | bc)
reboot_time=$(echo $boot_start - $reboot_start | bc)

if [ "$json" = "yes" ]; then
    echo "{\"tx_time\": $tx_time, \"void_time\": $void_time, \"reboot_time\": $reboot_time}"
else
    echo reboot $reboot_time = transaction $tx_time + void $void_time
fi
