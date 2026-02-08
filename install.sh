#!/usr/bin/env bash

source /etc/os-release

if [ -d platforms/${ID} ]; then
    export base_dir=$(dirname $(realpath "$0"))/bin
    platforms/${ID}/dependencies.sh
    platforms/common.sh
else
    echo
    echo "Platform $ID not currently supported"
    echo
fi