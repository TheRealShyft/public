#!/bin/bash

source config.txt

wash -i $interface -c $channel --ignore-fcs
