#!/bin/bash
git clone https://github.com/TheRealShyft/public || git -C public pull
mkdir -p output && chmod 755 output
