#!/bin/bash

read -p "AP name: " ap_name
read -p "AP MAC: " ap_mac
read -p "Channel: " channel
read -p "Client MAC: " client_mac
read -p "Local MAC: " local_mac
read -p "Interface: " interface

cat > config.txt << EOF
ap_name="$ap_name"
ap_mac=$ap_mac
channel=$channel
client_mac=$client_mac
local_mac=$local_mac
interface=$interface
EOF

echo "Variables saved to config.txt"
