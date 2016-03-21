#include <iostream>
#include <algorithm>
#include <vector>

template <typename T>
void print_vector(std::vector<T> &v) {
    std::cout << "[ ";
    for (auto& x : v) {
        std::cout << x << " ";
    }
    std::cout << "]\n";
}

int main(int argc, char* argv[]) {
    std::cout << std::endl;
    std::cout << "-------------------------\n";
    std::cout << "Tests with `<` comparator\n";
    std::cout << "-------------------------\n";

    std::vector<int> testVec1 {1, 2, 3, 4, 5};
    std::vector<int> testVec2 {1, 2, 4, 5};
    
    std::cout << "Test vector 1\n";
    print_vector(testVec1);

    auto low = std::lower_bound(testVec1.begin(), testVec1.end(), 3);
    auto high = std::upper_bound(testVec1.begin(), testVec1.end(), 3);
    
    std::cout << "Lower: " << (low - testVec1.begin()) << "\nUpper: " << (high - testVec1.begin()) << std::endl;
    std::cout << std::endl;


    std::cout << "Test vector 2\n";
    
    low = std::lower_bound(testVec2.begin(), testVec2.end(), 3);
    high = std::upper_bound(testVec2.begin(), testVec2.end(), 3);

    std::cout << "Lower: " << (low - testVec2.begin()) << "\nUpper: " << (high - testVec2.begin()) << std::endl;
    print_vector(testVec2);

    std::cout << std::endl;
    std::cout << "--------------------------\n";
    std::cout << "Tests with `<=` comparator\n";
    std::cout << "--------------------------\n";

    return 0;
}
