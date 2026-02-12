AS = nasm 																	#Define nasm como o montador (assembler).
LD = ld																		#Define ld como o linker.
CC = gcc 																	#Define gcc como o compilador C.

ASFLAGS = -f elf64															#Define as opções para o nasm (neste caso, para gerar um arquivo de 64 bits para Linux).
CFLAGS = -Wall -g 															#Define as opções para o gcc (mostrar todos os avisos e incluir informações de depuração).


#Esta é a parte que determina quais arquivos serão criados.
QUESTIONS = q1/q1.asm q2/q2.asm  q4/q4.asm q5/q5.asm q7/q7.asm q8/q8.asm q9/q9.asm 				#Cria uma lista com todos os arquivos de código-fonte Assembly.

OBJS = $(QUESTIONS:.asm=.o) 												
OBJS := $(OBJS:.c=.o)														#Pega a lista QUESTIONS e substitui a extensão .asm por .o em cada item.      

TARGETS = $(OBJS:.o=)														#Pega a lista de arquivos objeto (OBJS) e remove a extensão .o, criando a lista de executáveis finais.

.PHONY: all clean															#Informa ao make que all e clean são "alvos falsos", ou seja, não são nomes de arquivos que ele precisa criar. São apenas nomes de comandos.

all: $(TARGETS)																#Esta é a regra padrão. Quando você digita make, ele executa esta regra, que por sua vez depende de todos os itens na lista TARGETS

%.o: %.asm																	#É uma regra de padrão. Ela ensina o make a criar qualquer arquivo .o a partir de um arquivo .asm com o mesmo nome. 
	$(AS) $(ASFLAGS) $< -o $@											

%.o: %.c																	# Outra regra de padrão que ensina a criar um .o a partir de um arquivo .c.
	$(CC) $(CFLAGS) -c $< -o $@

%: %.o																		# regra de padrão final. Ensina como criar um executável (representado pelo % sem extensão) a partir de um arquivo .o. 
	$(LD) $< -o $@

clean:																		#Define o comando make clean. Ele apaga todos os arquivos objeto (.o) e todos os executáveis (TARGETS) que foram gerados.
	rm -f $(OBJS) $(TARGETS)

run-q1:
	./q1/q1

run-q2:
	./q2/q2

run-q4:
	./q4/q4

run-q5:
	./q5/q5

run-q7:
	./q7/q7

run-q8:
	./q8/q8

run-q9:
	./q9/q9

