#!/usr/bin/env bash

current=$(basename "$0" | cut -d'.' -f 1 | cut -d'-' -f 2-)
echo "Installing $current"
echo -en "\033]1; Installing Wonderful Toolchain ($current) \007"

pushd /wf/packages/wf-pacman/macos
first_edit=$(cat PKGBUILD | grep -nm 2 "# xz" | cut -d':' -f 1)
ex -sc "${first_edit}i|export SOURCE_DATE_EPOCH='$(date +%s)'" \
-sc "${first_edit}i|export old_date=\$SOURCE_DATE_EPOCH" \
-cx PKGBUILD
last_edit=$(cat PKGBUILD | grep -nm 1 "wf_relocate_path_to_destdir" | cut -d':' -f 1)
ex -sc "${last_edit}i|export SOURCE_DATE_EPOCH=\$old_date" \
-cx PKGBUILD
makepkg -C --clean --syncdeps --noconfirm --skippgpcheck
pacman -U --noconfirm wf-pacman*.pkg.tar.gz
cp -R ./pacman /wf/
cp -R ../config/pacman.d /wf/etc/
mkdir -p /wf/pacman/db /wf/pacman/repo
cp wf-pacman*.pkg.tar.gz /wf/pacman/repo/

echo "[wf-pacman-local]" >> /wf/etc/pacman.d/001-wf-pacman.conf
echo "Server = file:///wf/pacman/repo" >> /wf/etc/pacman.d/001-wf-pacman.conf
echo "[wf-pacman-local]" >> /opt/pacman/etc/pacman.conf
echo "Server = file:///wf/pacman/repo" >> /opt/pacman/etc/pacman.conf
repo-add /opt/wonderful/pacman/repo/wf-pacman-local.db.tar.gz /opt/wonderful/pacman/repo/$current*

export PATH="/wf/bin:$PATH"
echo PATH="/wf/bin:$PATH" >> ~/.zprofile

wf-pacman -U --noconfirm wf-pacman*.pkg.tar.gz --overwrite=/opt/wonderful/bin/bash,\
/opt/wonderful/bin/bashbug,\
/opt/wonderful/bin/makepkg,\
/opt/wonderful/bin/makepkg-template,\
/opt/wonderful/bin/pacman-conf,\
/opt/wonderful/bin/pacman-db-upgrade,\
/opt/wonderful/bin/pacman-key,\
/opt/wonderful/bin/repo-add,\
/opt/wonderful/bin/repo-elephant,\
/opt/wonderful/bin/repo-remove,\
/opt/wonderful/bin/testpkg,\
/opt/wonderful/bin/wf-pacman,\
/opt/wonderful/bin/wf-pacman-vercmp,\
/opt/wonderful/etc/99-final.conf,\
/opt/wonderful/etc/makepkg.conf,\
/opt/wonderful/etc/makepkg.conf.d/fortran.conf,\
/opt/wonderful/etc/makepkg.conf.d/rust.conf,\
/opt/wonderful/etc/pacman.conf

sed -i "" "s/\(\[wonderful\]\)/#\1/" /opt/wonderful/etc/pacman.conf
sed -i "" "s/\(Server.*\)/#\1/" /opt/wonderful/etc/pacman.conf
wf-pacman -Sy

sed -i '' 's/\(DBPath\).*/\1 = \/opt\/wonderful\/pacman\/db/g' /opt/pacman/etc/pacman.conf
pacman -Sy

popd