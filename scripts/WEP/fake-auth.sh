#!/bin/bash

source config.txt

aireplay-ng -1 0 -e $ap_name -a $ap_mac -h $local_mac $interface
