#!/bin/bash

tshark -r capture-01.cap -Y "eapol.type == 3" -w handshake.cap -F pcap
