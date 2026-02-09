#!/usr/bin/env bash

export DSi="false"

# Install extras if available, exit otherwise
if [ -e extras.sh ]; then
    ./extras.sh
    export DSi="true"
elif [ -e keys/biosnds7.bin -a -e keys/biosdsi7.bin ]; then
    if [ ! -e bin/dsimode.nds ]; then
        echo "WRFUTester v0.60 (dsimode.nds) not found in the bin folder. Full DSi/3DS support wil not be included."
        echo "Press Ctrl+C to cancel or Press Enter to continue"
        read
    else
        echo "Using manually downloaded files (with full DSi support)"
        export DSi="true"
    fi
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

source /opt/wonderful/bin/wf-env
wf-pacman -Syu

export DLDITOOL=/opt/wonderful/thirdparty/blocksds/core/tools/dlditool/dlditool

base_dir=$(dirname $(realpath "$0"))/bin

pushd $base_dir
cd dspico-dldi
git pull
make
cd ../dspico-bootloader
git pull
make
$DLDITOOL $base_dir/dspico-dldi/DSpico.dldi BOOTLOADER.nds
cd ../DSRomEncryptor
git pull
dotnet build
build_dir=DSRomEncryptor/bin/Debug/net9.0

if [[ "$DSi" != "false" ]]; then
    cp $base_dir/../keys/biosdsi7.bin $build_dir/biosdsi7.rom
fi
cp $base_dir/../keys/biosnds7.bin $build_dir/biosnds7.rom
cd $build_dir
./DSRomEncryptor $base_dir/dspico-bootloader/BOOTLOADER.nds default.nds

if [[ "$DSi" != "false" ]]; then
    cd $base_dir/dspico-wrfuxxed
    git pull
    make
    $DLDITOOL $base_dir/dspico-dldi/DSpico.dldi uartBufv060.bin
fi

cd $base_dir/dspico-firmware
git pull
cp $base_dir/DSRomEncryptor/$build_dir/default.nds roms/

if [[ "$DSi" != "false" ]]; then
    cp $base_dir/dsimode.nds roms/
    cp $base_dir/dspico-wrfuxxed/uartBufv060.bin data/
    sed -i 's/#DSPICO_ENABLE_WRFUXXED/DSPICO_ENABLE_WRFUXXED/' CMakeLists.txt
fi

./compile.sh
echo
cp ./build/DSpico.uf2 $base_dir/../
cd $base_dir/..
echo Compiled DSpico.uf2 can also be found in $(pwd)
popd