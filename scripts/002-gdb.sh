#!/bin/bash
# gdb.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

# How we're using a legacy binutils version, gdb is not include inside (it comes after 2.25)

## Download the source code.
REPO_URL="https://github.com/pspdev/binutils-gdb.git"
REPO_FOLDER="gdb"
BRANCH_NAME="allegrex-gdb-v7.5.1"
if test ! -d "$REPO_FOLDER"; then
	git clone --depth 1 -b $BRANCH_NAME $REPO_URL $REPO_FOLDER && cd $REPO_FOLDER || { exit 1; }
else
	cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${BRANCH_NAME} || { exit 1; }
fi

TARGET="psp"
TARG_XTRA_OPTS=""

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## Create and enter the toolchain/build directory
rm -rf build-$TARGET && mkdir build-$TARGET && cd build-$TARGET || { exit 1; }

## Configure the build.
../configure \
  --quiet \
  --prefix="$PSPDEV" \
  --target="$TARGET" \
  --enable-plugins \
  --disable-werror \
  --disable-sim \
  $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet -j $PROC_NR clean || { exit 1; }
make --quiet -j $PROC_NR CFLAGS="$CFLAGS -Wno-implicit-function-declaration" LDFLAGS="$LDFLAGS -s" || { exit 1; }
make --quiet -j $PROC_NR install MAKEINFO=true || { exit 1; } # MAKEINFO=true for disable docs isn't compiling in Alpine
make --quiet -j $PROC_NR clean || { exit 1; }