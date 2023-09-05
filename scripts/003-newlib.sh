#!/bin/bash
# newlib.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

## Download the source code.
REPO_URL="https://github.com/pspdev/newlib.git"
REPO_FOLDER="newlib"
BRANCH_NAME="allegrex-v4.3.0"
if test ! -d "$REPO_FOLDER"; then
	git clone --depth 1 -b $BRANCH_NAME $REPO_URL && cd $REPO_FOLDER || { exit 1; }
else
	cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${BRANCH_NAME} && git checkout ${BRANCH_NAME} || { exit 1; }
fi

TARGET="psp"

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

# Create and enter the toolchain/build directory
rm -rf build-$TARGET && mkdir build-$TARGET && cd build-$TARGET || { exit 1; }

# Configure the build.
../configure \
	--prefix="$PSPDEV" \
	--target="$TARGET" \
	--enable-newlib-retargetable-locking \
	--enable-newlib-io-c99-formats \
	$TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet -j $PROC_NR clean          || { exit 1; }
make --quiet -j $PROC_NR all            || { exit 1; }
make --quiet -j $PROC_NR install-strip  || { exit 1; }
make --quiet -j $PROC_NR clean          || { exit 1; }
