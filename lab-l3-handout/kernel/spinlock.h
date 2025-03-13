// Mutual exclusion lock.

#include "memlayout.h"

#define PGSIZE 4096 // bytes per page

struct spinlock
{
  uint locked; // Is the lock held?

  // For debugging:
  char *name;      // Name of lock.
  struct cpu *cpu; // The cpu holding the lock.
};

extern struct ref_spinlock
{
  // reference counter for page
  struct spinlock lock;
  int ref_count[PHYSTOP / PGSIZE];
} ref_st;
