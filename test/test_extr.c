#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
void *h =dlopen("./test_ext.so",RTLD_LAZY);
  typedef int (*adder)(int,int);
  adder addr;
  
if (h) {
  addr = dlsym(h, "add");  
  }
if (addr)  {
  printf("1 plus 2 is %d\n",addr(1,2));
  }
else {
  char *e = dlerror();
  if (e) {
    fprintf(stderr,"error: %s\n",e);
    }
  }

  
    
      
	  
{  
  typedef char * (*pigl)(char *);
  pigl piglatin;
  piglatin = dlsym(h, "piglatin"); 
  if (piglatin) {
    printf("cat in piglatin is %s\n",piglatin("cat")); 
    }
  else {
    char *e = dlerror();
    if (e) {
      fprintf(stderr,"error: %s\n",e);
      }
    }
  }  
exit(0);
}
