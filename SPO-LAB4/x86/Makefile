BINARIES=lab4-x86-gas

all:	${BINARIES}
AS_ARGS=-g

lab4-x86-gas:	lab4-x86-gas.s
	as     ${AS_ARGS}      -o lab4-x86-gas.o          lab4-x86-gas.s
	ld                     -o lab4-x86-gas            lab4-x86-gas.o

clean:
	rm ${BINARIES} *.o || true
