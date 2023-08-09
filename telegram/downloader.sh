#!/bin/bash

set -euo pipefail
set -x

# get ranges from telegram
curl -s https://core.telegram.org/resources/cidr.txt > /tmp/telegram.txt

# seperate IPv4 and IPv6, sort an uniq
grep -v ':' /tmp/telegram.txt | sort -V | uniq > telegram/ipv4.txt
grep ':' /tmp/telegram.txt | sort -V | uniq > telegram/ipv6.txt
