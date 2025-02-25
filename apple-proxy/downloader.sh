#!/bin/bash

set -euo pipefail
set -x

# https://developer.apple.com/icloud/prepare-your-network-for-icloud-private-relay/
curl -s https://mask-api.icloud.com/egress-ip-ranges.csv | cut -d',' -f1  > /tmp/apple-proxy.txt

grep -v ':' /tmp/apple-proxy.txt > /tmp/apple-proxy-ipv4.txt
grep ':' /tmp/apple-proxy.txt > /tmp/apple-proxy-ipv6.txt

sort -V /tmp/apple-proxy-ipv4.txt | uniq > apple-proxy/ipv4.txt
sort -V /tmp/apple-proxy-ipv6.txt | uniq > apple-proxy/ipv6.txt
