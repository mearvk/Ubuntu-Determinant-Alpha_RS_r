#/bin/sh
#
# Little helper script to generate the jackd1 tarball from a git
# repository.
#
# Example usage:
#    $ git clone git://github.com/jackaudio/jack1.git
#    $ cd jack1
#    $ git submodule init
#    $ git submodule update
#    $ sh /path/to/make_tarball.sh /tmp/jackd1-x.y.z

GIT_SHORT_VERSION=`git diff-tree HEAD | head -n 1 | cut -b -8`
DATE_STRING=`date "+%Y%m%d"`
TARGET_DIR="$1+${DATE_STRING}git${GIT_SHORT_VERSION}"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path-prefix>"
    exit 1
fi

echo "Creating ${TARGET_DIR}"
mkdir "${TARGET_DIR}" || exit 1

echo "Exporting jack to ${TARGET_DIR}"
git archive master | tar -C "${TARGET_DIR}" -xf -
for submodule in tools example-clients jack; do
    echo "Exporting submodule ${submodule}"
    ( cd "$submodule" &&
        git archive master | tar -C "${TARGET_DIR}/${submodule}" -xf -
    )
done

echo "Cleaning git files from export directory"
find "${TARGET_DIR}" -name ".git*" -delete
