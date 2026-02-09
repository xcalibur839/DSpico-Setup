#!/usr/bin/env bash

source /etc/os-release

# Create needed directories
mkdir -p bin keys

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

if [ -d platforms/${ID} ]; then
    export base_dir=$(dirname $(realpath "$0"))/bin
    platforms/${ID}/dependencies.sh
    platforms/common.sh
else
    echo
    echo "Platform $ID not currently supported"
    echo
fi