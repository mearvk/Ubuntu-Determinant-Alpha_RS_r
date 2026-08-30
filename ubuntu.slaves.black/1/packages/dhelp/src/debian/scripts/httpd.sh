# httpd configuration enable/disable functions for Debian maintainer scripts.
# Copyright (C) 2012 Georgios M. Zarkadas <gz@member.fsf.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA  02111-1307  USA.
#
# This file is intended to be sourced by maintainer scripts.

# REQUIRES: info.sh files.sh

# (internal) message template functions

# ARGS:
# $1=package $2=caller
#
_httpdmsg_nocfa()
{
    echo "${1} error: invalid action '${2}' supplied as argument"
}

# ARGS:
# $1=caller_with_args
#
_httpdmsg_nopkg()
{
    echo "${1} error: package name was not supplied as argument"
}

# ARGS:
# $1=package $2=httpd_name $3={enable,disable}
#
_httpdmsg_check()
{
    local text=""
    if [ "${3}" = "disable" ]; then
        text="de"
    fi
    echo "check the status of the ${2} web server and whether" \
        "${1} configuration for ${2} has been ${text}activated."
}

# ARGS:
# $1=package $2=httpd_name $3={enable,disable}
#
_httpdmsg_noact()
{
    local text=""
    if [ "${3}" = "disable" ]; then
        text="de"
    fi
    echo "${1} configuration for ${2} has not been ${text}activated."
}

# Return error if action is not (en/dis)able or package is empty.
# ARGS:
# $1=action $2=package $3=caller
#
_check_action_and_package()
{
    local action=${1}
    local package=${2}
    local caller=${3}

    local nopkg="false"

    if [ "X${package}" = "X" ]; then
        package=unknown
        nopkg="true"
    fi

    case ${action} in
    enable|disable)
        ;;
    *)
        install_msg ${package} err $(_hhtpdmsg_nocfa ${package} ${caller})
        return 10
        ;;
    esac

    if [ "${nopkg}" = "true" ]; then
        install_msg ${package} err $(_httpdmsg_nopkg "${caller} ${action}")
        return 11
    fi

    return 0
}

# Return {new,old,unknown} when, respectively, the apache2 package uses
# new / old packaging or it is not installed in the system.
# ARGS: none
#
apache2_packaging ()
{
    if ! is_pkg_installed 'apache2'; then
        echo 'unknown'
	return
    fi

    local aversion=$(get_pkg_version 'apache2')
    local amajor=$(version_major "${aversion}")
    local aminor=$(version_minor "${aversion}")

    local packaging="old"
    case ${amajor} in
    2)
        if [ ${aminor} -ge 4 ]; then
            packaging="new"
        fi
        ;;
    *)
        if [ ${amajor} -gt 2]; then
            packaging="new"
        fi
        ;;
    esac
    echo ${packaging}
}

# Try to (en/dis)able an apache2 configuration snippet.
# Return error if (en/dis)abling tried and failed; caller *must* check status.
# ARGS:
# $1=maintscript-action (configure,abort-upgrade)
# $2={enable,disable} $3=package [$4=name_of_snippet_if_different_from_package]
#
try_chconf_apache2 ()
{
    local maintscript_action=${1}
    local action=${2}
    local package=${3}
    local confname=${4}

    local ret=0
    _check_action_and_package ${action} ${package} "try_chconf_apache2" \
        && ret=$? || ret=$?
    if [ ${ret} -ne 0 ]; then
        return ${ret}
    fi

    local confaction
    if [ "${action}" = "enable" ]; then
        confaction=enconf
    else
        confaction=disconf
    fi

    if [ "X${confname}" = "X" ]; then
        confname=${package}
    fi

    case $(apache2_packaging) in
    new)
        # The apache2_invoke function also reloads the web server
        # if it is running.

        local ahelper=/usr/share/apache2/apache2-maintscript-helper

        if [ -e $ahelper ] ; then
            . $ahelper $maintscript_action
            apache2_invoke ${confaction} ${confname}.conf && ret=$? || ret=$?
            if [ ${ret} -ne 0 ]; then
                install_msg ${package} warning \
                    "apache2_invoke returned an error;" \
                    $(_httpdmsg_check ${package} apache2 ${action})
            fi
            return ${ret}
        else
            install_msg ${package} warning \
                "apache2-maintscript-helper not found;" \
                $(_httpdmsg_noact ${package} apache2 ${action})
            return 1
        fi
        ;;
    old)
        # The apache2 init script uses apache2ctl configtest internally
        # and also checks that the server is indeed running; thus there
        # is no need to repeat these tests here.

        invoke-rc.d apache2 reload && ret=$? || ret=$?
        if [ ${ret} -ne 0 ]; then
            install_msg ${package} warning \
                "invoke-rc.d apache2 returned an error;" \
                $(_httpdmsg_check ${package} apache2 ${action})
        fi
        return ${ret}
        ;;
    *)  # can only be unknown in which case apache2 is not installed; return
        ;;
    esac
}

# Try to (en/dis)able a lighttpd configuration snippet.
# Return error if (en/dis)abling tried and failed; caller *must* check status.
# ARGS:
# $1=maintscript-action (configure,abort-upgrade), not used
# $2={enable,disable} $3=package [$4=name_of_snippet_if_different_from_package]
#
try_chconf_lighttpd ()
{
    local maintscript_action=${1}
    local action=${2}
    local package=${3}
    local snippetname=${4}

    local ret=0
    _check_action_and_package ${action} ${package} "try_chconf_lighttpd" \
        && ret=$? || ret=$?
    if [ ${ret} -ne 0 ]; then
        return ${ret}
    fi

    local confaction
    if [ "${action}" = "enable" ]; then
        confaction=lighty-enable-mod
    else
        confaction=lighty-disable-mod
    fi

    if ! is_pkg_installed 'lighttpd'; then
        return 0
    fi

    local confname=${package}

    if [ "X${snippetname}" != "X" ]; then
        confname=${snippetname}
    fi

    # lighty-xxx-mod will return 2 if no action is needed; workaround this.

    if is_exec ${confaction}; then
        ${confaction} ${confname} && ret=$? || ret=$?
        if [ $ret -eq 1 ]; then
            install_msg ${package} warning \
                "${confaction} returned an error;" \
                $(_httpdmsg_noact ${package} lighttpd ${action})
            return 1
        fi
    else
        install_msg ${package} warning \
            "${confaction} not found;" \
            $(_httpdmsg_noact ${package} lighttpd ${action})
        return 2
    fi

    # Try to reload the web server configuration.

    invoke-rc.d lighttpd reload && ret=$? || ret=$?
    if [ ${ret} -ne 0 ]; then
        install_msg ${package} warning \
            "invoke-rc.d lighttpd returned an error;" \
            $(_httpdmsg_check ${package} lighttpd ${action})
    fi
    return ${ret}
}

