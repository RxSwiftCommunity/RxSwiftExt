#!/bin/sh

set -e

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Get previous checksum
mkdir -p "Carthage"
touch "Carthage/cartSum.txt"
if [ ! -f "Carthage/cartSum.txt" ]; then
    prevSum="null";
else
    prevSum=`cat Carthage/cartSum.txt`;
fi

# Get checksum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`

if [ "$prevSum" != "$cartSum" ] || [ ! -d "Carthage/Build/iOS" ]; then
  printf "${RED}Dependencies out of date with cache.${NC} Bootstrapping...\n"
  scripts/bootstrap.sh
else
  printf "${GREEN}Cache up-to-date.${NC} Skipping bootstrap...\n"
fi
