AS = nasm
CC = gcc

ASFLAGS = -f elf64 -g
CFLAGS = -c -Wall -g
LDFLAGS = -no-pie

TARGET = programa
OBJS = main.o q3.o
SRCS = main.c q3.asm

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

run: all
	./$(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)