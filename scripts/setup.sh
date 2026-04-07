#!/bin/bash

read -p "Interface: " interface

ifconfig $interface down
macchanger -A $interface
ifconfig $interface up
airmon-ng start $interface
