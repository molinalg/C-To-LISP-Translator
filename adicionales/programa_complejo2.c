int vector[10];
int resultado[10];

suma(int a, int b){
    int result;
    result = a + b;
    return result;
}

resta(int a, int b){
    return a - b;
}

multiplicacion(int a, int b){
    int result = a * b;
    return result;
}

division (int a, int b){
    if (b == 0) {
        puts("ERROR: DIVISION POR CERO");
        return 0;
    }
    return a / b;
}

main()
{
    int a = 8, b = 9, c = 10, d = 11;
    for (int i = 0; i < 10; i = i + 1) {
        vector[i] = 0;
        resultado[i] = 0;
    }
    for (int i = 0; i < 10; i = i + 1) {
        vector[i] = suma(a, b) + resta(c, d) + multiplicacion(a, b) + division(c, d);
        for (int j = 0; j < 10; j = j + 1) {
            int x = 0;
            while (x < 10) {
                resultado[x] = resultado[x] + vector[j] / 30;
                x = x + 1;
            }
        }
    }
    puts("EL RESULTADO ES:");
    printf("string no visible", resultado);
}

//@ (main)
