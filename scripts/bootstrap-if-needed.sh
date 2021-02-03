#!/bin/sh

set -e

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

checksum_file="Carthage/cartSum.txt"

# Computes current Carthage checksum using 'Cartfile.resolved' file, Swift version and checksum version.
computeChecksum() {
    local version="1"
    { cat Cartfile.resolved; xcrun swift -version; echo "${version}"; } | md5
}

# Get previous checksum
mkdir -p "Carthage"
touch "${checksum_file}"
if [ ! -f "${checksum_file}" ]; then
    prevSum="null";
else
    prevSum=`cat Carthage/cartSum.txt`;
fi

# Get checksum
cartSum=`computeChecksum`

if [ "$prevSum" != "$cartSum" ] || [ ! -d "Carthage/Build/iOS" ]; then
  printf "${RED}Dependencies out of date with cache.${NC} Bootstrapping...\n"
  rm -rf Carthage
  scripts/bootstrap.sh

  echo `computeChecksum` > "${checksum_file}"

else
  printf "${GREEN}Cache up-to-date.${NC} Skipping bootstrap...\n"
fi
