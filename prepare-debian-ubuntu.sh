#!/bin/bash

# Install build dependencies
sudo apt-get install $@ \
  file bison make flex texinfo gettext g++ gcc git libgmp3-dev libmpfr-dev libmpc-dev libncurses5-dev
