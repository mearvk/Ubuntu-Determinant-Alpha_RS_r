# Shell functions library used by -{super,classic}.postinst
# This file needs to be sourced

if [ -z "${FB_VER:-}" ];
then
    echo Please define FB_VER before sourcing functions.sh
    exit 1
fi

export FB_VER
FB_VER_no_dots=`echo $FB_VER | sed -e 's/\.//g'`

FB="/usr/lib/firebird/$FB_VER"
VAR="/var/lib/firebird/$FB_VER"
ETC="/etc/firebird/$FB_VER"
LOG_DIR="/var/log/firebird"
LOG="$LOG_DIR/firebird${FB_VER}.log"
RUN="/var/run/firebird$FB_VER"
DBAPasswordFile="$ETC/SYSDBA.password"

create_var_run_firebird()
{
    if ! [ -d $RUN ]; then
        mkdir --parent $RUN
        chmod 0770 $RUN
        chown firebird:firebird $RUN
    fi
}

fixPerms() {
    create_var_run_firebird

    find $VAR -type d -exec chown firebird:firebird {} \; \
                           -exec chmod 0770 {} \;
    find $VAR -type f -exec chown firebird:firebird {} \; \
                           -exec chmod 0660 {} \;

    chmod 0770 $LOG_DIR
    chown firebird:firebird $LOG_DIR
}

#---------------------------------------------------------------------------
# set new SYSDBA password with gsec

writeNewPassword () {
    local NewPasswd=$1

    # Provide default SYSDBA.password
    if [ ! -e "$DBAPasswordFile" ];
    then
        touch "$DBAPasswordFile"
        chmod 0600 "$DBAPasswordFile"

        cat <<_EOF > "$DBAPasswordFile"
# Password for firebird SYSDBA user
#
# You may want to use the following command for changing it:
#   dpkg-reconfigure firebird${FB_VER}
#
# If you change the password manually with isql-fb or gsec, please update it
# here too. Keeping this file in sync with the security database is useful for
# any database maintenance scripts that need to connect as SYSDBA.

ISC_USER=sysdba
ISC_PASSWORD=
_EOF
    else
        . "$DBAPasswordFile"
    fi
    if [ "$NewPasswd" != "${ISC_PASSWORD:-}" ]; then
        service firebird3.0 stop
        p=$(echo "$NewPasswd" | sed "s/'/''/g")
        echo "create or alter user sysdba password '$p';" \
            | isql-fb -user sysdba "$SEC_DB"

        # Running as root may create lock files that
        # need to be owned by firebird instead
        fixPerms

        if grep "^ *ISC_PASSWORD=" "$DBAPasswordFile" > /dev/null;
        then
            # Update existing line

            # create .tmp file preserving permissions
            cp -a "$DBAPasswordFile" "$DBAPasswordFile.tmp"

            sed -e "s/^ *ISC_PASSWORD=.*/ISC_PASSWORD=\"$NewPassword\"/" \
            < "$DBAPasswordFile" > "$DBAPasswordFile.tmp"
            mv -f "$DBAPasswordFile.tmp" "$DBAPasswordFile"
        else
            # Add new line
            echo "ISC_PASSWORD=$NewPassword" >> "$DBAPasswordFile"
        fi

        ISC_PASSWORD=$NewPassword
    fi
}

askForDBAPassword ()
{
    if [ -f "$DBAPasswordFile" ];
    then
        . "$DBAPasswordFile"
    fi

    QUESTION=shared/firebird/sysdba_password/new_password

    db_get "$QUESTION" || true
    if [ -z "$RET" ];
    then
        if [ -z "${ISC_PASSWORD:-}" ];
        then
            NewPassword=$(cut -c 1-8 /proc/sys/kernel/random/uuid)
        else
            NewPassword=$ISC_PASSWORD
        fi
    else
        NewPassword=$RET
    fi

    writeNewPassword "$NewPassword"

    # Make debconf forget all password questions
    db_reset $QUESTION || true
    db_reset shared/firebird/sysdba_password/first_install || true
    db_reset shared/firebird/sysdba_password/upgrade_reconfigure || true
}

instantiate_security_db()
{
    SYS_DIR="$VAR/system"
    SEC_DB="$SYS_DIR/security3.fdb"

    if ! [ -e "$SEC_DB" ];
    then
        local SEC_SQL="/usr/share/firebird/3.0/security.sql"
        local T=$(mktemp -d)
        trap "rm -rf '$T'" 0 INT QUIT
        local T_SEC="$T/security.fdb"

        (
            set -e
            export LANG=C
            echo "create database '$T_SEC';" | isql-fb -q
            gfix -user SYSDBA -write async "$T_SEC"
            isql-fb -user SYSDBA -i "$SEC_SQL" "$T_SEC"
        )
        gfix -user SYSDBA -write sync "$T_SEC"
        install -o firebird -g firebird -m 0660 "$T_SEC" "$SEC_DB"

        # Since we've copied the default security database, the SYSDBA password
        # must be reset
        if [ -f "$DBAPasswordFile" ]; then
            rm "$DBAPasswordFile"
        fi
        echo Created default security3.fdb
    fi
}

firebird_config_postinst()
{
    instantiate_security_db

    fixPerms

    if ! invoke-rc.d firebird$FB_VER start; then
        echo "Firebird $FB_VER server not enabled or unable to start"
        echo "Not setting SYSDBA password"
        echo "Please run 'dpkg-reconfigure firebird$FB_VER-server'"
        echo "later to set the SYSDBA password"
    else
        askForDBAPassword
    fi

    debhelper_hook "$@"
}

# vi: set sw=4 ts=8 filetype=sh sts=4 :
