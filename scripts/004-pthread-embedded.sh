#!/bin/bash
# pthread-embeedded by pspdev developers

## Exit with code 1 when any command executed returns a non-zero exit code.
onerr()
{
  exit 1;
}
trap onerr ERR

## Read information from the configuration file.
source "$(dirname "$0")/../config/psptoolchain-allegrex-config.sh"

## Download the source code.
REPO_URL="$PSPTOOLCHAIN_ALLEGREX_PTHREAD_EMBEDDED_REPO_URL"
REPO_REF="$PSPTOOLCHAIN_ALLEGREX_PTHREAD_EMBEDDED_DEFAULT_REPO_REF"
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

cd platform/psp

## Compile and install.
make --quiet -j $PROC_NR clean
make --quiet -j $PROC_NR all
make --quiet -j $PROC_NR install
make --quiet -j $PROC_NR clean

# Copy license file
mkdir -p $PSPDEV/psp/share/licenses/pthread-embedded
cp ../../COPYING.* ../../README.md $PSPDEV/psp/share/licenses/pthread-embedded/

## Store build information
BUILD_FILE="${PSPDEV}/build.txt"
if [[ -f "${BUILD_FILE}" ]]; then
  sed -i'' '/^pthread-embedded /d' "${BUILD_FILE}"
fi
git log -1 --format="pthread-embedded %H %cs %s" >> "${BUILD_FILE}"