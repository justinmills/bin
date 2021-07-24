#! /bin/bash

# Given a pem ssh key (AWS key pair) and you need to find the fingerprint of it so I could make sure
# it was the one that is listed in the AWS console, I ran across this:
#
# ref: http://naoko.github.io/fingerprint-of-pem/
#

FILE="$1"
if [ -z "$FILE" ] ; then
    >&2 echo "Usage: $0 <path-to-private-key>"
    exit 1
fi
openssl pkcs8 -in "${FILE}" -nocrypt -topk8 -outform DER | openssl sha1 -c
