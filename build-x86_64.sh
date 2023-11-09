#!/bin/bash

set -eu

for pck in $(<packages.txt); do
  ./build-package.sh -a x86_64 -o output-x86_64  $pck
done
