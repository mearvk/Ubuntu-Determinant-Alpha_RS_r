# Information retrieval/display functions for Debian maintainer scripts.
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


# Return success if package is installed. 
#
is_pkg_installed ()
{
    LC_ALL=C dpkg --status ${1} 2>/dev/null \
        | grep --quiet '^Status: install ok installed' 2>/dev/null
    return $?
}

# Return the package version.
#
get_pkg_version ()
{
    echo $(LC_ALL=C dpkg --status ${1} 2>/dev/null \
        | grep '^Version:' 2>/dev/null \
        | cut --fields=2 --delimiter=' ' 2>/dev/null)
}

# Return the {major,minor,tail} part of version. Assume version has the form:
#   major.minor.tail
# The || true handles missing/ill-formed argument cases.

version_major ()
{
    expr "${1}" \: '\([^.]\+\)' 2>/dev/null || true
}

version_minor ()
{
    expr "${1}" \: '[^.]\+\.\([^.]\+\)' 2>/dev/null || true
}

version_tail ()
{
    expr "${1}" \: '[^.]\+\.[^.]\+\.\([^.]\+\)' 2>/dev/null || true
}

# Display and record to syslog (if logger is available) an error message.
#
install_msg ()
{
    local package=${1}
    local priority=${2}

    # Remove package and priority from ARGV; then join all args to message.

    shift; shift

    local message="${package}:"
    local arg

    for arg; do
        message="${message} ${arg}"
    done

    # Output to stanard error and to syslog, if logger is available.

    >&2 echo "${message}"
    if is_exec logger; then
        logger -p syslog.${priority} -t "${package}" -- "${message}" || true
    fi
}

