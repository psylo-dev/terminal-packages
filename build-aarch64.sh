#!/bin/bash

set -eu

for pck in $(<packages.txt); do
  if [ -f "/data/data/.built-packages/$pck" ]; then
    echo "Skipping $pck as it is already built"
    continue
  fi
  ./build-package.sh -a aarch64 -o -I output-aarch64 $pck
done
