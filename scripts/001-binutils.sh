#!/bin/bash
# binutils by pspdev developers

## Exit with code 1 when any command executed returns a non-zero exit code.
onerr()
{
  exit 1;
}
trap onerr ERR

## Read information from the configuration file.
source "$(dirname "$0")/../config/psptoolchain-allegrex-config.sh"

## Download the source code.
REPO_URL="$PSPTOOLCHAIN_ALLEGREX_BINUTILS_REPO_URL"
REPO_REF="$PSPTOOLCHAIN_ALLEGREX_BINUTILS_DEFAULT_REPO_REF"
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
TARG_XTRA_OPTS=""

## If using MacOS Apple, set gmp and mpfr paths using TARG_XTRA_OPTS 
## (this is needed for Apple Silicon but we will do it for all MacOS systems)
if [ "$(uname -s)" = "Darwin" ]; then
  ## Check if using brew
  if command -v brew &> /dev/null; then
    TARG_XTRA_OPTS="--with-gmp=$(brew --prefix gmp) --with-mpfr=$(brew --prefix mpfr)"
  fi
  ## Check if using MacPorts
  if command -v port &> /dev/null; then
    TARG_XTRA_OPTS="--with-gmp=$(port -q prefix gmp) --with-mpfr=$(port -q prefix mpfr)"
  fi
fi

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## Create and enter the toolchain/build directory
rm -rf build-$TARGET && mkdir build-$TARGET && cd build-$TARGET

## Build GDB without python support by default
## Set the environment variable WITH_PYTHON to auto to change this
WITH_PYTHON="${WITH_PYTHON:-no}"

## Configure the build.
../configure \
  --quiet \
  --prefix="$PSPDEV" \
  --target="$TARGET" \
  --with-sysroot="$PSPDEV/$TARGET" \
  --enable-plugins \
  --disable-initfini-array \
  --with-python="$WITH_PYTHON" \
  --disable-werror \
  --with-system-readline \
  $TARG_XTRA_OPTS

## Compile and install.
make --quiet -j $PROC_NR clean
make --quiet -j $PROC_NR all
make --quiet -j $PROC_NR install-strip
make --quiet -j $PROC_NR clean

## Store build information
BUILD_FILE="${PSPDEV}/build.txt"
if [[ -f "${BUILD_FILE}" ]]; then
  sed -i'' '/^binutils /d' "${BUILD_FILE}"
fi
git log -1 --format="binutils %H %cs %s" >> "${BUILD_FILE}"
