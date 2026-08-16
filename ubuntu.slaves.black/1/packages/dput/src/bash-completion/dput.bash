# bash-completion/dput.bash
# Programmable Bash command completion for ‘dput’ command.
# See the Bash manual “Programmable Completion” section.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

_have dput &&
_dput () {
    COMPREPLY=()

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    local options=(
            -D --dinstall
            -H --host-list
            -P --passive
            -U --no-upload-log
            -V --check-version
            -c --config
            -d --debug
            -e --delayed
            -f --force
            -h --help
            -l --lintian
            -o --check-only
            -p --print
            -s --simulate
            -u --unchecked
            -v --version
            )

    local config_files=(
            "$HOME/.dput.cf"
            "/etc/dput.cf"
            )
    local hosts=$( {
            grep --no-filename "^\[.*\]" "${config_files[@]}" \
                2> /dev/null \
                | tr --delete [] || /bin/true
            } | grep --invert-match '^DEFAULT$' | sort --unique )

    case "$prev" in
        -e|--delayed)
            local delayed_values=( {0..15} )
            COMPREPLY=( $( compgen -W "${delayed_values[*]}" -- "$cur" ) )
            ;;
        -c|--config)
            COMPREPLY=( $( compgen -G "${cur}*" ) )
            compopt -o filenames
            compopt -o plusdirs
            ;;
        *)
            COMPREPLY=( $(
                    compgen -G "${cur}*.changes"
                    compgen -G "${cur}*.dsc"
                    compgen -W "$hosts" -- "$cur"
                    compgen -W "${options[*]}" -- "$cur"
                    ) )
            compopt -o filenames
            compopt -o plusdirs
            ;;
    esac

    return 0

} && complete -F _dput dput


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2002 Roland Mas <lolando@debian.org>
#
# This is free software: you may copy, modify, and/or distribute this work
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 3 of that license or any later version.
# No warranty expressed or implied. See the file ‘LICENSE.GPL-3’ for details.

# Local variables:
# coding: utf-8
# mode: sh
# End:
# vim: fileencoding=utf-8 filetype=sh :
