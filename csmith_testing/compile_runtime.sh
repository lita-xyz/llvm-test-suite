#!/bin/bash

set -e

opts="-O3 -target delendum -I."

clang $opts -c -nostdlib runtime/DelendumEntryPoint.c -o build/DelendumEntryPoint.o
clang $opts -c -nostdlib runtime/memcpy.c -o build/memcpy.o
clang $opts -c -nostdlib runtime/builtins.c -o build/builtins.o

ld.lld -relocatable \
	build/DelendumEntryPoint.o\
	build/memcpy.o \
	build/builtins.o\
	-o build/runtime.o

