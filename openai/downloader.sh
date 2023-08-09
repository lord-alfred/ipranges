#!/bin/bash


# https://platform.openai.com/docs/gptbot

set -euo pipefail
set -x


# get from public ranges
curl -s https://openai.com/gptbot-ranges.txt > /tmp/openai.txt

# save ipv4
grep -v ':' /tmp/openai.txt > /tmp/openai-ipv4.txt

# ipv6 not provided


# sort & uniq
sort -V /tmp/openai-ipv4.txt | uniq > openai/ipv4.txt
