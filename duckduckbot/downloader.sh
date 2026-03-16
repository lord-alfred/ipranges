#!/bin/bash

# https://duckduckgo.com/duckduckgo-help-pages/results/duckduckbot

set -euo pipefail
set -x


# get from public ranges
curl -s https://duckduckgo.com/duckduckbot.json > /tmp/duckduckbot.json


# save ipv4
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/duckduckbot.json > /tmp/duckduckbot-ipv4.txt

# there's no ipv6 known yet
# save ipv6
#jq '.ipv6_prefixes[] | [.ipv6_prefix][] | select(. != null)' -r /tmp/duckduckbot.json > /tmp/duckduckbot-ipv6.txt


# sort & uniq
sort -V /tmp/duckduckbot-ipv4.txt | uniq > duckduckbot/ipv4.txt
# sort -V /tmp/duckduckbot-ipv6.txt | uniq > duckduckbot/ipv6.txt
