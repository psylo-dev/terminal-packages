#!/bin/bash

set -eu

packages=$(<packages.txt)

for pck in $(<packages.txt); do
  if [ -f "/data/data/.built-packages/$pck" ]; then
    echo "Skipping $pck as it is already built"
    continue
  fi
  ./build-package.sh -a arm -o output-arm $pck
done
