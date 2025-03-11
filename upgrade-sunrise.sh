#!/bin/bash

# Ensure a tag is provided
if [ -z "$1" ]; then
    echo "Usage: git upgrade-sunrise <tag>"
    exit 1
fi

TAG=$1
TEMP_DIR="../$TAG"

# Fetch the latest tags from the remote 'sunrise'
git fetch sunrise
git ls-remote --tags sunrise

# Create a new branch for this upgrade
git checkout -b "sunrise-$TAG"

# Create a temporary directory to clone the tag
mkdir -p "$TEMP_DIR"

# Clone only the specified tag without history
git clone --depth 1 --branch "$TAG" --single-branch git@github.com:fxdevelopers/shopify-theme-sunrise.git "$TEMP_DIR"

# Remove specific files that shouldn't be overwritten
rm -Rf "$TEMP_DIR/config/settings_data.json"
rm -Rf "$TEMP_DIR/templates"

# Use rsync to copy files while preserving existing Git history
rsync -av --exclude=".git" "$TEMP_DIR/" ./

# Clean up the temporary directory
rm -rf "$TEMP_DIR"

# Add and commit the changes
git add .
git commit -m "Upgrade to version $TAG"

# Push the new branch
git push origin "sunrise-$TAG"
