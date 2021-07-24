#! /bin/bash

# See here for more info
#   https://github.com/pyenv/pyenv/issues/1740
#
# Basically if you run into issues installing older versions of python via pyenv, this is the magic
# to get ya going (presuming you've already installed the xcode CLI and bzip2, zip and openssl via
# brew).

VERSION="${1:-3.7.2}"

CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" pyenv install --patch $VERSION < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)
