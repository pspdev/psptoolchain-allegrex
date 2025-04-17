#!/bin/bash
if [ "$EUID" != 0 ]; then
    echo "Elevating to root so packages can be installed"
    sudo "$0"
    exit $?
fi

# Install build dependencies
dnf -y install gcc gcc-c++ make git gettext texinfo bison flex gmp-devel mpfr-devel libmpc-devel \
    ncurses-devel diffutils glibc-gconv-extra which gawk file readline-devel
