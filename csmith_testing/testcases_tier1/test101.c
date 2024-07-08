#include "csmith.h"

/* ---------------------------------------- */
int main (void)
{
    platform_main_begin();
    crc32_gentab();
    transparent_crc(17, "g_2", 0);
    platform_main_end(crc32_context ^ 0xFFFFFFFFUL, 1);
    return 0;
}


