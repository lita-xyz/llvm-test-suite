#ifndef RUNTIME_H
#define RUNTIME_H

#include <stdint.h>

int printf ( const char * format, ... );

static void platform_main_begin(void);
static void platform_main_begin(void)
{
}

static void platform_main_end(uint32_t crc, int flag) __attribute__((noinline));
static void platform_main_end(uint32_t crc, int flag)
{
  putchar((crc >> 24) & 0xff);
  putchar((crc >> 16) & 0xff);
  putchar((crc >> 8) & 0xff);
  putchar((crc >> 0) & 0xff);
}

#endif
