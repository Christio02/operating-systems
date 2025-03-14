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

extern char end[]; // first address after kernel. // defined by kernel.ld.

// reference counter structure
struct ref_spinlock ref_st;

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
    initlock(&ref_st.lock, "ref_st");

    freerange(end, (void *)PHYSTOP);
    MAX_PAGES = FREE_PAGES;
}

void incref(void *pa)
{
    if (pa == 0)
    {
        panic("incref: Pa is 0!");
    }
    acquire(&ref_st.lock);
    // get index
    int index = ((uint64)pa) / PGSIZE;
    ref_st.ref_count[index]++;

    release(&ref_st.lock);
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    {
        acquire(&ref_st.lock);
        uint64 index = (uint64)p / PGSIZE;
        ref_st.ref_count[index] = 1;
        release(&ref_st.lock);
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

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    struct run *r;

    // r = (struct run *)pa;

    acquire(&ref_st.lock);

    int index = ((uint64)pa) / PGSIZE;

    // decrease ref count
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    // FREE_PAGES++;
    if (ref_st.ref_count[index] <= 1)
    {
        ref_st.ref_count[index] = 0;
        release(&ref_st.lock);

        // Fill with junk to catch dangling refs.

        memset(pa, 1, PGSIZE);

        // free page when no reference counter for page

        r = (struct run *)pa;
        acquire(&kmem.lock);
        r->next = kmem.freelist;
        kmem.freelist = r;
        FREE_PAGES++;
        release(&kmem.lock);
    }
    else
    {
        ref_st.ref_count[index]--;
        release(&ref_st.lock);
    }
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
        FREE_PAGES--;
    }

    release(&kmem.lock);

    if (r)
    {
        memset((char *)r, 5, PGSIZE); // fill with junk

        acquire(&ref_st.lock);

        int index = ((uint64)r / PGSIZE);

        ref_st.ref_count[index] = 1;

        release(&ref_st.lock);
    }

    return (void *)r;
}
