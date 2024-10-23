#include <stdio.h>

int a;
int n;

diferencia_n (int a, int n)
{
    int diferencia;
    if (a < n || a == n) {
        diferencia = n - a;
    } else {
        diferencia = a - n;
    }
    return diferencia;
}

main() {
    int a = 5;
    for (int i = 0; i < 10; i = i + 1) {
        printf("%d", diferencia_n(a, i), i);
    }
}
//@ (main)
