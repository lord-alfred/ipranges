#!/bin/bash

# https://cloud.google.com/compute/docs/faq#find_ip_range
# From: https://github.com/pierrocknroll/googlecloud-iprange/blob/master/list.sh
# From: https://gist.github.com/jeffmccune/e7d635116f25bc7e12b2a19efbafcdf8

set -euo pipefail
set -x


# get from public ranges
curl -s https://www.gstatic.com/ipranges/goog.txt > /tmp/goog.txt
curl -s https://www.gstatic.com/ipranges/cloud.json > /tmp/cloud.json

# get from netblocks
txt="$(dig TXT _netblocks.google.com +short @8.8.8.8)"
idx=2
while [[ -n "${txt}" ]]; do
  echo "${txt}" | tr '[:space:]+' "\n" | grep ':' | cut -d: -f2- >> /tmp/netblocks.txt
  txt="$(dig TXT _netblocks${idx}.google.com +short @8.8.8.8)"
  ((idx++))
done


# save ipv4
grep -v ':' /tmp/goog.txt > /tmp/google-ipv4.txt
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/cloud.json >> /tmp/google-ipv4.txt
grep -v ':' /tmp/netblocks.txt >> /tmp/google-ipv4.txt

# save ipv6
grep ':' /tmp/goog.txt > /tmp/google-ipv6.txt
jq '.prefixes[] | [.ipv6Prefix][] | select(. != null)' -r /tmp/cloud.json >> /tmp/google-ipv6.txt
grep ':' /tmp/netblocks.txt >> /tmp/google-ipv6.txt


# sort & uniq
sort -hu /tmp/google-ipv4.txt > google/ipv4.txt
sort -hu /tmp/google-ipv6.txt > google/ipv6.txt
