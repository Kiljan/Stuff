#include <stdio.h>
#include <stdlib.h>

unsigned long find_start(void){
  __asm__("movl %esp, %eax");
}

int main(){
  printf("0x%x\n", find_start());
} 
