#include <stdio.h>

main () {
    int a = 3;
    int x = a * 9;
    int y = 0;
    int i = 0;
    int j = 0;
    while (i < 10) {
        x = x - 1;
        y = y + 1;
        while (j < 10) {
            y = y - 1;
            x = x - 1;
            if (x < y) {
                printf("%d", a + x + y);
            } else {
                printf("%d", x + y);
            }
            j = j + 1;
        }
        i = i + 1;
    }
}

//@ (main)
