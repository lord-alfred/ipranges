#!/bin/bash

set -euo pipefail
set -x

# get ranges from pingdom
curl -s https://my.pingdom.com/probes/ipv4 > pingdom/ipv4.txt
curl -s https://my.pingdom.com/probes/ipv6 > pingdom/ipv6.txt
