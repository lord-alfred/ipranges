#!/bin/bash

# https://docs.vultr.com/vultr-ip-space
# https://geofeed.constant.com/?json

set -euo pipefail
set -x


# get from public ranges
curl -s https://geofeed.constant.com/?text > /tmp/vultr.txt

#save ipv4
REGEX_V4="^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?|0)\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?|0)\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?|0)\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?|0)(\/([1-9]|[1-2][0-9]|3[0-2])){0,1}$"
grep -E $REGEX_V4 /tmp/vultr.txt > /tmp/vultr-ipv4.txt

#save ipv6
REGEX_V6="^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6}))(\/([1-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8])){0,1}$"
grep -E $REGEX_V6 /tmp/vultr.txt > /tmp/vultr-ipv6.txt

# sort & uniq
sort -V /tmp/vultr-ipv4.txt | uniq > vultr/ipv4.txt
sort -V /tmp/vultr-ipv6.txt | uniq > vultr/ipv6.txt
