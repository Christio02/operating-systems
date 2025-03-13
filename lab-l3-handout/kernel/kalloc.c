// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

uint64 MAX_PAGES = 0;
uint64 FREE_PAGES = 0;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

// reference counter for page
int ref_count[PHYSTOP / PGSIZE];
struct run
{
    struct run *next;
};

struct
{
    struct spinlock lock;
    struct run *freelist;

} kmem;

void kinit()
{
    initlock(&kmem.lock, "kmem");

    // initialize ref count for each page
    for (int i = 0; i < PHYSTOP / PGSIZE; i++)
    {
        ref_count[i] = 0;
    }
    freerange(end, (void *)PHYSTOP);
    MAX_PAGES = FREE_PAGES;
}

void incref(void *pa)
{
    if (pa == 0)
    {
        panic("incref: Pa is 0!");
    }
    acquire(&kmem.lock);
    // get index
    int index = (uint64)pa / PGSIZE;
    ref_count[index]++;

    release(&kmem.lock);
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    {
        kfree(p);
    }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    if (MAX_PAGES != 0)
        assert(FREE_PAGES < MAX_PAGES);
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    // r = (struct run *)pa;

    acquire(&kmem.lock);
    int index = (uint64)pa / PGSIZE;
    if (ref_count[index] < 0)
    {
        panic("refcount: refcount is less than 0!");
    }

    ref_count[index]--;

    // decrease ref count
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    // FREE_PAGES++;
    if (ref_count[index] == 0)
    {
        // Fill with junk to catch dangling refs.

        memset(pa, 1, PGSIZE);

        // free page when no reference counter for page
        r = (struct run *)pa;
        r->next = kmem.freelist;
        kmem.freelist = r;
        FREE_PAGES++;
    }
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    assert(FREE_PAGES > 0);
    struct run *r;

    acquire(&kmem.lock);
    r = kmem.freelist;
    if (r)
    {
        kmem.freelist = r->next;
        int index = (uint64)r / PGSIZE;
        ref_count[index] = 1;
    }

    release(&kmem.lock);

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    FREE_PAGES--;
    return (void *)r;
}
