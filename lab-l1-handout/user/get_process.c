
#include "user.h"
#include "../kernel/types.h"  // Add this first
#include "../kernel/stat.h"

int main(int argc, char **argv) {

  uint64 info = get_process();
  int pid = info & 0xFFFFFFFF;
  int state = (info >> 32) & 0xFFFFFFFF;

  printf("pid = %d, state = %d\n", pid, state);

  exit(0);
}