#!/bin/bash

set -euo pipefail
set -x

# get ranges from telegram
curl -s https://core.telegram.org/resources/cidr.txt > /tmp/telegram.txt

# seperate IPv4 and IPv6
while IFS= read -r line; do
  if [[ $line == *:* ]]; then
    echo "$line" >> /tmp/telegram-ipv6.txt
  else
    echo "$line" >> /tmp/telegram-ipv4.txt
  fi
done < /tmp/telegram.txt

# sort & uniq
sort -h /tmp/telegram-ipv4.txt | uniq > ipv4.txt
sort -h /tmp/telegram-ipv6.txt | uniq > ipv6.txt
