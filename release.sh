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
    if ! command -v gh &> /dev/null
    then
        echo "GitHub CLI (gh) is not installed. Skipping GitHub release creation."
    else
        read -p "Enter release notes (a short summary): " RELEASE_NOTES
        gh release create "v$VERSION" --title "v$VERSION" --notes "$RELEASE_NOTES"
        echo "GitHub Release created."
    fi
fi

echo "----------------------------------------"
echo " Script completed."
echo "----------------------------------------"
