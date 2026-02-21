#!/usr/bin/env bash

export DLDITOOL="/opt/blocksds/core/tools/dlditool/dlditool"

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
build_dir=$base_dir/DSRomEncryptor/DSRomEncryptor/bin/Release/net9.0

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