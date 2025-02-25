#!/bin/bash


# https://platform.openai.com/docs/gptbot

set -euo pipefail
set -x


# get from public ranges
download_and_parse_json() {
    curl --connect-timeout 60 --retry 3 --retry-delay 15 -s "${1}" \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
    -H 'accept-language: en' \
    -H 'cache-control: no-cache' \
    -H 'pragma: no-cache' \
    -H 'priority: u=0, i' \
    -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "macOS"' \
    -H 'sec-fetch-dest: document' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-site: none' \
    -H 'sec-fetch-user: ?1' \
    -H 'upgrade-insecure-requests: 1' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
    > /tmp/openai.json

    jq '.prefixes[] | [.ipv4Prefix][] | select(. != null)' -r /tmp/openai.json > /tmp/openai.txt

    # save ipv4
    grep -v ':' /tmp/openai.txt >> /tmp/openai-ipv4.txt

    # ipv6 not provided

    sleep 10
}

download_and_parse_json "https://openai.com/chatgpt-user.json"
download_and_parse_json "https://openai.com/searchbot.json"
download_and_parse_json "https://openai.com/gptbot.json"


# sort & uniq
sort -V /tmp/openai-ipv4.txt | uniq > openai/ipv4.txt
