; 5) Crie um programa assembly que, dados 3 números inteiros sinalizados, definidos na seção data, imprima na tela a soma dos dois maiores.

section .data
global _start
    num1 dw 20
    num2 dw -70
    num3 dw -8
    msg db "Soma dos dois maiores:  ", 0
    newline db 10

section .bss
    saida resb 12

section .text


_start:
    movsx rax, word [num1]
    movsx rbx, word [num2]
    movsx rcx, word [num3]

    cmp rax, rbx
    jge comp_3
    xchg rax, rbx

comp_3:
    cmp rax, rcx
    jge compa_2
    mov rdx, rbx
    mov rbx, rax
    mov rax, rcx
    mov rcx, rdx
    jmp somar

compa_2:
    cmp rbx, rcx
    jge somar
    mov rbx, rcx

somar:
    add rax, rbx
    mov r8, rax

    mov rdx, 24
    mov rsi, msg
    mov rdi, 1
    mov rax, 1
    syscall

    mov rcx, 12
    mov rdi, saida
    xor al, al
    rep stosb

    mov rdi, saida
    mov rsi, r8
    call converte_num

    mov rdx, rax
    mov rsi, saida
    mov rdi, 1
    mov rax, 1
    syscall

    mov rdx, 1
    mov rsi, newline
    mov rdi, 1
    mov rax, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

converte_num:
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push rbp

    mov rax, rsi
    mov rbx, 10
    xor rcx, rcx
    mov rbp, rdi

    mov rdx, 0
    test rax, rax
    jge nao_negativo

    neg rax
    mov byte [rdi], '-'
    inc rdi
    inc rcx

nao_negativo:
    cmp rax, 0
    jne loop_conv_start

    mov byte [rdi], '0'
    inc rdi
    inc rcx
    jmp fim_conv

loop_conv_start:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz loop_conv_start

print_loop:
    cmp rcx, 0
    je fim_conv
    pop rdx
    mov [rdi], dl
    inc rdi
    dec rcx
    jmp print_loop

fim_conv:
    sub rdi, rbp
    mov rax, rdi

    pop rbp
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    ret