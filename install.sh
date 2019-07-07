#!/usr/bin/env bash
set -e
wget -O auri https://raw.githubusercontent.com/pwittchen/auri/master/auri.sh
chmod +x auri 
sudo mv auri /usr/local/bin/auri
