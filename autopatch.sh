#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <link to .diff file>"
    exit 1
fi

DIFF_URL=$1
mkdir -p patches
PATCH_FILE="patches/$(basename "$DIFF_URL")"

echo "Downloading patch from $DIFF_URL..."
wget -O "$PATCH_FILE" "$DIFF_URL"

if [ $? -ne 0 ]; then
    echo "Error downloading the file."
    exit 1
fi

echo "Applying patch $PATCH_FILE..."
patch < "$PATCH_FILE"

if [ $? -ne 0 ]; then
    echo "Error applying the patch."
    exit 1
fi

echo "Patch applied successfully."
