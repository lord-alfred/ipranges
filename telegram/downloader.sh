#!/bin/bash

set -euo pipefail
set -x

# get 
curl -s https://core.telegram.org/resources/cidr.txt > /tmp/telegram.txt

# seperate IPv4 and IPv6
while read line; do
  if [[ $line == *:* ]]; then
    echo "$line" >> /tmp/telegram-ipv6.txt
  else
    echo "$line" >> /temp/telegram-ipv4.txt
  fi
done < /tmp/telegram.txt

# sort & uniq
sort -h /tmp/telegram-ipv4.txt | uniq > telegram/ipv4.txt
sort -h /tmp/telegram-ipv6.txt | uniq > telegram/ipv6.txt
