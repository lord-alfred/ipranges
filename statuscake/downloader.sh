#!/bin/bash

set -euo pipefail
set -x

# get ranges from statuscake
curl -s "https://app.statuscake.com/Workfloor/Locations.php?format=txt" > statuscake/ipv4.txt
