#ifndef RUNTIME_H
#define RUNTIME_H

#include "runtime.h"

static void platform_main_begin(void);
static void platform_main_begin(void)
{
}

static void platform_main_end(unsigned int crc, int flag) __attribute__((noinline));
static void platform_main_end(unsigned int crc, int flag)
{
  __builtin_delendum_write((crc >> 24) & 0xff);
  __builtin_delendum_write((crc >> 16) & 0xff);
  __builtin_delendum_write((crc >> 8) & 0xff);
  __builtin_delendum_write((crc >> 0) & 0xff);
}

#define printf(...)
#define fprintf(...)

#endif
