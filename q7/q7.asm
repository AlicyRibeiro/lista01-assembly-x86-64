; 7) Crie um programa assembly que calcule e imprima na tela o determinante de uma matriz 3x3 (considere inteiros sinalizados), definida na seção data.



section .data
global _start
    matriz dq 0,1,2
           dq 3,4,5
           dq 6,7,8
    newline db 0xA


section .bss
    saida resb 22


section .text


_start:
    ; Linha 1
    mov rax, [matriz + 0*8]   ; a11 - Copia o primeiro valor (0) para o registrador RAX.
    mov rbx, [matriz + 1*8]   ; a12 - Copia o segundo valor (1) para o registrador RBX.
    mov rcx, [matriz + 2*8]   ; a13 - Copia o terceiro valor (2) para o registrador RCX.

    ; Linha 2
    mov rdx, [matriz + 3*8]   ; a21 - Copia o quarto valor (3) para o registrador RDX.
    mov rsi, [matriz + 4*8]   ; a22 - Copia o quinto valor (4) para o registrador RSI.
    mov rdi, [matriz + 5*8]   ; a23 - copia o sexto valor (5) para o registrador RDI.

    ; Linha 3
    mov r8,  [matriz + 6*8]   ; a31 - Copia o sétimo valor (6) para o registrador R8.
    mov r9,  [matriz + 7*8]   ; a32 - Copia o oitavo valor (7) para o registrador R9.
    mov r10, [matriz + 8*8]   ; a33 - Copia o nono valor (8) para o registrador R10.

    ; Ele pega os dados brutos que estão "guardados" na memória e os distribui para os registradores da CPU

    ; Cofator de a11
    mov r11, rsi              ; a22
    imul r11, r10             ; a22 * a33
    mov r12, rdi              ; a23
    imul r12, r9              ; a23 * a32
    sub r11, r12              ; Cofator a11

    ; Cofator de a12
    mov r13, rdx              ; a21
    imul r13, r10             ; a21 * a33
    mov r14, rdi              ; a23
    imul r14, r8              ; a23 * a31
    sub r13, r14              ; Cofator a12

    ; Cofator de a13
    mov r15, rdx              ; a21
    imul r15, r9              ; a21 * a32
    mov rbp, rsi              ; a22
    imul rbp, r8              ; a22 * a31
    sub r15, rbp              ; Cofator a13

    ; Cálculo do determinante
    imul rax, r11             ; a11 * Cofator11
    imul rbx, r13             ; a12 * Cofator12
    imul rcx, r15             ; a13 * Cofator13

    sub rax, rbx              ; a11*C11 - a12*C12
    add rax, rcx              ; + a13*C13

    ; Imprimir resultado
    mov rdi, rax
    call print

    ; Encerrar
    mov rax, 60
    xor rdi, rdi
    syscall

; ---------- Função: Imprimir número ----------
print:
    mov rsi, saida
    add rsi, 20
    mov byte [rsi], 0
    mov rcx, 0

    cmp rdi, 0
    jne .zero 

    mov byte [rsi-1], '0'
    mov rsi, saida + 19
    inc rcx
    jmp .print_string

.zero:
    mov rbx, 0
    cmp rdi, 0
    jge .positivo
    mov rbx, 1
    neg rdi

.positivo:
    .conv_loop:
        xor rdx, rdx
        mov rax, rdi
        mov rbp, 10
        div rbp
        add dl, '0'
        dec rsi
        mov [rsi], dl
        inc rcx
        mov rdi, rax
        cmp rdi, 0
        jne .conv_loop

    cmp rbx, 1
    jne .print_string
    dec rsi
    mov byte [rsi], '-'
    inc rcx

.print_string:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    call print_newline
    ret

print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret
