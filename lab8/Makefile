
C_OBJECTS = fixedfuncs.o
ASM_OBJECTS = fixedpoint.o

makefixed: $(C_OBJECTS) $(ASM_OBJECTS)
	gcc -g -o makefixed $(C_OBJECTS) $(ASM_OBJECTS)

.c.o:
	gcc -I. -g -c $<

.S.o:
	gcc -I. -g -c $<

