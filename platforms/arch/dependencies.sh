#!/usr/bin/env bash

source ./config.sh

# Install dependencies
sudo pacman -Syu --noconfirm --needed wget dotnet-sdk-9.0 cmake arm-none-eabi-gcc arm-none-eabi-newlib base-devel git python3 p7zip