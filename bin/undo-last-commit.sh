#! /bin/bash

# TODO: make sure the current tree doesn't have other pending changes?

echo "Undoing the last commit..."
git reset --soft HEAD~1
