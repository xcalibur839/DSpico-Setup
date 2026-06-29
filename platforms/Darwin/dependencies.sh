#!/usr/bin/env bash

cd $(dirname $0)/../..

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

echo Installing Dependencies
echo -en "\033]1; Installing Dependencies \007"
brew install dotnet-sdk@9 p7zip wget cmake gnu-sed gcc-arm-embedded -y