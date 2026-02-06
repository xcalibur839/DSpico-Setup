# DSpico-Setup
Scripts to automatically compile and update [DSpico Firmware](https://github.com/LNH-team/dspico-firmware). Huge thanks to the [DSpico Project](https://github.com/LNH-team/dspico)!

Currently only supports Arch and Ubuntu Linux based distros.

Requires extracted decryption key(s) (DS and DSi) and WRFUTester v0.60 (optional for full DSi/3DS UART support). Place biosnds7.bin and biosdsi7.bin in the keys/ folder (and optionally WRFUTester in the bin/ folder with the file name dsimode.nds).

Execute install.sh on first run, and update.sh on each subsequent run.