#!/bin/bash
set -e

TOPDIR=$(dirname $(realpath $0))/..

echo $TOPDIR

pushd $TOPDIR

GIT_REVSION=$(git log --pretty="%h"|wc|awk '{print $1}')
VERSION=$(cat VERSION || echo 0.0).$GIT_REVSION
GIT_ID=$(git log -n 1 --format="%h")

WORKDIR="emacs_${VERSION}_synology-${GIT_ID}"

if [ -d $WORKDIR ]; then
    rm -rf $WORKDIR
fi

mkdir $WORKDIR/DEBIAN -p
mkdir $WORKDIR/usr/local -p

cat <<EOF > $WORKDIR/DEBIAN/control
Package: emacs
Version: $VERSION
Section: custom
Priority: optional
Architecture: amd64
Depends:
Essential: no
Maintainer: Janncker
Description: emacs for synology

EOF
set -x
make install prefix=$(pwd)/$WORKDIR/usr/local

cp $TOPDIR/utils/postinst $WORKDIR/DEBIAN/
cp $TOPDIR/utils/preinst $WORKDIR/DEBIAN/

dpkg-deb --build $WORKDIR

popd
