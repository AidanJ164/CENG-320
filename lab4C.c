#include <stdio.h>

char buffer[4096];
int i = 0;
int sum = 0;

int checksum( char buffer[] )
{
    for( i = 0; buffer[i] != 0; sum += buffer[i++]);
    return sum;
}

int main()
{
    printf("Enter text (ctrl-D to end): ");
    do
        buffer[i] = getchar();
    while((buffer[i] != -1) && (++i < 4095));
    buffer[i] = 0;
    printf("%s\n", buffer);

    printf("\nThe checknum is %08X\n", checksum(buffer));
    printf("\nThe checknum is %08X\n", checksum(buffer));
    return 0;
}
