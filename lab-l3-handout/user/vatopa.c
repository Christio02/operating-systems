#include "../kernel/types.h"
#include "user.h"

int main(int argc, char *argv[])
{

    if (argc < 2)
    {
        printf("Usage: vatopa virtual_address [pid]\n");
        exit(1);
    }

    // parse addr input
    int addr = atoi(argv[1]);

    int pid;
    // if more than 2, means we also have pid
    if (argc > 2)
    {
        // parse input pid
        pid = atoi(argv[2]);
    }
    // if less than 2 then we set pid to current process
    else
    {
        pid = 0;
    }

    // retrieve physical address from syscall
    uint64 phyAddr = va2pa(addr, pid);
    if (phyAddr == -1) // no address found
    {
        printf("Address not found\n");
    }
    else
    {
        // print in hex format
        printf("0x%x\n", phyAddr);
    }

    return 0;
}