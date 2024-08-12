#!/bin/bash

# https://docs.vultr.com/vultr-ip-space
# https://geofeed.constant.com/?json

set -euo pipefail
set -x


# get from public ranges
curl -s https://geofeed.constant.com/?json > /tmp/vultr.json


# save ipv4
jq '.prefixes[] | [.ip_prefix][] | select(. != null)' -r /tmp/vultr.json > /tmp/vultr-ipv4.txt

# save ipv6
jq '.ipv6_prefixes[] | [.ipv6_prefix][] | select(. != null)' -r /tmp/vultr.json > /tmp/vultr-ipv6.txt


# sort & uniq
sort -V /tmp/vultr-ipv4.txt | uniq > vultr/ipv4.txt
sort -V /tmp/vultr-ipv6.txt | uniq > vultr/ipv6.txt
