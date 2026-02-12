# Nome do executável
TARGET = q8

# Arquivo fonte
SRC = q8.asm

# Arquivo objeto
OBJ = q8.o
# Montador e linker
ASM = nasm
LD = ld

# Flags
ASMFLAGS = -f elf64
LDFLAGS = 

# Regra principal
all: $(TARGET)

# Compilação
$(TARGET): $(OBJ)
	$(LD) $(OBJ) -o $(TARGET)

# Montagem
$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) $(SRC) -o $(OBJ)

# Executar
run: $(TARGET)
	./$(TARGET)

# Limpar arquivos gerados
clean:
	rm -f $(OBJ) $(TARGET)

# Recompilar do zero
rebuild: clean all
