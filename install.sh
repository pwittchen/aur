#!/usr/bin/env bash
set -e
wget -O aur https://raw.githubusercontent.com/pwittchen/auri/master/aur.sh
chmod +x aur
sudo mv aur /usr/local/bin/aur
