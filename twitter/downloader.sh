#!/bin/bash


# https://www.irr.net/docs/list.html
# https://bgp.he.net/search?search%5Bsearch%5D=twitter&commit=Search
# https://github.com/SecOps-Institute/TwitterIPLists/blob/master/twitter_asn_list.lst

set -euo pipefail
set -x


# get from Autonomous System
get_routes() {
    whois -h riswhois.ripe.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
}

get_routes 'AS13414' > /tmp/twitter.txt || echo 'failed'
get_routes 'AS35995' >> /tmp/twitter.txt || echo 'failed'
get_routes 'AS54888' >> /tmp/twitter.txt || echo 'failed'
get_routes 'AS63179' >> /tmp/twitter.txt || echo 'failed'


# save ipv4
grep -v ':' /tmp/twitter.txt > /tmp/twitter-ipv4.txt

# save ipv6
grep ':' /tmp/twitter.txt > /tmp/twitter-ipv6.txt


# sort & uniq
sort -V /tmp/twitter-ipv4.txt | uniq > twitter/ipv4.txt
sort -V /tmp/twitter-ipv6.txt | uniq > twitter/ipv6.txt
