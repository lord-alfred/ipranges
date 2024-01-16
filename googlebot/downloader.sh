#!/bin/bash

set -euo pipefail
set -x



# Public GoogleBot IP ranges
# From: https://developers.google.com/search/docs/advanced/crawling/verifying-googlebot
curl -s https://developers.google.com/search/apis/ipranges/googlebot.json > /tmp/googlebot.json


# save ipv4
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/googlebot.json >> /tmp/googlebot-ipv4.txt

# save ipv6
jq '.prefixes[] | [.ipv6Prefix][] | select(. != null)' -r /tmp/googlebot.json >> /tmp/googlebot-ipv6.txt


# sort & uniq
sort -V /tmp/googlebot-ipv4.txt | uniq > googlebot/ipv4.txt
sort -V /tmp/googlebot-ipv6.txt | uniq > googlebot/ipv6.txt
