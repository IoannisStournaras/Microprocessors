CC=gcc
CFLAGS=-Wall -g

all:string_manipulation.out

string_manipulation.out: string_man.o string_manipulation.o
	$(CC) $(CFLAGS) string_man.o string_manipulation.o -o string_manipulation.out

string_man.o: string_man.s
	$(CC) $(CFLAGS) -c string_man.s

string_manipulation.o: string_manipulation.c
	$(CC) $(CFLAGS) -c string_manipulation.c

clean:
	rm string_manipulation.out
