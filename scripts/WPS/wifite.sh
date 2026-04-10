#!/bin/bash

source config.txt

wifite --wps-only --bully --reaver --ignore-locks --kill -i $interface
