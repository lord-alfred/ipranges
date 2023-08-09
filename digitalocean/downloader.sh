#!/bin/bash

# https://docs.digitalocean.com/products/platform/
# From: https://github.com/nccgroup/cloud_ip_ranges

set -euo pipefail
set -x


# get from public ranges
curl -s https://www.digitalocean.com/geo/google.csv | cut -d, -f1  > /tmp/digitalocean.txt

# save ipv4
grep -v ':' /tmp/digitalocean.txt > /tmp/digitalocean-ipv4.txt

# save ipv6
grep ':' /tmp/digitalocean.txt > /tmp/digitalocean-ipv6.txt


# sort & uniq
sort -V /tmp/digitalocean-ipv4.txt | uniq > digitalocean/ipv4.txt
sort -V /tmp/digitalocean-ipv6.txt | uniq > digitalocean/ipv6.txt
