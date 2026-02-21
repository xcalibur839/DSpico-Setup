#!/usr/bin/env bash

echo Checking for Homebrew installation
echo -en "\033]1; Checking for Homebrew \007"
if ! which brew; then
    echo Homebrew not found. Beginning installation.
    echo -en "\033]1; Installing Homebrew \007"
    yes "" | INTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>/dev/null

    echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

echo -en "\033]1; Installing initial dependencies with Homebrew \007"
brew install cmake pkgconf git wget sevenzip uv python3 meson llvm@16 gpg gsed luarocks texinfo
brew install --cask dotnet-sdk@9
ln -s /opt/homebrew/bin/7zz /opt/homebrew/bin/7z
export PATH="/opt/homebrew/opt/python/libexec/bin:/opt/pacman/bin:/opt/wonderful/bin:$PATH"

echo "Homebrew and dependencies installed"

export base_dir=$(dirname $0)
cd $base_dir

if ! [ -x /opt/pacman/bin/makepkg ]; then
    ./pacman.sh
fi

echo "Installing Wonderful Toolchain"
echo -en "\033]1; Installing Wonderful Toolchain \007"

sudo mkdir -p /opt/wonderful
sudo chown $USER:staff /opt/wonderful
pushd /opt/wonderful
git clone https://github.com/aronson/eden-packages.git /opt/wonderful

sudo ln -s /opt/wonderful /opt/eden
echo "wf	/opt/wonderful" | sudo tee -a /etc/synthetic.conf
sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
popd

for script in wonderful-toolchain/*.sh; do
    echo "Running $script"
    $script
done

exit


git clone --recurse-submodules https://codeberg.org/blocksds/sdk.git
cd sdk
ex -sc '1i|#typedef uint16_t char16_t;' -cx libs/libnds/include/nds/utf.h

BLOCKSDS=$PWD make -j`nproc`
sudo mkdir /opt/blocksds/ && sudo chown $USER:staff /opt/blocksds
mkdir /opt/blocksds/external
make install

cd ..
git clone --recurse-submodules https://github.com/blocksds/dldipatch.git
cd dldipatch
make
make install

cd $(dirname $0)/../..
./install.sh