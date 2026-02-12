; 4) Crie um programa assembly que, dados 3 números inteiros não sinalizados, definidos na seção data, imprima na tela a soma dos dois maiores.


section .data
    ; Definição dos números e mensagens
    num1 dw 8
    num2 dw 4
    num3 dw 10
    
    msg db "Soma dos dois maiores: ", 0
    msg_len equ $ - msg  ; <-- O montador calcula o tamanho automaticamente
    
    newline db 10

section .bss
    ; Buffer para a conversão de número para string
    num_buffer resb 12

section .text
    global _start

_start:
    ; Carrega os três números para os registradores
    movzx rax, word [num1]
    movzx rbx, word [num2]
    movzx rcx, word [num3]

    ; --- Lógica de Ordenação Simplificada ---
    ; Garante que RAX <= RBX
    cmp rax, rbx
    jle .check2
    xchg rax, rbx ; Troca se RAX > RBX

.check2:
    ; Garante que RBX <= RCX
    cmp rbx, rcx
    jle .check3
    xchg rbx, rcx ; Troca se RBX > RCX

.check3:
    ; Garante que RAX <= RBX novamente após a segunda troca
    cmp rax, rbx
    jle .sum
    xchg rax, rbx ; Troca se RAX > RBX

    ; Ao final, RBX e RCX conterão os dois maiores números
.sum:
    add rbx, rcx ; Soma os dois maiores em RBX

    ; --- Impressão ---
    
    ; 1. Imprime a mensagem inicial
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; 2. Imprime a soma (que está em RBX)
    mov rax, rbx         ; Move a soma para RAX, o argumento de imprime_inteiro
    mov rdi, num_buffer  ; Passa o buffer para a função
    call imprime_inteiro ; imprime_inteiro já faz a syscall write
    
    ; 3. Imprime uma nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

.exit:
    ; Encerra o programa
    mov rax, 60
    xor rdi, rdi
    syscall

; Função: Converte um número inteiro (de EAX) para uma string e imprime na tela.
imprime_inteiro:
    push rbx
    push rcx
    push rdx
    
    mov rcx, 10
    mov rsi, num_buffer + 10 ; Aponta para o final do buffer
    mov byte [rsi], 0        ; Adiciona o terminador nulo

    cmp eax, 0
    jne .loop
    dec rsi
    mov byte [rsi], '0' ; Se o número for 0, coloca '0'
    jmp .print

.loop:
    xor rdx, rdx
    div rcx              ; Divide RAX por 10, resto em RDX
    add dl, '0'          ; Converte o resto (dígito) para caractere ASCII
    dec rsi
    mov [rsi], dl        ; Armazena o dígito no buffer
    test rax, rax        ; Se o quociente for 0, terminamos
    jnz .loop

.print:
    ; Calcula o tamanho da string
    mov rdx, num_buffer
    add rdx, 11
    sub rdx, rsi
    
    ; Syscall para escrever na tela
    mov rax, 1
    mov rdi, 1
    ; rsi já aponta para o início do número na string
    ; rdx já contém o tamanho
    syscall

    pop rdx
    pop rcx
    pop rbx
    ret