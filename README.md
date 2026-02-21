# DSpico-Setup
## This branch is under active development. Use with caution and expect bugs.

Scripts to automatically compile and update [DSpico Firmware](https://github.com/LNH-team/dspico-firmware). Huge thanks to the [DSpico Project](https://github.com/LNH-team/dspico)!

Currently only supports Windows 11, macOS (experimental), and Arch or Ubuntu Linux based distros.

Requires DS and DSi BIOS/Firmware files, as well as WRFUTester v0.60 (optional for full DSi/3DS UART support). Place biosnds7.bin and biosdsi7.bin in the keys/ folder (and optionally WRFUTester in the bin/ folder with the file name dsimode.nds).

Execute winstall.bat on Windows or install.sh on Linux first, then run wupdate.bat on Windows or update.sh on Linux for each subsequent run.

If you don't initially include the optional WRFUTester file, but want to add it later, place the file in the bin folder and run the install script again.