#!/usr/bin/env bash
mkdir -p ~/dspico keys bin
cp -r ./* ~/dspico/
pushd ~/dspico
#git clone https://github.com/xcalibur839/DSpico-Setup.git ~/dspico
./install.sh
popd
cp ~/dspico/DSpico.uf2 ./