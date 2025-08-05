#!/bin/bash
DOWNLOAD_URL="https://raw.githubusercontent.com/hhkcu/LemonManualInstaller/refs/heads/main/cv.gz"
INSTALL_DIR="cineview"

echo "Downloading the webapp..."
curl -L "$DOWNLOAD_URL" -o "$INSTALL_DIR.tar.gz"

if [ $? -ne 0 ]; then
    echo "Error: Failed to download the webapp. Please check the DOWNLOAD_URL."
    exit 1
fi

echo "Extracting the webapp..."
mkdir -p "$INSTALL_DIR"
tar -xzvf "$INSTALL_DIR.tar.gz" -C "$INSTALL_DIR" --strip-components=1

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract the webapp. The tar.gz file might be corrupted or the path is incorrect."
    exit 1
fi

echo "Cleaning up downloaded archive..."
rm "$INSTALL_DIR.tar.gz"

echo "Navigating to the webapp directory and running setup script..."
cd "$INSTALL_DIR"

if [ $? -ne 0 ]; then
    echo "Error: Could not change directory to $INSTALL_DIR."
    exit 1
fi

chmod +x start.sh

./start.sh