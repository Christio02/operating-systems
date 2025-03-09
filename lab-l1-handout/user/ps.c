#include "user.h"

struct process_info
{ // declare user space process_info struct
   char name[16];
   int pid;
   int state;
};

int main(int argc, char *argv[])
{

   struct process_info processes[64]; // Store retrieved processes

   int count = get_process((uint64)processes); // receive current processes from kernel

   if (count < 0)
   { // check if failed
      printf("Error getting processes");
      exit(1);
   }

   // print out information
   for (int i = 0; i < count; i++)
   {
      printf("%s (%d): %d\n", processes[i].name, processes[i].pid, processes[i].state);
   }

   exit(0);
}