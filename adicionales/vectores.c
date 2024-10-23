int vect[20];

main()
{
    int i = 1;
    int j = 9;
    int sum[j + i];
    for (int x = 0; x < i + j; x = x + 1) {
        vect[x] = 1;
        sum[x] = vect[x] + vect[0] + x;
    }
    printf("%d", sum);
    
}
//@ (main)

