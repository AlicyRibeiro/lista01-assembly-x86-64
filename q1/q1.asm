; 1) Crie uma função assembly que imprima na tela um número inteiro não sinalizado, 
; definido na seção data, independente da quantidade de dígitos.

section .data
    num dq 2025        ; Define o número inteiro de 64 bits (dq) a ser impresso.

section .bss
    saida resb 22       ; Reserva 22 bytes de espaço não inicializado para a string de saída.
                        ; (20 para dígitos de um ulong_max, 1 para nova linha, 1 para terminador nulo).

section .text
    global _start       ; Torna o rótulo _start visível para o linker como ponto de entrada.
   
_start:
    ; Prepara a chamada da função de impressão.
    mov rax, [num]      ; Move o valor da variável 'num' para o registrador RAX.
                        ; RAX será o argumento para a nossa função Q1.
    call Q1             ; Chama a função que converte e imprime o número.

    ; Finaliza o programa.
    mov rax, 60         ; Carrega o código da chamada de sistema 'sys_exit'.
    xor rdi, rdi        ; Define o código de saída como 0 (sucesso).
    syscall             ; Chama o kernel para terminar o programa.

Q1:
    ; --- Início da Função ---
    ; Salva o estado atual dos registradores que serão modificados na pilha.
    ; Isso é uma boa prática para não interferir com outras partes do código.
    push rax
    push rcx
    push rdx
    push rdi
    push rsi

    ; --- Preparação para a Conversão ---
                                                                        ; A conversão de inteiro para string é feita gerando os dígitos do menos
                                                                        ; significativo (unidades) para o mais significativo, através de divisões sucessivas por 10.
                                                                        ; Por isso, armazenamos os dígitos do final do buffer para o início.
    mov rdi, saida + 20                                                 ; Aponta RDI para quase o final do buffer 'saida'.
    mov byte [rdi], 10                                                  ; Coloca um caractere de nova linha ('\n') no final da string.
    dec rdi                                                             ; Move o ponteiro um byte para trás, para a posição do último dígito.

    ; --- Tratamento Especial para o Número Zero ---
    cmp rax, 0          ; Compara o número em RAX com 0.
    jne .verifica_valor ; Se não for zero, pula para a lógica de conversão principal.
    ; Se o número for zero:
    mov byte [rdi], '0' ; Coloca o caractere '0' diretamente no buffer.
    mov rcx, 1          ; Define o contador de dígitos como 1 (CORREÇÃO: inicializa rcx para o caso do zero).
    jmp printf_string   ; Pula diretamente para a parte de impressão.

.verifica_valor:
    ; --- Loop de Conversão (para números não-zero) ---
    mov rcx, 0          ; Zera RCX, que será nosso contador de dígitos.

.loop_conv:
    xor rdx, rdx        ; Limpa RDX. A instrução DIV usa RDX:RAX como um dividendo de 128 bits.
    mov rbx, 10         ; Define o divisor como 10.
    div rbx             ; Divide RDX:RAX por RBX. O quociente fica em RAX, o resto em RDX.

    add rdx, '0'        ; Converte o resto (que é um dígito de 0 a 9) para seu caractere ASCII.
    mov byte [rdi], dl  ; Armazena o dígito ASCII no buffer na posição atual de RDI.
    dec rdi             ; Move o ponteiro do buffer um byte para a esquerda.
    inc rcx             ; Incrementa o contador de dígitos.

    cmp rax, 0          ; Compara o quociente (o que restou do número) com zero.
    jne .loop_conv      ; Se o quociente ainda não for zero, repete o loop.

printf_string:
    ; --- Impressão da String Resultante ---
    inc rdi             ; Após o loop, RDI aponta um byte *antes* do início do número.
                        ; Esta instrução corrige o ponteiro para o início da string de dígitos.
    
    mov rsi, rdi        ; RSI (source index) é o ponteiro para a string que queremos imprimir.
    mov rdx, rcx        ; RDX é o número de bytes a serem escritos (nosso contador de dígitos).
    add rdx, 1          ; Adiciona 1 ao contador para incluir o caractere de nova linha que colocamos.

    ; Chama a chamada de sistema 'sys_write'.
    mov rax, 1          ; Código para 'sys_write'.
    mov rdi, 1          ; Descritor de arquivo 1 (stdout - saída padrão/tela).
    syscall             ; Chama o kernel para executar a escrita.

    ; --- Fim da Função ---
    ; Restaura os registradores para seus valores originais, desempilhando-os na ordem inversa.
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rax
    ret                 ; Retorna da função.
