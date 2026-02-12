;Repita as questões 4 e 5, mas gerando três versões adicionais, sendo elas:
;Versão 1: Os números são solicitados ao usuário pelo progrma, sendo lidos um número por vez.

;compilação:
;nasm -f elf64 q6v4.asm -o q6v4.o
;ld q6v4.o -o q6v4
;execução:
;./q6v4 


section .bss
    input1 resb 20
    input2 resb 20
    input3 resb 20

section .data
    prompt1 db "Digite o primeiro numero: ", 0
    prompt2 db "Digite o segundo numero: ", 0
    prompt3 db "Digite o terceiro numero: ", 0
    len_prompt equ 25

    buffer db 21 dup(0)
    newline db 10

section .text
    global _start


ler_inteiro:
    ;syscall read
    mov rax, 0     
    mov rdi, 0    
    mov rdx, 20
    syscall

    ;converter string para inteiro
    ;rsi ainda aponta para buffer
    xor rax, rax    
    xor rcx, rcx    
    mov rbx, 0     
    mov bl, [rsi]

    cmp bl, '-'
    jne .parse_loop
    inc rcx         ;pula -
    mov bl, 1       ;sinal negativo
.parse_loop:
    mov dl, [rsi + rcx]
    cmp dl, 10     
    je .fim_conv
    cmp dl, 0
    je .fim_conv

    sub dl, '0'
    imul rax, 10
    add rax, rdx
    inc rcx
    jmp .parse_loop

.fim_conv:
    cmp bl, 1
    jne .ret
    neg rax
.ret:
    ret


_start:

    ;primeiro numero
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, len_prompt
    syscall

    mov rsi, input1
    call ler_inteiro
    mov r8, rax      ; num1

    ;segundo numero
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, len_prompt
    syscall

    mov rsi, input2
    call ler_inteiro
    mov r9, rax     

    ;terceiro numero
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt3
    mov rdx, len_prompt
    syscall

    mov rsi, input3
    call ler_inteiro
    mov r10, rax     


    mov r11, r8   ;menor=num1

    cmp r9, r11
    jge .skip1
    mov r11, r9
.skip1:
    cmp r10, r11
    jge .skip2
    mov r11, r10
.skip2:

    ;soma = num1 + num2 + num3 -menor
    mov rax, r8
    add rax, r9
    add rax, r10
    sub rax, r11

    mov rsi, buffer + 20
    mov rcx, 0

    mov rdi, rax
    cmp rax, 0
    jge .conv_abs
    neg rax
    mov rdi, -1
    jmp .conv_loop

.conv_abs:
    mov rdi, 0

.conv_loop:
.next_digit:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .next_digit

    cmp rdi, 0
    je .print

    dec rsi
    mov byte [rsi], '-'
    inc rcx

.print:
    ;syscall write
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall