#!/bin/bash

# https://support.google.com/a/answer/60764
# https://cloud.google.com/compute/docs/faq#find_ip_range
# From: https://github.com/pierrocknroll/googlecloud-iprange/blob/master/list.sh
# From: https://gist.github.com/jeffmccune/e7d635116f25bc7e12b2a19efbafcdf8
# From: https://gist.github.com/n0531m/f3714f6ad6ef738a3b0a

# Script to retrieve and organize Google and Google Cloud IP ranges.

set -euo pipefail
set -x

# Check for required dependencies
for cmd in curl dig jq mktemp; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: $cmd is not installed or not in PATH" >&2
    exit 1
  fi
done

# Create a temporary directory and ensure cleanup on exit
temp_dir=$(mktemp -d)
trap 'rm -rf -- "$temp_dir"' EXIT

# Function to download files with retries and error handling
download_file() {
  local url=$1
  local output_file=$2
  local retries=3
  local count=0
  until curl -s "$url" -o "$output_file"; do
    count=$((count + 1))
    if [[ $count -ge $retries ]]; then
      echo "Error: Failed to download $url after $retries attempts"
      exit 1
    fi
    sleep 2  # wait before retrying
  done
}

# Parallel downloads with retries
download_file "https://www.gstatic.com/ipranges/goog.txt" "$temp_dir/goog.txt" &
download_file "https://www.gstatic.com/ipranges/cloud.json" "$temp_dir/cloud.json" &
download_file "https://developers.google.com/search/apis/ipranges/googlebot.json" "$temp_dir/googlebot.json" &
wait  # Ensure all downloads finish

# Fetch Google netblocks using dig command
fetch_netblocks() {
  local idx=2
  local txt
  txt="$(dig TXT _netblocks.google.com +short @8.8.8.8 || true)"
  while [[ -n "$txt" ]]; do
    echo "$txt" | tr '[:space:]+' "\n" | grep ':' | cut -d: -f2- >> "$temp_dir/netblocks.txt"
    txt="$(dig TXT _netblocks${idx}.google.com +short @8.8.8.8 || true)"
    ((idx++))
  done
}

fetch_netblocks

# Function to resolve DNS SPF records recursively with validation
get_dns_spf() {
   dig @8.8.8.8 +short txt "$1" |
   tr ' ' '\n' |
   while read -r entry; do
      case "$entry" in
         ip4:*) echo "${entry#*:}" ;;
         ip6:*) echo "${entry#*:}" ;;
         include:*) get_dns_spf "${entry#*:}" ;;
      esac
   done || {
     echo "Error: Failed to fetch DNS SPF records for $1"
     exit 1
   }
}

# Fetch additional SPF-based netblocks with error handling
get_dns_spf "_cloud-netblocks.googleusercontent.com" >> "$temp_dir/netblocks.txt"
get_dns_spf "_spf.google.com" >> "$temp_dir/netblocks.txt"

# Separate IPv4 and IPv6 ranges
grep -v ':' "$temp_dir/goog.txt" > "$temp_dir/google-ipv4.txt"
jq -r '.prefixes[] | select(.ipv4Prefix != null) | .ipv4Prefix' "$temp_dir/cloud.json" >> "$temp_dir/google-ipv4.txt"
jq -r '.prefixes[] | select(.ipv4Prefix != null) | .ipv4Prefix' "$temp_dir/googlebot.json" >> "$temp_dir/google-ipv4.txt"
grep -v ':' "$temp_dir/netblocks.txt" >> "$temp_dir/google-ipv4.txt"

grep ':' "$temp_dir/goog.txt" > "$temp_dir/google-ipv6.txt"
jq -r '.prefixes[] | select(.ipv6Prefix != null) | .ipv6Prefix' "$temp_dir/cloud.json" >> "$temp_dir/google-ipv6.txt"
jq -r '.prefixes[] | select(.ipv6Prefix != null) | .ipv6Prefix' "$temp_dir/googlebot.json" >> "$temp_dir/google-ipv6.txt"
grep ':' "$temp_dir/netblocks.txt" >> "$temp_dir/google-ipv6.txt"

# Sort and deduplicate results, and ensure target directory exists
output_dir="google"
mkdir -p "$output_dir"
sort -u "$temp_dir/google-ipv4.txt" > "$output_dir/ipv4.txt"
sort -u "$temp_dir/google-ipv6.txt" > "$output_dir/ipv6.txt"

# Verify files are written correctly
if [[ ! -s "$output_dir/ipv4.txt" || ! -s "$output_dir/ipv6.txt" ]]; then
  echo "Error: Output files are empty or failed to generate."
  exit 1
fi

echo "IP ranges saved in $output_dir/ipv4.txt and $output_dir/ipv6.txt"
