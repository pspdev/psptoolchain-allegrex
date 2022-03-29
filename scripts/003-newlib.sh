#!/bin/bash
# newlib.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

## Download the source code.
REPO_URL="https://github.com/pspdev/newlib.git"
REPO_FOLDER="newlib"
BRANCH_NAME="allegrex-v4.1.0"
if test ! -d "$REPO_FOLDER"; then
	git clone --depth 1 -b $BRANCH_NAME $REPO_URL && cd $REPO_FOLDER || { exit 1; }
else
	cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${BRANCH_NAME} && git checkout ${BRANCH_NAME} || { exit 1; }
fi

TARGET="psp"

# MinGW has a different make command
MAKE_CMD="make"
if [ "${OSVER:0:5}" == MINGW ]; then
    MAKE_CMD="mingw32-make"
fi

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

# Create and enter the toolchain/build directory
rm -rf build-$TARGET && mkdir build-$TARGET && cd build-$TARGET || { exit 1; }

# Configure the build.
../configure \
	--prefix="$PSPDEV" \
	--target="$TARGET" \
	$TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
${MAKE_CMD} --quiet -j $PROC_NR clean          || { exit 1; }
${MAKE_CMD} --quiet -j $PROC_NR all            || { exit 1; }
${MAKE_CMD} --quiet -j $PROC_NR install-strip  || { exit 1; }
${MAKE_CMD} --quiet -j $PROC_NR clean          || { exit 1; }
