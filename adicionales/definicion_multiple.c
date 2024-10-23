#include <stdio.h>

main ()
{
    int a = 1, b = 2;
    int x = 3, y = 4;
    
    {
        x = x * 2;
        y = x * y;
        printf("%d %d", x, y);
    }
    printf("%d %d", a, b);
}

//@ (main)
