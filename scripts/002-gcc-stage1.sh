#!/bin/bash
# gcc-stage1 by pspdev developers

## Exit with code 1 when any command executed returns a non-zero exit code.
onerr()
{
  exit 1;
}
trap onerr ERR

## Read information from the configuration file.
source "$(dirname "$0")/../config/psptoolchain-allegrex-config.sh"

## Download the source code.
REPO_URL="$PSPTOOLCHAIN_ALLEGREX_GCC_REPO_URL"
REPO_REF="$PSPTOOLCHAIN_ALLEGREX_GCC_DEFAULT_REPO_REF"
REPO_FOLDER="$(s="$REPO_URL"; s=${s##*/}; printf "%s" "${s%.*}")"

# Checking if a specific Git reference has been passed in parameter $1
if test -n "$1"; then
  REPO_REF="$1"
  printf 'Using specified repo reference %s\n' "$REPO_REF"
fi

if test ! -d "$REPO_FOLDER"; then
  git clone --depth 1 -b "$REPO_REF" "$REPO_URL" "$REPO_FOLDER"
else
  git -C "$REPO_FOLDER" fetch origin
  git -C "$REPO_FOLDER" reset --hard "origin/$REPO_REF"
  git -C "$REPO_FOLDER" checkout "$REPO_REF"
fi

cd "$REPO_FOLDER"

TARGET="psp"

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## If using MacOS Apple, set gmp, mpfr and mpc paths using TARG_XTRA_OPTS 
## (this is needed for Apple Silicon but we will do it for all MacOS systems)
if [ "$(uname -s)" = "Darwin" ]; then
  ## Check if using brew
  if command -v brew &> /dev/null; then
    TARG_XTRA_OPTS="--with-gmp=$(brew --prefix gmp) --with-mpfr=$(brew --prefix mpfr) --with-mpc=$(brew --prefix libmpc)"
  fi
  ## Check if using MacPorts
  if command -v port &> /dev/null; then
    TARG_XTRA_OPTS="--with-gmp=$(port -q prefix gmp) --with-mpfr=$(port -q prefix mpfr) --with-mpc=$(port -q prefix libmpc)"
  fi
fi

## Create and enter the toolchain/build directory
rm -rf build-$TARGET-stage1
mkdir build-$TARGET-stage1
cd build-$TARGET-stage1

## Configure the build.
../configure -C \
  --quiet \
  --prefix="$PSPDEV" \
  --target="$TARGET" \
  --enable-languages="c" \
  --with-float=hard \
  --with-headers=no \
  --without-newlib \
  --disable-libgcc \
  --disable-shared \
  --disable-threads \
  --disable-libssp \
  --disable-libgomp \
  --disable-libmudflap \
  --disable-libquadmath \
  --disable-dependency-tracking \
  $TARG_XTRA_OPTS

## Compile and install.
make --quiet -j $PROC_NR clean
make --quiet -j $PROC_NR all-gcc
make --quiet -j $PROC_NR install-gcc
make --quiet -j $PROC_NR clean
