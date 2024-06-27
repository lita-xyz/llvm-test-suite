#include <errno.h>

// errno defaults to 0;
extern int errno ; 

int main () {
   
   __builtin_delendum_write(errno);

   return(0);
}
