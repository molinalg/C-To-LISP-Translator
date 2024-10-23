#include <stdio.h>

negativo (int x)
{
    int neg = -1;
    return x * neg;
}

es_negativo (int x)
{
    if (x < 0) {
        return 1;
    } else {
        return 0;
    }
}

potencia (int x, int y)
{
    int i = 0;
    int res = 1;
    while (i < y) {
        res = res * x;
        i = i + 1;
    }
    return res;

}

operacion (int x, int y)
{
    int res = 0;
    for (int i = 0; i < 10; i = i + 1) {
        for (int j = 0; j < 10; j = j + 1) {
            res = res + potencia(x, y) + potencia(i, j);
        }
    }
    return res;
}
main()
{
    int x = 3;
    int y = -4;
    int result;

    if (es_negativo(x) < 0) {
        puts("x es positivo");
        printf("%d", x);
    } else {
        puts("x es negativo");
        x = negativo(x);
        printf("%d", x);
    }

    if (es_negativo(y) < 0) {
        puts("y es positivo");
        printf("%d", y);
    } else {
        puts("y es negativo");
        y = negativo(y);
        printf("%d", y);
    }

    result = operacion(x, y);
    puts("RESULTADO:");
    printf("esta string no se imprime pero el resultado si %d", result);

}
//@ (main)
