#! /bin/bash

# Dumb little script to check whether or not a website is available
#
# Can be useful with run-til-it-fails.sh to check a site
#
# run-til-it-fails.sh check-site-availability.sh https://www.google.com ; say "Google is no longer available" ; dialog "Google is down 😱"
#
SITE="${1:-https://www.google.com}"
echo "Checking $SITE"

# curl flags
# -s = Silent cURL's output
# -L = Follow redirects
# -w = Custom output format
# -o = Redirects the HTML output to /dev/null
code=`curl -sL -w "%{http_code}\n" "${SITE}" -o /dev/null --max-time 5`

if [ "$code" = 200 ] ; then
   exit 0
fi

echo "Status Code: $code - site not available"
exit 7
