#!/bin/bash

# https://support.google.com/a/answer/60764
# https://cloud.google.com/compute/docs/faq#find_ip_range
# From: https://github.com/pierrocknroll/googlecloud-iprange/blob/master/list.sh
# From: https://gist.github.com/jeffmccune/e7d635116f25bc7e12b2a19efbafcdf8
# From: https://gist.github.com/n0531m/f3714f6ad6ef738a3b0a

set -euo pipefail
set -x



# get from public ranges
curl -s https://www.gstatic.com/ipranges/goog.txt > /tmp/goog.txt
curl -s https://www.gstatic.com/ipranges/cloud.json > /tmp/cloud.json

# Public GoogleBot IP ranges
# From: https://developers.google.com/search/docs/advanced/crawling/verifying-googlebot
curl -s https://developers.google.com/search/apis/ipranges/googlebot.json > /tmp/googlebot.json

# get from netblocks
txt="$(dig TXT _netblocks.google.com +short @8.8.8.8)"
idx=2
while [[ -n "${txt}" ]]; do
  echo "${txt}" | tr '[:space:]+' "\n" | grep ':' | cut -d: -f2- >> /tmp/netblocks.txt
  txt="$(dig TXT _netblocks${idx}.google.com +short @8.8.8.8)"
  ((idx++))
done

# get from other netblocks
get_dns_spf() {
   dig @8.8.8.8 +short txt "$1" |
   tr ' ' '\n' |
   while read entry; do
      case "$entry" in
             ip4:*) echo "${entry#*:}" ;;
             ip6:*) echo "${entry#*:}" ;;
         include:*) get_dns_spf "${entry#*:}" ;;
      esac
   done
}

get_dns_spf "_cloud-netblocks.googleusercontent.com" >> /tmp/netblocks.txt
get_dns_spf "_spf.google.com" >> /tmp/netblocks.txt


# save ipv4
grep -v ':' /tmp/goog.txt > /tmp/google-ipv4.txt
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/cloud.json >> /tmp/google-ipv4.txt
jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/googlebot.json >> /tmp/google-ipv4.txt
grep -v ':' /tmp/netblocks.txt >> /tmp/google-ipv4.txt

# save ipv6
grep ':' /tmp/goog.txt > /tmp/google-ipv6.txt
jq '.prefixes[] | [.ipv6Prefix][] | select(. != null)' -r /tmp/cloud.json >> /tmp/google-ipv6.txt
jq '.prefixes[] | [.ipv6Prefix][] | select(. != null)' -r /tmp/googlebot.json >> /tmp/google-ipv6.txt
grep ':' /tmp/netblocks.txt >> /tmp/google-ipv6.txt


# sort & uniq
sort -V /tmp/google-ipv4.txt | uniq > google/ipv4.txt
sort -V /tmp/google-ipv6.txt | uniq > google/ipv6.txt
