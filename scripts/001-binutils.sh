#!/bin/bash
# binutils.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

## Download the source code.
REPO_URL="https://github.com/pspdev/binutils-gdb.git"
REPO_FOLDER="binutils-gdb"
BRANCH_NAME="allegrex-v2.37.0"
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
  $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet -j $PROC_NR clean || { exit 1; }
make --quiet -j $PROC_NR || { exit 1; }
make --quiet -j $PROC_NR install-strip || { exit 1; }
make --quiet -j $PROC_NR clean || { exit 1; }

## Make sure the windows version has the required DLLs
if [ "${OSVER:0:5}" == MINGW ]; then
	cp /mingw64/bin/libwinpthread-1.dll $PSPDEV/bin/
	cp /mingw64/bin/libiconv-2.dll $PSPDEV/bin/
	cp /mingw64/bin/libexpat-1.dll $PSPDEV/bin/
	cp /mingw64/bin/libgmp-10.dll $PSPDEV/bin/
	cp /mingw64/bin/libintl-8.dll $PSPDEV/bin/
fi
