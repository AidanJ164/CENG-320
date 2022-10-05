/*************************************************************************
 * helloc.c
 *
 * "Hello World" in C
 *
 * Aidan Justice
 *
 * Thur Jan 27, 2022
 *
 * This is a simple Hello World program written in C and using
 * printf() from the C standard library.
 *
 * It should be compiled and linked as follows:
 *   gcc -o helloc helloc.c
 *
 * gcc will call the compiler, assembler, and linker, telling the linker
 * to include the C standard library in the executable program.
 * **********************************************************************/
#include <stdio.h>

int main()
{
	printf("Hello World\n");
	return 0;
}
