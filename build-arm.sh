#!/bin/bash

set -eu

packages=$(<packages.txt)

for pck in $(<packages.txt); do
  ./build-package.sh -a arm -o output-arm -I $pck
done
