; 2) Crie uma função assembly que imprima na tela um número inteiro sinalizado, definido na seção data, independente da quantidade de dígitos.


section .data  
global _start
   num dq -2025

section .bss
    saida resb 22

section .text
  

_start:
    mov rax, [num]
    call print_sinal

    mov rax, 60
    xor rdi, rdi
    syscall

print_sinal:
    push rax
    push rcx
    push rdx
    push rdi
    push rsi
    push rbx

    mov rdi, saida + 20
    mov byte [rdi], 10
    dec rdi

    mov r10, 0

    cmp rax, 0
    jne veri_sinal
    mov byte [rdi], '0'
    dec rdi
    jmp print_string

veri_sinal:
    test rax, rax
    jns positivo
    mov r10, 1
    neg rax

positivo:
    mov rcx, 0

loop_conv:
    xor rdx, rdx
    mov rbx, 10
    div rbx

    add rdx, '0'
    mov byte [rdi], dl
    dec rdi
    inc rcx

    cmp rax, 0
    jne loop_conv

    cmp r10, 1
    jne print_string

    mov byte [rdi], '-'
    dec rdi
    inc rcx

print_string:
    inc rdi
    mov rsi, rdi
    mov rdx, rcx
    add rdx, 1

    mov rax, 1
    mov rdi, 1
    syscall

    pop rbx
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rax
    ret