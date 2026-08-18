#!/bin/bash

export COMMON_BRANCH="lp:~kubuntu-packagers/kubuntu-packaging/kubuntu-l10n-common"
export COMMON_DIR="common-l10n"
if [ ! -d $COMMON_DIR ]; then
    bzr co $COMMON_BRANCH $COMMON_DIR
else
    wd=`pwd`
    cd $COMMON_DIR
    bzr up
    cd $wd
fi
if [ ! -d $COMMON_DIR ]; then
    echo "failed to get kubuntu-l10n-common, cannot continue!"
    exit 1
fi

if ! source $COMMON_DIR/common ; then
    echo "could not source common functions!!"
    exit 1
fi

###################################

checkDependencies
cdMainDirectory "language-pack-kde-common"

includeConfig
ensureBranchIsPushed

exportDirectories
purgeBuildDirectory
initBuildDirectory

### TODO: configify
cd $BUILD_DIR
CO="common"
bzr branch lp:~kubuntu-packagers/kubuntu-packaging/language-pack-kde-common common

### TODO: configify somehow
latest_kde_version=`ssh ${REMOTE_HOST} ls ${REMOTE_HOME}/${TYPE} | grep -P "^\d.*" | sort -V | tail -1`
tar_files=`ssh ${REMOTE_HOST} ls ${REMOTE_HOME}/${TYPE}/${latest_kde_version}/src/kde-l10n/ | grep "kde-l10n-.*.tar.xz"`

for tar_file in $tar_files; do
    echo "looking at tar $tar_file"

    if [[ $tar_file =~ kde-l10n-(.*)-$latest_kde_version.tar.xz ]]; then
        exportCodeMappings ${BASH_REMATCH[1]}
    else
        echo "!!! SKIPPING $tar_file BECAUSE THE VERSION COULD NOT BE PARSED!!!"
        continue
    fi

    cd $BUILD_DIR
    bzr branch $CO language-pack-kde-$ubuntudep

    cd language-pack-kde-$ubuntudep/debian/
    for debian_file in `ls`; do
        gsubDebianFile $debian_file
    done

    bzr-buildpackage -S --builder "dpkg-buildpackage -S -us -uc"
done
