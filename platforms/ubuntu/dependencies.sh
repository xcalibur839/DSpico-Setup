#!/usr/bin/env bash

# Install dependencies
sudo add-apt-repository -y ppa:dotnet/backports
sudo apt update && sudo apt install -y wget dotnet-sdk-9.0 cmake gcc-arm-none-eabi build-essential git python3 7zip