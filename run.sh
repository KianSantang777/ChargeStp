#!/bin/bash
# ==========================================================
# BraintreeCHK Universal Installer (Termux / Linux / Ubuntu)
# Author: Kian Santang
# GitHub: https://github.com/KianSantang777/ChargeStp
# ==========================================================

clear
echo ""
echo "=========================================="
echo "       ChargeStp Auto Installer"
echo "=========================================="
echo ""

# Detect environment
if [ -d "/data/data/com.termux" ]; then
    PLATFORM="termux"
    echo "Detected environment: Termux (Android)"
else
    PLATFORM="linux"
    echo "Detected environment: Linux / Ubuntu"
fi

# Step 1: Update & Upgrade
echo "[1/8] Updating and upgrading system..."
if [ "$PLATFORM" = "termux" ]; then
    pkg update -y && pkg upgrade -y
else
    sudo apt update -y && sudo apt upgrade -y
fi

# Step 2: Request storage permission (Termux only)
if [ "$PLATFORM" = "termux" ]; then
    echo "[2/8] Requesting storage permission..."
    termux-setup-storage
fi

# Step 3: Install essential packages
echo "[3/8] Installing required packages..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install python git nano -y
else
    sudo apt install -y python3 python3-pip git nano software-properties-common
fi

# Step 4: Ensure Python 3.12.x
echo "[4/8] Checking Python version..."
PY_VER=$(python3 -V 2>&1)
if echo "$PY_VER" | grep -q "3.12"; then
    echo "Python version OK: $PY_VER"
else
    echo "Python 3.12.x not found. Attempting to install (Linux only)..."
    if [ "$PLATFORM" = "linux" ]; then
        sudo add-apt-repository -y ppa:deadsnakes/ppa
        sudo apt update -y
        sudo apt install -y python3.12 python3.12-venv python3.12-distutils
    else
        echo "Warning: Termux uses default Python version."
    fi
fi

# Step 5: Navigate to project directory
if [ -d "$HOME/ChargeStp" ]; then
    cd "$HOME/ChargeStp" || exit
else
    echo "Error: ChargeStp directory not found!"
    echo "Please place this script inside or above the ChargeStp folder."
    exit 1
fi

# Step 6: Install Python requirements from stuff/
echo "[6/8] Installing Python dependencies from stuff/requirements.txt..."
if [ -f "stuff/requirements.txt" ]; then
    if command -v python3.12 &> /dev/null; then
        python3.12 -m pip install --upgrade pip
        python3.12 -m pip install -r stuff/requirements.txt
    else
        python3 -m pip install --upgrade pip
        python3 -m pip install -r stuff/requirements.txt
    fi
else
    echo "Error: stuff/requirements.txt not found!"
    exit 1
fi

# Step 7: Set permissions
echo "[7/8] Adjusting directory permissions..."
chmod -R 755 "$HOME/ChargeStp"

# Step 8: Run main script (auto-restart)
echo "[8/8] Launching ChargeStp..."
echo ""
echo "=========================================="
echo "  Starting goo.py (auto-restart enabled)"
echo "  Press CTRL + C to stop manually."
echo "=========================================="
echo ""

while true; do
    if command -v python3.12 &> /dev/null; then
        python3.12 "$HOME/ChargeStp/goo.py"
    else
        python3 "$HOME/ChargeStp/goo.py"
    fi

    echo ""
    echo ">>> goo.py stopped. Restarting in 5 seconds..."
    sleep 5
done
