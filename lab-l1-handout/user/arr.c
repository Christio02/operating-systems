#include "user.h"
#include "kernel/types.h"




int main(int argc, char *argv[]) {
    uint64 buf[10];

    int size = get_arr(buf);

    printf("Array size %d\n", size);

    for (int i = 0; i < size; i++) {
        printf("buf[%d] %d\n", i, (int)buf[i]);
    }

    return 0;


}