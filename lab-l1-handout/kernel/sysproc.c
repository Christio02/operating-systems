#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

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



// first it worked with just printing in the loop here, but I thought that sounded unsafe, so I copied the process
// info safely to user space instead
uint64
sys_get_process(void) {
  struct proc *p; // pointer to process structure

  struct process_info {
    char name[16];
    int pid;
    int state;
  } processes[NPROC]; // create array where each element is process_info

  int count = 0; // track number of processes found
  uint64 user_addr; // user space address where this info should be copied to

  argaddr(0, &user_addr); // get user space buffer address from user space, when this sys call is called



  for (p = proc; p < &proc[NPROC]; p++) { // iterate over process table
    acquire(&p->lock); // acquire lock  -> because of safely access state
    if (p->state != UNUSED) {
      safestrcpy(processes[count].name, p->name, sizeof(processes[count].name)); // copy the name, needs to be safely copied to array

      processes[count].pid = p->pid; // add pid to process_info in  array

      processes[count].state = p->state; 

      count++;
    }
    release(&p->lock); // unlock process 
  }
  // need to use copyout, not print directly in kernel, if 0 it worked then we return number of processes, if not return -1
  return copyout(myproc()->pagetable, user_addr, (char*)processes, count * sizeof(struct process_info)) == 0 ? count : -1; 

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
