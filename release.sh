#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

echo "----------------------------------------"
echo " Release Preparation Script"
echo "----------------------------------------"

# Prompt for the version
read -p "Enter the new release version (e.g., 1.2.3): " VERSION

# Confirm input
echo "Preparing release for version v$VERSION..."

# Commit any staged changes
read -p "Enter a commit message for this release: " COMMIT_MSG
git add .
git commit -m "$COMMIT_MSG"

# Create the tag
git tag -a "v$VERSION" -m "Release version v$VERSION"

# Push commits and tag
git push origin main  # or 'master' or your default branch
git push origin "v$VERSION"

echo "Release v$VERSION created and pushed."

# Optional: Create GitHub release
read -p "Do you want to create a GitHub Release as well? (y/n): " CREATE_RELEASE

if [ "$CREATE_RELEASE" = "y" ] || [ "$CREATE_RELEASE" = "Y" ]; then
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed."
        read -p "Do you want to attempt to install gh now? (y/n): " INSTALL_GH

        if [ "$INSTALL_GH" = "y" ] || [ "$INSTALL_GH" = "Y" ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "Detected macOS. Installing gh with Homebrew..."
                brew install gh
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "Detected Linux. Installing gh with apt..."
                sudo apt update
                sudo apt install -y gh
            else
                echo "Unsupported OS. Please install GitHub CLI manually."
                exit 1
            fi
        else
            echo "Skipping GitHub release creation."
            exit 0
        fi
    fi

    read -p "Enter release notes (a short summary): " RELEASE_NOTES
    gh auth login  # Will prompt you if not authenticated
    gh release create "v$VERSION" --title "v$VERSION" --notes "$RELEASE_NOTES"
    echo "GitHub Release created."
fi

echo "----------------------------------------"
echo " Script completed."
echo "----------------------------------------"
