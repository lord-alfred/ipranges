#!/bin/bash

set -euo pipefail
set -x

# get ranges from statuscake
curl -s "https://app.statuscake.com/Workfloor/Locations.php?format=txt" > /tmp/statuscake-ipv4.txt

# sort & uniq
sort -V /tmp/statuscake-ipv4.txt | uniq > statuscake/ipv4.txt
