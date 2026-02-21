#!/usr/bin/env bash

echo "Installing pacman"
echo -en "\033]1; Installing pacman \007"

sudo mkdir /opt/pacman && sudo chown $USER:staff /opt/pacman
export BOOTSTRAP=/opt/pacman
export PATH=$BOOTSTRAP/bin:$PATH

# Setup bash 5
curl -O https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz
tar -xzvf bash-5.1.tar.gz

pushd bash-5.1

./configure --prefix=$BOOTSTRAP
make install

popd


# Setup libarchive
curl -O https://www.libarchive.org/downloads/libarchive-3.6.0.tar.xz
tar -xvf libarchive-3.6.0.tar.xz

pushd libarchive-3.6.0

./configure --prefix=$BOOTSTRAP
make && make install

popd

# Setup openssl
curl -OL https://www.openssl.org/source/openssl-1.1.1n.tar.gz
tar -xvf openssl-1.1.1n.tar.gz

pushd openssl-1.1.1n

perl ./Configure --prefix=$BOOTSTRAP darwin64-arm64-cc
make
make install

popd

# Setup pacman
git clone https://gitlab.archlinux.org/pacman/pacman.git
pushd pacman
git checkout v6.0.1

curl -LO https://raw.githubusercontent.com/kladd/pacman-osx/macOS-13.0/pacman.patch
git apply pacman.patch

export PKG_CONFIG_PATH=$BOOTSTRAP/lib/pkgconfig:$PKG_CONFIG_PATH

# TODO: Disabled i18n to avoid library dependency,
meson build \
	--prefix=$BOOTSTRAP \
	--sysconfdir=$BOOTSTRAP/etc \
	--localstatedir=$BOOTSTRAP/var \
	--buildtype=plain \
	-Di18n=false -Dscriptlet-shell=$BOOTSTRAP/bin/bash
meson compile -C build
meson install -C build

export PACMAN=/opt/pacman/bin/pacman
$PACMAN --version

sed -i '' 's/#\(RootDir\).*/\1 = \/opt\/wonderful\//g' /opt/pacman/etc/pacman.conf
sed -i '' 's/#\(DBPath.*\)/\1/g' /opt/pacman/etc/pacman.conf

ln -sf $(which pkgconf) $BOOTSTRAP/lib/pkgconfig/pkg-config

PATH="/opt/pacman/bin:$PATH"
echo PATH="/opt/pacman/bin:$PATH" >> ~/.zprofile
popd