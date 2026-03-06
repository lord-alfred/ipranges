#!/bin/bash

# https://duckduckgo.com/duckduckgo-help-pages/results/duckassistbot
set -euo pipefail
set -x


# get from public ranges
curl -s https://duckduckgo.com/duckassistbot.json > /tmp/duckassistbot.json


# save ipv4
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/duckassistbot.json > /tmp/duckassistbot-ipv4.txt

# there's no ipv6 known yet
# save ipv6
#jq '.ipv6_prefixes[] | [.ipv6_prefix][] | select(. != null)' -r /tmp/duckassistbot.json > /tmp/duckassistbot-ipv6.txt


# sort & uniq
sort -V /tmp/duckassistbot-ipv4.txt | uniq > duckassistbot/ipv4.txt
# sort -V /tmp/duckassistbot-ipv6.txt | uniq > duckassistbot/ipv6.txt
