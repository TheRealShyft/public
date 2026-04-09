#!/bin/bash

source config.txt
read -p "Interface: " interface

airmon-ng stop wlan1mon
ifconfig $interface down
macchanger -m $client_mac $interface
ifconfig $interface up
airmon-ng start $interface
