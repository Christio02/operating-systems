#include "kernel/types.h"
#include "kernel/process.h"
#include "user.h"


int main(int argc, char *argv[]) {

   struct process_info info[64];
   int count = get_process(info, 64);

   for (int i = 0; i < count; i++) {
      printf("%s (%d): %d\n", info[i].name, info[i].pid, info[i].state);
   }

   exit(0);



}