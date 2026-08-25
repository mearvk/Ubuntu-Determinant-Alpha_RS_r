#include <iostream>

int xmc_native_cpp_value(int seed) {
    return seed * seed + 11;
}

int main() {
    std::cout << "xmc-native-cpp=" << xmc_native_cpp_value(4) << '\n';
    return 0;
}
