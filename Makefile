RM=rm -f
CPP=g++ -c --std=c++11 -o
CC=gcc -c -o
FLEX=flex
BISON=bison -d
CPPEXEC=g++ -o

CFLAGS=-Wall
CPPFLAGS=
LIBS=-lfl

EXEC=calc
OBJS=calc.tab.o lex.yy.o calc.o main.o
GENERATED=lex.yy.c calc.tab.h calc.tab.c

all: $(EXEC)

clean:
	$(RM) $(GENERATED)
	$(RM) $(OBJS)
	$(RM) $(EXEC)

$(EXEC): $(OBJS)
	$(CPPEXEC) $@ $? $(LIBS)

.cpp.o:
	$(CPP) $@ $? $(CPPFLAGS)

.c.o:
	$(CPP) $@ $? $(CFLAGS)

calc.tab.h calc.tab.c: calc.y calc.hpp
	$(BISON) calc.y

lex.yy.c: calc.l calc.hpp
	$(FLEX) calc.l

main.cpp calc.cpp: calc.hpp
