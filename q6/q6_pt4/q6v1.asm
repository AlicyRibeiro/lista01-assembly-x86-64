; Objetivo: Ler três números inteiros, somar os dois maiores e imprimir o resultado.
;
; Compilação:
; nasm -f elf64 q6v1.asm -o q6v1.o
; ld q6v1.o -o q6v1
; ./q6v1

section .bss
    ; Buffers para entrada não são estritamente necessários aqui, pois usamos um buffer global 'buffer'.
    ; Mantidos para referência, mas o código atual não os utiliza.
    input1 resb 20
    input2 resb 20
    input3 resb 20

section .data
    ; Mensagens para o usuário.
    prompt1: db "Digite o primeiro numero: ", 0
    prompt1_len: equ $ - prompt1

    prompt2: db "Digite o segundo numero: ", 0
    prompt2_len: equ $ - prompt2

    prompt3: db "Digite o terceiro numero: ", 0
    prompt3_len: equ $ - prompt3

    ; Buffer global para ler a entrada e converter a saída.
    buffer db 21 dup(0)
    newline db 10 ; Caractere de nova linha.

section .text
    global _start

; -------------------------------------------------------
; Função: ler_inteiro
; Descrição: Lê uma linha da entrada padrão (stdin), converte a string de dígitos
;            para um número inteiro e retorna o valor em RAX.
; -------------------------------------------------------
ler_inteiro:
    ; Lê a entrada do usuário usando a chamada de sistema 'sys_read'.
    mov rax, 0          ; syscall 0 (sys_read)
    mov rdi, 0          ; file descriptor 0 (stdin)
    mov rsi, buffer     ; Destino da leitura.
    mov rdx, 20         ; Tamanho máximo a ser lido.
    syscall

    ; Inicia a conversão da string para inteiro.
    xor rax, rax        ; Zera RAX, que será o acumulador do resultado.
    xor rcx, rcx        ; Zera RCX, que servirá de índice para o buffer.

.parse_loop:
    ; Carrega um byte do buffer.
    mov dl, [buffer + rcx]
    
    ; Verifica se o caractere é uma nova linha (fim da entrada) ou nulo.
    cmp dl, 10
    je .fim_conv
    cmp dl, 0
    je .fim_conv

    ; Converte o caractere ASCII ('0'-'9') para seu valor numérico (0-9).
    sub dl, '0'
    
    ; Multiplica o acumulador atual por 10 para abrir espaço para o novo dígito.
    push rdx            ; Salva o dígito atual na pilha.
    mov rbx, 10
    mul rbx             ; rax = rax * 10
    pop rdx             ; Restaura o dígito.
    
    ; Adiciona o novo dígito ao acumulador.
    ; **CORREÇÃO**: Usa movzx para garantir que apenas o byte do dígito seja adicionado,
    ; zerando os bits superiores de RDX para evitar somar lixo.
    movzx rdx, dl
    add rax, rdx
    
    inc rcx             ; Avança para o próximo caractere.
    jmp .parse_loop

.fim_conv:
    ret                 ; Retorna com o resultado em RAX.

; -------------------------------------------------------
; Ponto de entrada principal do programa.
; -------------------------------------------------------
_start:
    ; --- Leitura do primeiro número ---
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall
    call ler_inteiro
    mov r8, rax         ; Armazena o primeiro número em R8.

    ; --- Leitura do segundo número ---
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall
    call ler_inteiro
    mov r9, rax         ; Armazena o segundo número em R9.

    ; --- Leitura do terceiro número ---
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt3
    mov rdx, prompt3_len
    syscall
    call ler_inteiro
    mov r10, rax        ; Armazena o terceiro número em R10.

    ; --- Lógica para encontrar a soma dos dois maiores ---
    ; Estratégia: (soma de todos) - (o menor número) = (soma dos dois maiores)
    
    ; 1. Encontra o menor dos três números.
    mov r11, r8         ; Assume que R8 é o menor.
    cmp r9, r11         ; Compara o segundo (R9) com o menor atual (R11).
    jge .skip1          ; Se R9 >= R11, pula.
    mov r11, r9         ; Senão, R9 é o novo menor.
.skip1:
    cmp r10, r11        ; Compara o terceiro (R10) com o menor atual (R11).
    jge .skip2          ; Se R10 >= R11, pula.
    mov r11, r10        ; Senão, R10 é o novo menor.
.skip2:
    ; Neste ponto, R11 contém o menor dos três números.

    ; 2. Calcula a soma dos dois maiores.
    mov rax, r8         ; Começa com o primeiro número.
    add rax, r9         ; Adiciona o segundo.
    add rax, r10        ; Adiciona o terceiro. (RAX agora tem a soma total).
    sub rax, r11        ; Subtrai o menor, resultando na soma dos dois maiores.

    ; --- Conversão do resultado (inteiro) para string ---
    mov rsi, buffer + 20 ; Aponta RSI para o final do buffer.
    mov rcx, 0           ; Zera RCX, que contará os dígitos.

.conv_loop:
    xor rdx, rdx         ; Zera RDX para a divisão.
    mov rbx, 10
    div rbx              ; Divide RAX por 10. Resto em RDX.
    add dl, '0'          ; Converte o resto (dígito) para ASCII.
    dec rsi              ; Move o ponteiro do buffer para a esquerda.
    mov [rsi], dl        ; Armazena o dígito no buffer.
    inc rcx              ; Incrementa o contador de dígitos.
    test rax, rax        ; O quociente é zero?
    jnz .conv_loop       ; Se não, continua o loop.

.print:
    ; --- Imprime o resultado na tela ---
    mov rax, 1           ; syscall 1 (sys_write)
    mov rdi, 1           ; stdout
    ; RSI já aponta para o início da string de resultado.
    mov rdx, rcx         ; RDX é o número de caracteres a imprimir.
    syscall

    ; --- Imprime uma nova linha ---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Finaliza o programa ---
    mov rax, 60          ; syscall 60 (sys_exit)
    xor rdi, rdi         ; Código de saída 0.
    syscall
