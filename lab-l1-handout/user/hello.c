
#include "user.h"



int main(int argc, char *argv[]) {
    if (argc == 1) {
        printf("Hello World\n");

    } else {
        printf("Hello %s, nice to meet you!\n ", argv[1]);
    }
    exit(0);
}