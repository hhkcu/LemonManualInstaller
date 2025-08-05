#!/bin/bash
REPO_OWNER="hhkcu"
REPO_NAME="LemonManualInstaller"
BRANCH="main"
INSTALL_DIR="cineview"
ARCHIVE_NAME="$INSTALL_DIR.tar.gz"

# Fetch the latest commit SHA from GitHub API
echo "Fetching latest commit SHA for $REPO_OWNER/$REPO_NAME ($BRANCH)..."
COMMIT_SHA=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/commits/$BRANCH" | jq -r .sha)

if [ -z "$COMMIT_SHA" ] || [ "$COMMIT_SHA" = "null" ]; then
    echo "Error: Failed to fetch commit SHA. Please check the repository and branch name."
    exit 1
fi

echo "Latest commit SHA: $COMMIT_SHA"

# Build the raw URL with commit hash
DOWNLOAD_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$COMMIT_SHA/cv.gz"

echo "Downloading the webapp from commit $COMMIT_SHA..."
curl -L "$DOWNLOAD_URL" -o "$ARCHIVE_NAME"

if [ $? -ne 0 ]; then
    echo "Error: Failed to download the webapp. Please check the DOWNLOAD_URL."
    exit 1
fi

echo "Extracting the webapp..."
mkdir -p "$INSTALL_DIR"
tar -xzvf "$ARCHIVE_NAME" -C "$INSTALL_DIR"

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract the webapp. The tar.gz file might be corrupted or the path is incorrect."
    rm "$ARCHIVE_NAME"
    exit 1
fi

echo "Cleaning up downloaded archive..."
rm "$ARCHIVE_NAME"

echo "Navigating to the webapp directory and running setup script..."
cd "$INSTALL_DIR" || { echo "Error: Could not change directory to $INSTALL_DIR."; exit 1; }

chmod +x start.sh
./start.sh
