#! /bin/bash
#Copyright (C) 2022 Canonical, Ltd.
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License as
#published by the Free Software Foundation, version 2 of the
#License.

#=NAME sysv_mq
#=DESCRIPTION
# This test verifies if mediation of sysv message queues is working
#=END

pwd=`dirname $0`
pwd=`cd $pwd ; /bin/pwd`

bin=$pwd

. $bin/prologue.inc

requires_kernel_features ipc/sysv_mqueue
requires_parser_support "mqueue,"

settest sysv_mq_rcv

sender="$bin/sysv_mq_snd"
receiver="$bin/sysv_mq_rcv"
qkey=123
qkey2=124
semaphore=456

user="foo"
adduser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --no-create-home --disabled-password $user >/dev/null
echo "$user:password" | sudo chpasswd
userid=$(id -u $user)

# workaround to not have to set o+x
chmod 6755 $receiver
setcap cap_dac_read_search+pie $receiver

cleanup()
{
    ipcrm --queue-key $qkey >/dev/null 2>&1
    ipcrm --queue-key $qkey2 >/dev/null 2>&1
    ipcrm --semaphore-key $semaphore >/dev/null 2>&1
    deluser foo >/dev/null
}
do_onexit="cleanup"

do_test()
{
    local desc="SYSV MQUEUE ($1)"
    shift
    runchecktest "$desc" "$@"
}

do_tests()
{
    prefix=$1
    expect_send=$2

    all_args=("$@")
    rest_args=("${all_args[@]:2}")

    do_test "$prefix" "$expect_send" -c $sender -k $qkey -s $semaphore "${rest_args[@]}"
}

for username in "root" "$userid" ; do
    if [ $username == "root" ] ; then
	usercmd=""
    else
	usercmd="-u $userid"
    fi

    do_tests "unconfined $username" pass $usercmd

    # No mqueue perms
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "$sender:px" -- image=$sender
    do_tests "confined $username - no perms" fail $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "deny:mqueue" "$sender:px" -- image=$sender "deny mqueue"
    do_tests "confined $username - deny perms" fail $usercmd

    # generic mqueue
    # 2 Potential failures caused by missing other x permission in path
    # to tests. Usually on the user home dir as it is now default to
    # create a user without that
    # * if you seen a capability dac_read_search denied failure from
    #   apparmor when doing "root" username tests
    # * if doing the $userid set of tests and you see
    #   Permission denied in the test output
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue" "$sender:px" -- image=$sender "mqueue"
    do_tests "confined $username - mqueue" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:type=sysv" "$sender:px" -- image=$sender "mqueue:type=sysv"
    do_tests "confined $username - mqueue type=sysv" pass $usercmd

    # queue name
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:$qkey" "$sender:px" -- image=$sender "mqueue:$qkey"
    do_tests "confined $username - mqueue /name 1" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue" "$sender:px" -- image=$sender "mqueue:$qkey"
    do_tests "confined $username - mqueue /name 2" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:$qkey" "$sender:px" -- image=$sender "mqueue"
    do_tests "confined $username - mqueue /name 3" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:$qkey" "$sender:px" -- image=$sender "mqueue:$qkey2"
    do_tests "confined $username - mqueue /name 4" fail $usercmd -t 1


    # specific permissions
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,delete,getattr,setattr)" "$sender:px" -- image=$sender "mqueue:(open,write)"
    do_tests "confined $username - specific 1" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(read,delete,getattr,setattr)" "$sender:px" -- image=$sender "mqueue:(open,write)"
    do_tests "confined $username - specific 2" fail $usercmd -t 1

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,delete,getattr,setattr)" "$sender:px" -- image=$sender "mqueue:(open,write)"
    do_tests "confined $username - specific 3" fail $usercmd -t 1

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,getattr,setattr)" "$sender:px" -- image=$sender "mqueue:(open,write)"
    do_tests "confined $username - specific 4" fail $usercmd -t 1
    # we need to remove queue since the previous test didn't
    ipcrm --queue-key $qkey >/dev/null 2>&1

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,delete,setattr)" "$sender:px" -- image=$sender "mqueue:(open,write)"
    do_tests "confined $username - specific 5" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,delete,getattr)" "$sender:px" -- image=$sender "mqueue:(open,write)"
    do_tests "confined $username - specific 6" pass $usercmd

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,delete,getattr,setattr)" "$sender:px" -- image=$sender "mqueue:(open,read)"
    do_tests "confined $username - specific 7" fail $usercmd -t 1

    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,delete,getattr,setattr)" "$sender:px" -- image=$sender "mqueue:write"
    do_tests "confined $username - specific 7" fail $usercmd -t 1


    # unconfined receiver
    genprofile image=$sender "mqueue"
    do_tests "confined sender $username - unconfined receiver" pass $usercmd


    # unconfined sender
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue" "$sender:ux"
    do_tests "confined receiver $username - unconfined sender" pass $usercmd


    # queue label
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:label=$receiver" "$sender:px" -- image=$sender "mqueue:label=$receiver"
    do_tests "confined $username - mqueue label 1" xpass $usercmd


    # queue name and label
    genprofile "cap:sys_resource:deny" "cap:setuid" "cap:fowner" "mqueue:(create,read,delete):type=sysv:label=$receiver:$qkey" "$sender:px" -- image=$sender "mqueue:(open,write):type=sysv:label=$receiver:$qkey"
    do_tests "confined $username - mqueue label 2" xpass $usercmd


    # ensure we are cleaned up for next pass
    removeprofile
done


# confined root with cap ??override


# confined root without cap ??override


# deliver message by mtype (posix lacks this)
