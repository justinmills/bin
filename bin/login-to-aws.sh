#! /bin/bash

# Script to login to all of our AWS accounts
set -e

username=justin.mills@ellevationeducation.com
password=`keychain jumpcloud`
mfa="unset"

ACCOUNTS="feature prod"
for account in  $ACCOUNTS ; do
    echo
    echo "Logging into $account..."

    # Fetch a mfa (or a new one if this one we just used - cannot reuse them with AWS)
    new_mfa=`mfa mfa-jumpcloud`
    while [ "$new_mfa" = "$mfa" ] ; do
        echo "Waiting for mfa to rollover from $mfa"
        sleep 1
        new_mfa=`mfa mfa-jumpcloud`
    done
    mfa=$new_mfa

    # useful for debugging, but note this echos your password out!
    # echo $username $password $mfa

    # use --force to test this out or if something is haywire and you need to not wait for the
    # normal 24h expiration period.
    saml2aws login --skip-prompt "--idp-account=$account" "--username=$username" "--password=$password" "--mfa-token=$mfa"
    echo
done
