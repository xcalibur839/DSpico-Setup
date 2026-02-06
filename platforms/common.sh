#!/usr/bin/env bash

# Create needed directories
mkdir -p bin keys

# Install extras if available, exit otherwise
if [ -e extras.sh ]; then
    ./extras.sh
elif [ -e keys/biosnds7 -a -e keys/biosdsi7.bin -a "$DSi" -eq "false" ]; then
    echo "Using manually downloaded keys (without full DSi support)"
elif [ -e keys/biosdsi7.bin -a -e keys/biosnds7.bin -a -e bin/dsimode.nds -a "$DSi" -ne "false" ]; then
    echo "Using manually downloaded files (with full DSi support)"
else
    echo
    echo
    echo Required files missing:
    echo keys/biosnds7.bin, keys/biosdsi7.bin
    echo
    echo Optional DSi file missing:
    echo "bin/dsimode.nds (WRFUTester v0.60)"
    echo
    echo
    exit 1
fi

# Install Wonderful Toolchain
sudo mkdir /opt/wonderful
sudo chown -R "$USER" /opt/wonderful
pushd /opt/wonderful/
wget https://wonderful.asie.pl/bootstrap/wf-bootstrap-x86_64.tar.gz
tar xzvf wf-bootstrap-x86_64.tar.gz
bin/wf-pacman -Syu --noconfirm wf-tools
source /opt/wonderful/bin/wf-env

# Install BlocksDS
export PATH=/opt/wonderful/bin:$PATH

wf-config repo enable blocksds
wf-pacman -Syu --noconfirm blocksds-toolchain blocksds-docs toolchain-llvm-teak-llvm

# Install Third Party libs (optional)
if [[ "$DSi" != "false" ]]; then
    wf-pacman -S --noconfirm blocksds-nflib blocksds-nitroengine
fi

# Setup Environment vars
sudo ln -s /opt/wonderful/thirdparty/blocksds /opt/blocksds
source /opt/wonderful/bin/wf-env
export DLDITOOL=/opt/wonderful/thirdparty/blocksds/core/tools/dlditool/dlditool
popd

# Begin initial setup
mkdir -p $base_dir
cd $base_dir
git clone https://github.com/LNH-team/dspico-dldi.git
cd dspico-dldi
make
cd $base_dir
git clone https://github.com/LNH-team/dspico-bootloader.git
cd dspico-bootloader
git submodule update --init
make
$DLDITOOL $base_dir/dspico-dldi/DSpico.dldi BOOTLOADER.nds
cd $base_dir
git clone https://github.com/Gericom/DSRomEncryptor.git
cd DSRomEncryptor
dotnet build --configuration Release
build_dir=$base_dir/DSRomEncryptor/DSRomEncryptor/bin/Release/net9.0/

cp $base_dir/../keys/biosdsi7.bin $build_dir/biosdsi7.rom
cp $base_dir/../keys/biosnds7.bin $build_dir/biosnds7.rom
cd $build_dir
./DSRomEncryptor $base_dir/dspico-bootloader/BOOTLOADER.nds default.nds

cd $base_dir
git clone https://github.com/LNH-team/dspico-firmware.git
firmware_dir=$base_dir/dspico-firmware
cd $firmware_dir
git submodule update --init
cd pico-sdk
git submodule update --init
cd ..
cp $build_dir/default.nds $firmware_dir/roms/

# DSi/3DS support
if [[ "$DSi" != "false" ]]; then
    cd $base_dir
    cp dsimode.nds $firmware_dir/roms/

    git clone https://github.com/LNH-team/dspico-wrfuxxed.git
    cd dspico-wrfuxxed
    make
    $DLDITOOL $base_dir/dspico_dldi/DSpico.dldi uartBufv060.bin 
    cp uartBufv060.bin $firmware_dir/data/
    cd $firmware_dir
    sed -i 's/#DSPICO_ENABLE_WRFUXXED/DSPICO_ENABLE_WRFUXXED/' CMakeLists.txt
fi

./compile.sh
echo
cp ./build/DSpico.uf2 $base_dir/../
cd $base_dir/..
echo Compiled DSpico.uf2 can also be found in $(pwd)