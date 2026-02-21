#!/usr/bin/env bash

current=$(basename "$0" | cut -d'.' -f 1 | cut -d'-' -f 2-)
echo "Installing $current"
echo -en "\033]1; Installing Wonderful Toolchain ($current) \007"

pushd /opt/wonderful/packages/templates/
prep=$(cat $current.PKGBUILD | grep -n -A15 "prepare()" | grep "}" | cut -d'-' -f 1 | tail -1)
ex -sc "${prep}i|export SOURCE_DATE_EPOCH='$(date +%s)'" \
-sc "${prep}i|export old_date=\$SOURCE_DATE_EPOCH" \
-sc "${prep}i|patch -p1 < $base_dir/fix-fdopen-conflict.patch" \
-cx $current.PKGBUILD
build=$(cat $current.PKGBUILD | grep -n -A15 "build()" | grep "}" | cut -d'-' -f 1 | tail -1)
ex -sc "${build}i|export SOURCE_DATE_EPOCH=\$old_date" -cx $current.PKGBUILD
popd

pushd /opt/wonderful/packages/toolchain-gcc-arm-none-eabi-binutils
makepkg -C --clean --syncdeps --noconfirm --skippgpcheck
wf-pacman -U --noconfirm toolchain-gcc*.pkg.tar.gz
cp toolchain-gcc*.pkg.tar.gz /wf/pacman/repo/
repo-add /opt/wonderful/pacman/repo/wf-pacman-local.db.tar.gz /opt/wonderful/pacman/repo/toolchain-gcc*
wf-pacman -Sy
pacman -Sy
popd