#!/bin/bash

set -euo pipefail

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
cd $DIR

for f in *.log; do
  echo $f 
  cat $f | grep -P 'SUMMARY|gemmin\i' \
         | tr '\n' ' '  \
         | sed -r 's/gemmini:\s+([0-9]+)\s+[0-9.]+/\1\n/g'; 
  echo " "
done
