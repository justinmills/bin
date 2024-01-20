#! /bin/bash

# Shortcut to download a web site recursively

SITE="$1"

echo "Downloading site $1 recursively to ."
wget --no-parent -r "$SITE"
