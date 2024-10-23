main() {
    int a = 50;
    for (int i = 0; i < 10; i = i + 1) {
        for (int j = 0; j < 10; j = j + 1) {
            if (i == 5) {
                printf("%d", i, j, a + i + j);
                i = 9;
            }
        }
    }
}
//@ (main)
