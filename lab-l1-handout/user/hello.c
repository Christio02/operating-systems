
#include "user.h"



int main(int argc, char *argv[]) {
    if (argc == 1) { // if we only one argument
        printf("Hello World\n"); // just print hello world

    } else {
        printf("Hello %s, nice to meet you!\n ", argv[1]); // otherwiser print the argument also
    }
    exit(0);
}