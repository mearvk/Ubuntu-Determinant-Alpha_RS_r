# File operation functions for Debian maintainer scripts.
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


# Test executability (implies existence) of a binary in the system's path.
# ARGS:
# $1=binary_basename
#
is_exec()
{
    # First ensure we are not passed an empty argument,
    # because test -x "" returns success.

    if [ "X${1}" = "X" ]; then
        return 2
    fi

    # Then look for the binary location. If not found,
    # return error, because test -x "" returns success.

    local binary=$(which "${1}" 2>/dev/null)

    if [ "X${binary}" = "X" ]; then
        return 1
    fi

    # If the binary is found, return its executable status.

    test -x "${binary}" 2>/dev/null
}


# Ucf-interfacing of generated conffiles helpers.
# Fall-through behaviour, when ucf is not available:
# -- install our version of the conffile
# -- if old conffile exists and is a file, rename old conffile to 
#    <conffile>.ucf-old
# -- if old conffile or <conffile>.ucf-old exists and is a directory,
#    fail. 

# Copy a conffile to the filesystem and add it to the ucf and ucfr databases.
# ARGS:
# $1=package $2=source $3=destination
#
cp_ucfregister_file ()
{
    local package="${1}"
    local srcfile="${2}"
    local conffile="${3}"

    if is_exec ucf; then
        ucf --debconf-ok --three-way "${srcfile}" "${conffile}"
    else
        # If conffile is a symlink, our move-to-old-then-copy strategy
        # would make the symlink a normal file; account for this.

        if [ -h "${conffile}" ]; then

            local realconf=$(readlink --no-newline \
                --canonicalize "${conffile}" || :)

            if [ "X${realconf}" = "X" ]; then
                >&2 echo "${conffile} is a broken symlink; replacing it"
                rm --force "${conffile}"
            else
                conffile="${realconf}"
            fi
        fi

        # Now, after resolving symlinks, check for existence and being a file.

        if [ -e "${conffile}" ]; then
            if [ -d "${conffile}" ] || [ -d "${conffile}.ucf-old" ]; then
                >&2 echo "${conffile} is a directory; aborting"
                return 10
            fi
            # We do not use the backup option, because in such a case
            # we would being accumulating backups on each upgrade.

            mv --force "${conffile}" "${conffile}.ucf-old"
        fi
        cp --force --preserve "${srcfile}" "${conffile}"
    fi

    if is_exec ucfr; then
        ucfr "${package}" "${conffile}"
    fi
}

# Move a (temporary, ie dynamically created) conffile to the filesystem
# and add it to the ucf and ucfr databases.
# 
# $1=package $2=source $3=destination
#
mv_ucfregister_file ()
{
    cp_ucfregister_file "${1}" "${2}" ${3}
    rm --force "${2}"
}

# Remove a conffile from the filesystem and the ucf and ucfr databases.
# ARGS: 
# $1=package $2=conffile
#
ucf_unregister_file ()
{
    local package="${1}"
    local conffile="${2}"
    local ext

    # the '' value is to delete the file itself
    for ext in '' '~' '%' .bak .ucf-new .ucf-old .ucf-dist; do
        rm -f "${conffile}${ext}" || true
    done
    if is_exec ucf; then
        ucf --purge "${conffile}"
    fi
    if is_exec ucfr; then
        ucfr --purge "${package}" "${conffile}"
    fi
}

