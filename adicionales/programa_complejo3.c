#include <stdio.h>

int n1 ;
int n2 ;


imprimir_mayor_agrupado (int num1, int num2) {
    if (num1 < num2) {
        printf("%d\n", n1) ;
    } else {
        if (num1 == num2) {
            printf("%d %d\n", n1, n2) ;
        } else {
            printf("%d\n", n2) ;
        }
    }
}

agrupar (int a) {
    if (a < 100) {
        if (a < 50) {
            if (a < 25) {
                if (a < 12) {
                    if (a < 6) {
                        return 5 ;
                    } else {
                        return 4 ;
                    }
                } else {
                    return 3 ;
                }
            } else {
                return 2 ;
            }
        } else {
            return 1 ;
        }
    } else {
        return 0 ;
    }
}

main ()
{
    int val1 ;
    int val2 ;

    n1 = 20 ;
    n2 = 80 ;
    for (int i ; i < 50 ; i = i + 10) {
        puts("Nueva iteración") ;
        n1 = n1 + i ;
        n2 = n2 - i ;
        val1 = agrupar (n1) ;
        val2 = agrupar (n2) ;
        imprimir_mayor_agrupado (val1, val2) ;
    }
    
//    system ("pause") ;
}

//@ (main) 
