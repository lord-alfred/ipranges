#!/bin/bash

set -euo pipefail
set -x

# get 
curl -s https://core.telegram.org/resources/cidr.txt > /tmp/telegram.txt

# sort & uniq
sort -h /tmp/telegram.txt | uniq > telegram/ipv4.txt
