#!/bin/bash

# https://www.bing.com/webmasters/help/verify-bingbot-2195837f

set -euo pipefail
set -x


# get from public ranges
curl -s https://www.bing.com/toolbox/bingbot.json > /tmp/bing.json


# save ipv4
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/bing.json > /tmp/bing-ipv4.txt

# ipv6 not provided


# sort & uniq
sort -h /tmp/bing-ipv4.txt | uniq > bing/ipv4.txt
