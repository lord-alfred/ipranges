#!/bin/bash

# https://docs.vultr.com/vultr-ip-space
# https://geofeed.constant.com/?json

set -euo pipefail
set -x


# get from public ranges
curl -s https://geofeed.constant.com/?text > /tmp/vultr.txt

#save ipv4
grep -v ':' /tmp/vultr.txt > /tmp/vultr-ipv4.txt

#save ipv6
grep ':' /tmp/vultr.txt > /tmp/vultr-ipv6.txt

# sort & uniq
sort -V /tmp/vultr-ipv4.txt | uniq > vultr/ipv4.txt
sort -V /tmp/vultr-ipv6.txt | uniq > vultr/ipv6.txt
