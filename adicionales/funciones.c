suma (int a, int b)
{
    int result = a + b;
    return result;
}

resta (int a, int b)
{
    int result = a - b;
    return result;
}

division (int a, int b)
{
    int result = a / b;
    return result;
}

multiplicacion (int a, int b)
{
    int result = a * b;
    return result;
}

main ()
{
    int a = 11;
    int b = 2;
    int result;

    result = suma(a, b);
    puts("SUMA:");
    printf("%d", result);

    result = resta(a, b);
    puts("RESTA:");
    printf("%d", result);

    result = division(a, b);
    puts("DIVISION:");
    printf("%d", result);

    result = multiplicacion(a, b);
    puts("MULTIPLICACION:");
    printf("%d", result);
}

//@ (main)

