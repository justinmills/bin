#! /usr/bin/env bash

#
# Script to set up the current python environment for development within Emacs.
#

# Check that we are in a poetry project and there is a virtual env and that the virtual env is
# activated. If any of these are not true, print an error and exit with a non-zero code.
if ! poetry env info > /dev/null 2>&1 ; then
    >&2 echo "Not in a poetry project or no virtual env found!"
    exit 1
fi

# We're good, so we can install the libraries we need to using pip directly.
echo "Installing python dependencies..."
poetry run pip install python-lsp-server[all] autoflake python-lsp-black pylsp-rope pylsp-mypy python-lsp-isort python-lsp-ruff
echo "All done!"

