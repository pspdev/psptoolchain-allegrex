#!/bin/bash

# Install build dependencies
sudo dnf install $@ \
  gcc gcc-c++ make git gettext texinfo bison flex gmp-devel mpfr-devel libmpc-devel \
  ncurses-devel diffutils
