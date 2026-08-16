# bash-completion/dcut.bash
# Programmable Bash command completion for ‘dcut’ command.
# See the Bash manual “Programmable Completion” section.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

_have dcut &&
_dcut () {
    COMPREPLY=()

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local options=(
            --host
            -O --output
            -P --passive
            -U --upload
            -c --config
            -d --debug
            -h --help
            -i --input
            -k --keyid
            -m --maintaineraddress
            -s --simulate
            -v --version
            )

    local config_files=(
            "$HOME/.dput.cf"
            "/etc/dput.cf"
            )
    local hosts=$( {
            grep --no-filename "^\[.*\]" "${config_files[@]}" \
                2> /dev/null \
                | tr --delete '[]' || /bin/true
            } | grep --invert-match '^DEFAULT$' | sort --unique )

    local queue_commands=(
            cancel
            reschedule
            rm
            )

    case "$prev" in
        -c|--config)
            COMPREPLY=( $( compgen -G "${cur}*" ) )
            compopt -o filenames
            compopt -o plusdirs
            ;;
        -k|--keyid)
            # FIXME: gathering the secret keys can typically take
            # several seconds by this method. Is there a faster way to
            # reliably present the current user's secret key IDs?
            local keyids=( $(
                    gpg --list-secret-keys --with-colons \
                        2> /dev/null \
                        | grep '^sec' | cut --delimiter ':' --fields 5 \
                        | sort --unique
                    ) )
            COMPREPLY=( $( compgen -W "${keyids[*]}" -- "$cur" ) )
            ;;
        -i|--input)
            COMPREPLY=( $( compgen -G "${cur}*.changes" ) )
            compopt -o filenames
            compopt -o plusdirs
            ;;
        -U|--upload|-O|--output)
            COMPREPLY=( $( compgen -G "${cur}*.commands" ) )
            compopt -o filenames
            compopt -o plusdirs
            ;;
        --host)
            COMPREPLY=( $( compgen -W "$hosts" -- "$cur" ) )
            ;;
        ',')
            COMPREPLY=( $( compgen -W "${queue_commands[*]}" -- "$cur" ) )
            ;;
        *)
            COMPREPLY=( $(
                    compgen -W "$hosts" -- "$cur"
                    compgen -W "${queue_commands[*]}" -- "$cur"
                    compgen -W "${options[*]}" -- "$cur"
                    ) )
            ;;
    esac

    return 0

} && complete -F _dcut dcut


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
