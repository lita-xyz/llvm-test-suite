#!/bin/bash

# !!!README!!!
# The script assumes that:
#   - file ./build/runtime.o is present
#   - `LINKER_SCRIPT` env var is set to absolute path to linker script
#   - PATH contains path to a directory to bin directory of llvm-valida build
#   - gcc-multilib is installed
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

clang -Wno-everything -std=c11 -m32 -O3 -g -nostdinc -I. -Icsmith -Icsmith/X86 $src -o build/test_x86

opts="-std=c11 -target delendum -I. -Icsmith -Icsmith/Delendum"
optsw="$opts -Wno-everything"

echo "Compiling for Delendum"

echo "  Compiling testcases with different opt levels"

clang $optsw -O3 -c $src -o build/test_O3.o
clang $optsw -O2 -c $src -o build/test_O2.o
clang $optsw -O1 -c $src -o build/test_O1.o
#clang $optsw -O0 -c $src -o build/test_O0.o

# Compilation with -O0 is disabled because it produces code that requires `__umoddi3` and other

ld="--script=$LINKER_SCRIPT"

ld.lld $ld -o build/test_O3.out \
	build/runtime.o build/test_O3.o
ld.lld $ld -o build/test_O2.out \
	build/runtime.o build/test_O2.o 
ld.lld $ld -o build/test_O1.out \
	build/runtime.o build/test_O1.o 
#ld.lld $ld -o build/test_O0.out \
#	build/runtime.o build/test_O0.o 

echo "Executing x86 binary"

x86_hash=$(./build/test_x86 | xxd -p)

echo "Executing TinyRAM binaries at different opt levels"

valida run build/test_O3.out build/log_O3
valida run build/test_O2.out build/log_O2
valida run build/test_O1.out build/log_O1
#valida run build/test_O0.out build/log_O0

#tinyRAM_O0_hash=$(cat build/log_O0 | xxd -p)
tinyRAM_O1_hash=$(cat build/log_O1 | xxd -p)
tinyRAM_O2_hash=$(cat build/log_O2 | xxd -p)
tinyRAM_O3_hash=$(cat build/log_O3 | xxd -p)

if [ "$x86_hash" == "$tinyRAM_O1_hash" ] && \
   true \ #[ "$tinyRAM_O0_hash" == "$tinyRAM_O1_hash" ] && \
   [ "$tinyRAM_O1_hash" == "$tinyRAM_O2_hash" ] && \
   [ "$tinyRAM_O2_hash" ==  "$tinyRAM_O3_hash" ]
  then
    echo "TEST PASSED with: $x86_hash"
    exit 0
  else
    echo "!! TEST FAILED !!"
    echo "$x86_hash, $tinyRAM_O1_hash, $tinyRAM_O2_hash, $tinyRAM_O3_hash"
    exit 1
  fi

