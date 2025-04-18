#!/bin/bash
if [ "$EUID" != 0 ]; then
    echo "Elevating to root so packages can be installed"
    sudo "$0"
    exit $?
fi

# Install build dependencies
apt-get update
apt-get install -y file bison make flex texinfo gettext g++ gcc git libgmp3-dev libmpfr-dev libmpc-dev libncurses5-dev libreadline-dev
