#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "process.h"

extern struct proc proc[];



uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_hello(void) {
  printf("Hello World");
  return 0;
}

uint64
handle_get_process(struct process_info* info, int max_count) { // process info header
   struct proc *p; // pointer to process
   int count = 0; // count of processes 
   struct process_info temp; // temp process info struct before copying to user space

   for (p = proc; p < &proc[NPROC]; p++) {  // iterate through process table NPROC = max processes

      if (p->state == UNUSED) // skip state unused
         continue;
      if (count >= max_count) // finished
         break;

      temp.pid = p->pid; // save pid for each process in temp process

      temp.state = p->state; // same here

      strncpy(temp.name, p->name, sizeof(temp.name) - 1); // safely copy name from process to temp process
      temp.name[sizeof(temp.name) - 1] = '\0'; // add null terminator to string
      
      // get process pagetable, destination adddress, and origin address, size to copy over
      if (copyout(myproc()->pagetable, (uint64)(&info[count]), (char*)&temp, sizeof(temp)) < 0) {
        return -1; // it failed
       
      }
      count++;
   }

   return count;

}

uint64
sys_get_process(void) {
    uint64 info_addr; // user space address where array of processes are stored
    int max; // max count of processes to get
    argaddr(0, &info_addr); // buffer address
    argint(1, &max); // maximum count

    return handle_get_process((struct process_info*)info_addr, max);
}

uint64
sys_get_arr(void) {
  uint64 addr;
  int size = 5;

  argaddr(0, &addr);

  uint64 arr[10];

  for (int i = 0; i < size; i++) {
    arr[i] = i;
  }

  if (copyout(myproc()-> pagetable, addr, (char*)arr, size * sizeof(uint64)) < 0) {
    return -1;
  }
  return size;

}
