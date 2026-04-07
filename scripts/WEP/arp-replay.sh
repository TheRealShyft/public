#!/bin/bash

source config.txt

aireplay-ng -3 -b $ap_mac -h $local_mac $interface
