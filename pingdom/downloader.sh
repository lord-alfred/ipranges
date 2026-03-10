#!/bin/bash

set -euo pipefail
set -x

# get ranges from pingdom
curl -s https://my.pingdom.com/probes/ipv4 > /tmp/pingdom-ipv4.txt
curl -s https://my.pingdom.com/probes/ipv6 > /tmp/pingdom-ipv6.txt

# sort & uniq
sort -V /tmp/pingdom-ipv4.txt | uniq > pingdom/ipv4.txt
sort -V /tmp/pingdom-ipv6.txt | uniq > pingdom/ipv6.txt
