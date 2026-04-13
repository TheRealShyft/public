#!/bin/bash

read -p "Interface: (not mon)" interface

hcxdumptool -i $interface -w pmkid.pcapng --rds=1
