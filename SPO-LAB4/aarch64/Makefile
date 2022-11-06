BINARIES=lab4
AS=as
LD=ld

all:    ${BINARIES}

lab4:           lab4.s
                ${AS}   -g      -o lab4.o       lab4.s
                ${LD}           -o lab4         lab4.o

clean: