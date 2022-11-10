#!/bin/bash


# https://www.linode.com/community/questions/19247/list-of-linodes-ip-ranges

set -euo pipefail
set -x


# get from public ranges
curl -s https://geoip.linode.com/ | grep -v '^#' | cut -d, -f1  > /tmp/linode.txt

# save ipv4
grep -v ':' /tmp/linode.txt > /tmp/linode-ipv4.txt

# save ipv6
grep ':' /tmp/linode.txt > /tmp/linode-ipv6.txt


# sort & uniq
sort -h /tmp/linode-ipv4.txt | uniq > linode/ipv4.txt
sort -h /tmp/linode-ipv6.txt | uniq > linode/ipv6.txt
