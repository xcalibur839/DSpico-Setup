@echo off
rem TODO: Add full WSL support
rem wsl --status; errorlevel == 50; 'means not installed'

wsl --status > nul
if ERRORLEVEL 50 (
    echo Initial WSL setup required
    goto setup_wsl
) else if ERRORLEVEL -1 (
    echo Continuing WSL setup
    goto continue_setup
)

:setup_wsl
echo Beginning WSL initial setup
pause
wsl --install --no-distribution
echo.
echo The computer needs to reboot to finish setup of WSL. Please save any open files and close all programs before continuing
echo Once the computer has rebooted, run this script again to continue setup
pause
shutdown /r /t 1
exit

:continue_setup
echo type "exit" and press Enter after creating your username and password to continue
echo.
wsl --install
wsl mkdir -p ~/dspico; cp -r ./* ~/dspico/; cd ~/dspico; ls; ./install.sh