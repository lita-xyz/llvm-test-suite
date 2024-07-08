#!/bin/bash

# !!!README!!!
# The script assumes that:
#   - file ./build/runtime.o is present
#   - `LINKER_SCRIPT` env var is set to absolute path to linker script
#   - PATH contains path to a directory to bin directory of llvm-valida build
#
# The script builds csmith testcases for x86 and for delendum arch.
# The latter is built with 3 different optimization levels.
# Then all 4 programs are run and it's checked that their output is the same.
#
# At the end of a csmith program a hash of the program's state is computed and printed.

set -e

rm -rf build/test_* || true
rm -rf build/log_* || true

src=$1
if [[ ! -f "$src" ]]
then
    echo "File does not exist"
    exit 1
fi

echo "File under test: $src"

echo "Compiling fox x86"

clang -Wno-everything -std=c11 -O3 -g -nostdinc -I. -Icsmith -Icsmith/X86 $src -o build/test_x86

opts="-std=c11 -target delendum -I. -Icsmith -Icsmith/Delendum"
optsw="$opts -Wno-everything"

echo "Compiling for Delendum"

echo "  Compiling testcases with different opt levels"

ld="--script=$LINKER_SCRIPT"

# Compilation with -O0 is disabled because it produces code that requires `__umoddi3` and other

for optlevel in {1..3}; do
  clang $optsw -O$optlevel -c $src -o build/test_O$optlevel.o
  ld.lld $ld \
    -o build/test_O$optlevel.out \
    build/runtime.o build/test_O$optlevel.o
done

echo "Executing x86 binary"

x86_hash=$(./build/test_x86 | xxd -p)

echo "Executing Valida binaries at different opt levels"

for optlevel in {1..3}; do
  valida run build/test_O$optlevel.out build/log_O$optlevel
  declare valida_O$optlevel\_hash=$(cat build/log_O$optlevel | xxd -p)
done

if [ "$x86_hash" == "$valida_O1_hash" ] && \
   true \ #[ "$valida_O0_hash" == "$valida_O1_hash" ] && \
   [ "$valida_O1_hash" == "$valida_O2_hash" ] && \
   [ "$valida_O2_hash" ==  "$valida_O3_hash" ]
  then
    echo "TEST PASSED with: $x86_hash"
    exit 0
  else
    echo "!! TEST FAILED !!"
    echo "$x86_hash, $valida_O1_hash, $valida_O2_hash, $valida_O3_hash"
    exit 1
  fi

