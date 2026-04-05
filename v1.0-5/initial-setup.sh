#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "\033[1;32mWelcome to the setup script for vcd-man!\033[0m"
echo "This will prepare your system for running vcd-man."
echo "If you are running a version of macOS that is 10.15 or above,"
echo "download the non-legacy version of vcd-man instead."
echo ""

echo "[STEP 1]"
echo "\033[1;33mEnter your macOS version:\033[0m"
echo ""
echo "[1] 10.13 High Sierra"
echo "[2] 10.14 Mojave"
echo ""
read VersionChoice
echo ""

if [[ $VersionChoice == 1 ]]; then
    echo "10.13 High Sierra selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-10.13-HighSierra.pkg.pkg"
    sudo installer -pkg "MacPorts-2.12.4-10.13-HighSierra.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-10.13-HighSierra.pkg"
elif [[ $VersionChoice == 2 ]]; then
    echo "10.14 Mojave selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-10.14-HighSierra.pkg"
    sudo installer -pkg "MacPorts-2.12.4-10.14-HighSierra.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-10.14-HighSierra.pkg"
else
    echo "Invalid input. You need to enter the number in the [] brackets associated with your macOS version."
    exit 0
fi

echo ""
echo "MacPorts has been installed,"
echo "but only added to the PATH temporarily."
echo "If you need to use MacPorts later, you must add"
echo "the export line to the end of your ~/.zprofile file."

export "PATH=$PATH:/opt/local/bin"

echo ""
echo "[STEP 2]"
echo "The installer will now install all required dependencies, unless they are already installed."
echo ""

if ! command -v ffmpeg >/dev/null 2>&1
then
    sudo port install ffmpeg
fi

if ! command -v vcdimager >/dev/null 2>&1
then
    sudo port install vcdimager
fi

if ! command -v bchunk >/dev/null 2>&1
then
    sudo port install bchunk
fi

echo ""
echo "\033[1;32mvcd-man SHOULD have installed!\033[0m"
echo "Now, simply run vcd-man.sh to start the program."
echo "Would you like to run vcd-man now? [y/n]"
read RunNowChoice

if [[ $RunNowChoice == "y" ]]; then
    sh vcd-man.sh
fi