#!/bin/bash

# https://www.cloudflare.com/ips/

set -euo pipefail
set -x



# get from public ranges
curl -s https://www.cloudflare.com/ips-v4/ > /tmp/cf-ipv4.txt
curl -s https://www.cloudflare.com/ips-v6/ > /tmp/cf-ipv6.txt


# sort & uniq
sort -V /tmp/cf-ipv4.txt | uniq > cloudflare/ipv4.txt
sort -V /tmp/cf-ipv6.txt | uniq > cloudflare/ipv6.txt
