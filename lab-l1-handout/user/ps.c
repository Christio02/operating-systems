#include "kernel/types.h"
#include "kernel/process.h"
#include "user.h"


int main(int argc, char *argv[]) {

   struct process_info info[64]; // store up to 64 processes (NPROC)
   int count = get_process(info, 64); // get active processes from syscall and add to info array

   for (int i = 0; i < count; i++) {
      printf("%s (%d): %d\n", info[i].name, info[i].pid, info[i].state); // go through process info and print out
   }

   exit(0);

}