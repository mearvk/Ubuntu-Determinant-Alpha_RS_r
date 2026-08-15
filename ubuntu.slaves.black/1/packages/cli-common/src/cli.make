#export MONO_SHARED_DIR=$(CURDIR)
export MONO_DISABLE_SHM = 1
export DH_OPTIONS += --with=cli
$(warning WARNING: the use of /usr/share/cli-common/cli.make is deprecated! Use dh $$@ --with=cli instead.)
