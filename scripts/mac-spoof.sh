#!/bin/bash

source config.txt
read -p "Interface: (not mon)" int

airmon-ng stop $interface
ifconfig $int down
macchanger -m $client_mac $int
ifconfig $int up
airmon-ng start $int
