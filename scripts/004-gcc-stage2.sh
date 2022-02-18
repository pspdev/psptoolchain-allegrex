#!/bin/bash
# gcc-stage2.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

## Download the source code.
REPO_URL="https://github.com/pspdev/gcc.git"
REPO_FOLDER="gcc"
BRANCH_NAME="allegrex-v11.2.0"
if test ! -d "$REPO_FOLDER"; then
	git clone --depth 1 -b $BRANCH_NAME $REPO_URL && cd $REPO_FOLDER || { exit 1; }
else
	cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${BRANCH_NAME} || { exit 1; }
fi

TARGET="psp"
OSVER=$(uname)

## Apple needs to pretend to be linux
if [ ${OSVER:0:6} == Darwin ]; then
	TARG_XTRA_OPTS="--build=i386-linux-gnu --host=i386-linux-gnu"
else
	TARG_XTRA_OPTS=""
fi

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## Create and enter the toolchain/build directory
rm -rf build-$TARGET-stage2 && mkdir build-$TARGET-stage2 && cd build-$TARGET-stage2 || { exit 1; }

## Configure the build.
../configure \
  --quiet \
  --prefix="$PSPDEV" \
  --target="$TARGET" \
  --enable-languages="c,c++" \
  --with-float=hard \
  --with-newlib \
  --disable-libssp \
  --disable-multilib \
  --enable-cxx-flags=-G0 \
  $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet -j $PROC_NR clean          || { exit 1; }
make --quiet -j $PROC_NR all            || { exit 1; }
make --quiet -j $PROC_NR install-strip  || { exit 1; }
make --quiet -j $PROC_NR clean          || { exit 1; }

## Make sure the windows version has the required DLLs
if [ "${OSVER:0:5}" == MINGW ]; then
	cp /usr/bin/libwinpthread-1.dll $PSPDEV/bin/
	cp /usr/bin/libiconv-2.dll $PSPDEV/bin/
	cp /usr/bin/libintl-8.dll $PSPDEV/bin/
fi
