#include "../kernel/types.h"
#include "user.h"

int main(int argc, char *argv[])
{

    if (argc < 2)
    {
        printf("Usage: vatopa virtual_address [pid]");
        exit(1);
    }

    uint64 addr = atoi(argv[1]);

    int pid;
    if (argc > 2)
    {
        pid = atoi(argv[2]);
    }
    else
    {
        pid = 0;
    }

    uint64 phyAddr = va2pa(addr, pid);
    if (phyAddr == 0)
    {
        printf("0x0\n");
    }
    else
    {
        printf("0x%x\n", phyAddr);
    }

    return 0;
}