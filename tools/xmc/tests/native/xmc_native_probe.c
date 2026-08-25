#include <stdio.h>

int xmc_native_value(int seed) {
    return seed * 3 + 7;
}

int main(void) {
    printf("xmc-native-c=%d\n", xmc_native_value(5));
    return 0;
}
