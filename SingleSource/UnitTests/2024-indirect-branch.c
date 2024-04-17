__attribute__((noinline))
unsigned add(unsigned a, unsigned b) {
    return a + b;
}

int main() {
    // Declare a function pointer and initialize it to point to the add function
    unsigned (*funcPtr)(unsigned, unsigned) = add;
    // Now, call the add function indirectly using the function pointer
    unsigned result = funcPtr(5, 3);

    if (result != 8) {
      while (1) {}
    }

    return result;
}

