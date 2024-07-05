// This is the entry point for all C programs compiled to run on Valida. This file should
// always be the first input to `clang` when compiling for Valida. The first code section of any
// Valida ELF executable should be the `__valida__entry_point__` function defined in this file.
// The __valida__stop__ function should be compiled away as a compiler intrinsic and result
// in the STOP instruction being emitted.
extern int main();

void _start() {
  main();
  __builtin_delendum_stop();
}
