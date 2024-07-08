#!/bin/bash

# install gcc-multilib
# sudo apt install gcc-multilib

mkdir -p build

echo "Compile runtime"

./compile_runtime.sh

echo "TIER 1 testing"

for file in testcases_tier1/*.c
do
  ./compile_run.sh $file
  echo ""
done

echo "TIER 2 testing"

for file in testcases_tier2/*.c
do
  ./compile_run.sh $file
  echo ""
done
