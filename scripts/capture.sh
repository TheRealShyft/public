#!/bin/bash

source config.txt

airodump-ng -c $channel -w capture $interface --bssid $ap_mac
