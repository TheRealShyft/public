#!/bin/bash

source config.txt

airbase-ng -e $ap_name -c $channel -a $ap_mac -Z 2 -W 1 $interface
