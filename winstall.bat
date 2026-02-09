@echo off

if not exist extras.sh (
    if not exist keys\ (
        md keys
        echo Please place the DS and DSi BIOS/Firmware files ^(biosnds7.bin and biosdsi7.bin^) in the keys folder. This script will now close.
        pause
        exit
    )
    if not exist keys\biosdsi7.bin (
        echo Please place the DSi BIOS/Firmware file ^(biosdsi7.bin^) in the keys folder. This script will now close.
        pause
        exit
    )
    if not exist keys\biosnds7.bin (
        echo Please place the DS BIOS/Firmware file ^(biosnds7.bin^) in the keys folder. This script will now close.
        pause
        exit
    )
    if not exist bin\ (
        md bin
        echo Please place WRFUTester v0.60 ^(dsimode.nds^) in the bin folder to enable DSi/3DS support
    )
    if not exist bin\dsimode.nds (
        echo WRFUTester v0.60 ^(dsimode.nds^) not found in the bin folder. Press Ctrl+C to cancel, or
        pause
    )
)

wsl --status > nul
rem wsl --status; errorlevel == 50; 'means not installed'
if ERRORLEVEL 50 (
    echo Initial WSL setup required
    goto setup_wsl
) else if ERRORLEVEL -1 (
    echo Continuing WSL setup
    goto continue_setup
) else if ERRORLEVEL 0 (
    echo Finishing setup and compilation
    goto finish
)

:setup_wsl
echo Beginning WSL initial setup
timeout /t 15
wsl --install --no-distribution
echo.
echo The computer needs to reboot to finish setup of WSL. Please save any open files and close all programs before continuing
echo Once the computer has rebooted, run this script again to continue setup
pause
shutdown /r /t 0
exit

:continue_setup
echo [44mtype "exit" and press Enter after creating your username and password to continue[0m
echo.
wsl --install

:finish
wsl ./platforms/wsl2/finish.sh
pause