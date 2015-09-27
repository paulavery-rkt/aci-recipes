#!/bin/bash
set -e
ACIDIR=$1
PACKAGE=$2

if [ -z $2 ]; then
	PACKAGE=$1
	ACIDIR="$(pwd)/out"

	echo "No target directory specified, using $ACIDIR"
fi

# Build all packages
BUILDDIR=$(mktemp -d)

if [ -z $PACKAGE ]; then
	for file in packages/*; do
		archci "$file" "$BUILDDIR"
		echo
	done
else
	archci "packages/$PACKAGE" "$BUILDDIR"
	echo
fi

# Create gpg key
gpg --export > "$BUILDDIR/pubkeys.gpg"

# Copy them to target directory after setting permissions
sudo chmod -R 644 "$BUILDDIR"
sudo chmod -R a+X "$BUILDDIR"
sudo chown -R root:root "$BUILDDIR"

sudo cp -rp "$BUILDDIR"/* "$ACIDIR"

# Clean up
sudo rm -rf "$BUILDDIR"
