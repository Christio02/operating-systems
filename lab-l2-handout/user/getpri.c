#include "user.h"


int main(int argc, char* argv[]) {

    int priority = getprio();

    printf("Process priority: %d\n", priority);
    return 0;

}