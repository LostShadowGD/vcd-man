#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "\033[1;32mWelcome to the setup script for vcd-man!\033[0m"
echo "This will prepare your system for running vcd-man."
echo "If you are running a version of macOS that is 10.13 or 10.14,"
echo "download the legacy version of vcd-man instead."
echo ""

echo "[STEP 1]"
echo "\033[1;33mEnter your macOS version:\033[0m"
echo ""
echo "[1] 10.15 Catalina"
echo "[2] 11 Big Sur"
echo "[3] 12 Monterey"
echo "[4] 13 Ventura"
echo "[5] 14 Sonoma"
echo "[6] 15 Sequoia"
echo "[7] 26 Tahoe"
echo ""
read VersionChoice
echo ""

if [[ $VersionChoice == 1 ]]; then
    echo "10.15 Catalina selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-10.15-Catalina.pkg"
    sudo installer -pkg "MacPorts-2.12.4-10.15-Catalina.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-10.15-Catalina.pkg"
elif [[ $VersionChoice == 2 ]]; then
    echo "11 Big Sur selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-11-BigSur.pkg"
    sudo installer -pkg "MacPorts-2.12.4-11-BigSur.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-11-BigSur.pkg"
elif [[ $VersionChoice == 3 ]]; then
    echo "12 Monterey selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-12-Monterey.pkg"
    sudo installer -pkg "MacPorts-2.12.4-12-Monterey.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-12-Monterey.pkg"
elif [[ $VersionChoice == 4 ]]; then
    echo "13 Ventura selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-13-Ventura.pkg"
    sudo installer -pkg "MacPorts-2.12.4-13-Ventura.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-13-Ventura.pkg"
elif [[ $VersionChoice == 5 ]]; then
    echo "14 Sonoma selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-14-Sonoma.pkg"
    sudo installer -pkg "MacPorts-2.12.4-14-Sonoma.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-14-Sonoma.pkg"
elif [[ $VersionChoice == 6 ]]; then
    echo "15 Sequoia selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-15-Sequoia.pkg"
    sudo installer -pkg "MacPorts-2.12.4-15-Sequoia.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-15-Sequoia.pkg"
elif [[ $VersionChoice == 7 ]]; then
    echo "26 Tahoe selected, installing MacPorts"
    curl -O -L "https://github.com/macports/macports-base/releases/download/v2.12.4/MacPorts-2.12.4-26-Tahoe.pkg"
    sudo installer -pkg "MacPorts-2.12.4-26-Tahoe.pkg" -target / -verbose
    rm -f "MacPorts-2.12.4-26-Tahoe.pkg"
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