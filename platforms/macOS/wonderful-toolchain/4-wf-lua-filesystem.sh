#!/usr/bin/env bash

current=$(basename "$0" | cut -d'.' -f 1 | cut -d'-' -f 2-)
echo "Installing $current"
echo -en "\033]1; Installing Wonderful Toolchain ($current) \007"

pushd /wf/packages/$current
prep=$(cat PKGBUILD | grep -n -A1 "build()" | cut -d'-' -f 1 | tail -1)
ex -sc "${prep}i|export SOURCE_DATE_EPOCH='$(date +%s)'" \
-sc "${prep}i|export old_date=\$SOURCE_DATE_EPOCH" \
-cx PKGBUILD
build=$(cat PKGBUILD | grep -n -A1 "package()" | cut -d'-' -f 1 | tail -1)
ex -sc "${build}i|export SOURCE_DATE_EPOCH=\$old_date" -cx PKGBUILD

makepkg -C --clean --syncdeps --noconfirm --skippgpcheck
wf-pacman -U --noconfirm $current*.pkg.tar.gz
cp $current*.pkg.tar.gz /wf/pacman/repo/
repo-add /opt/wonderful/pacman/repo/wf-pacman-local.db.tar.gz /opt/wonderful/pacman/repo/$current*
wf-pacman -Sy
pacman -Sy
popd