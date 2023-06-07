#!/bin/bash

# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses

set -euo pipefail
set -x


# get from public ranges
curl -s https://api.github.com/meta > /tmp/github.json


# get all prefixes without some keys
jq 'del(.["ssh_keys", "verifiable_password_authentication", "ssh_key_fingerprints", "domains"]) | .[] | .[]' -r /tmp/github.json > /tmp/github-all.txt


# save ipv4
grep -v ':' /tmp/github-all.txt > /tmp/github-ipv4.txt

# save ipv6
grep ':' /tmp/github-all.txt > /tmp/github-ipv6.txt


# sort & uniq
sort -h /tmp/github-ipv4.txt | uniq > github/ipv4.txt
sort -h /tmp/github-ipv6.txt | uniq > github/ipv6.txt
