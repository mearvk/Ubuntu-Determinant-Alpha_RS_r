#!/bin/bash

die () {
    echo "$@" 1>&2
    exit 1
}

HOST=https://www.iana.org/time-zones

dh_testdir debian/changelog || die "You are not in the source package's root directory."

debdbversion=$(head -n1 debian/changelog  | sed 's/^.*+\([0-9a-z]*\)).*$/\1/')
updbversion=$(wget -q -O- ${HOST}/ | grep tzdata | perl -pe 's/.+".+tzdata(.+)\.tar.gz".+/$1/')
dttzversion=$(awk '/version =/ {print $3;}' dist.ini)

if [ "$debdbversion" != "$updbversion" ] ; then
    echo "Debian dbversion $debdbversion != upstream dbversion $updbversion."
    echo "You might want to change the Debian dbversion in debian/changelog."
    read -p "Continue with $updbversion (y/N)? " CONTINUE
    case $CONTINUE in
        y|Y)
            ;;
        *)
            die "Aborted on user request."
            ;;
    esac
fi    

mkdir -p debian/tzdata || die "Cannot mkdir debian/tzdata."

pushd debian/tzdata || die "Cannot cd debian/tzdata."

    file=tzdata$updbversion.tar.gz
    url=${HOST}/repository/releases/$file

    rm -f *
    
    (
        echo "These files were downloaded with debian/tools/update-tzdata.sh script"
        echo "from $url"
        echo "at `date -R` by Debian maintainer" 
    ) > README

    wget $url || die "Cannot download $url."

    tar zxvf $file || die "Cannot unpack tzdata tarball."
    
    rm -f $file || die "Cannot remove tzdata tarball."

popd

perl tools/parse_olson --dir debian/tzdata --version $updbversion --clean
