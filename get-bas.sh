#!/usr/bin/env bash
apt update
apt install -y build-essential socat
git clone https://github.com/Ankr-network/bas-devnet-setup bas --recursive
cd bas
make all