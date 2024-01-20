#! /bin/bash
#
# Dumb little wrapper to find a repo by name using gh
#

PARTIAL="$1"

# Only show links so you can easily click on them to open them up.
gh search repos --owner=waymark-care --json url,name --jq '.[].url' "$PARTIAL"
