; 8) Crie um programa assembly que calcule e imprima na tela o resultado da multiplicação de duas matrízes 3x3, definidas na seção data.



section .data
    ; Matrizes A e B (3x3)
    A dq 1, 2, 3,
      dq 4, 5, 6,
      dq 7, 8, 9

    B  dq 9, 8, 7,
       dq 6, 5, 4,
       dq 3, 2, 1

    newline db 10
    space db " ", 0

section .bss
    C resq 9           ; Resultado (3x3)
    num_str resb 20    ; Buffer para conversão de inteiro para string

section .text
    global _start

_start:
    ; Multiplicação de matriz C = A × B
    xor r8, r8        ; i = 0
.loop_i:
    cmp r8, 3
    jge .print_result

    xor r9, r9        ; j = 0
.loop_j:
    cmp r9, 3
    jge .inc_i

    xor r10, r10      ; k = 0
    xor r11, r11      ; sum = 0

.loop_k:
    cmp r10, 3
    jge .store_result

    ; A[i][k] = A[3*i + k]
    mov rax, r8
    imul rax, 3
    add rax, r10
    mov r12, [A + rax*8]

    ; B[k][j] = B[3*k + j]
    mov rax, r10
    imul rax, 3
    add rax, r9
    mov r13, [B + rax*8]

    imul r12, r13
    add r11, r12

    inc r10
    jmp .loop_k

.store_result:
    mov rax, r8
    imul rax, 3
    add rax, r9
    mov [C + rax*8], r11

    inc r9
    jmp .loop_j

.inc_i:
    inc r8
    jmp .loop_i

; === Impressão ===
.print_result:
    xor r8, r8
.pr_i:
    cmp r8, 3
    jge .exit

    xor r9, r9
.pr_j:
    cmp r9, 3
    jge .print_newline

    mov rax, r8
    imul rax, 3
    add rax, r9
    mov rsi, [C + rax*8]
    call int_to_str

    ; --- CORREÇÃO APLICADA AQUI ---
    mov rdx, rax        ; Move o comprimento da string (de RAX) para RDX
    mov rax, 1          ; Define RAX para a syscall 'write'
    mov rdi, 1          ; stdout
    ; RSI já contém o ponteiro para a string, retornado por int_to_str
    syscall

    ; imprime espaço
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall

    inc r9
    jmp .pr_j

.print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r8
    jmp .pr_i

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; === Converte inteiro (RSI) para string ===
; Retorna ponteiro em RSI, comprimento em RAX
int_to_str:
    mov rax, rsi
    lea rdi, [num_str + 19]
    mov byte [rdi], 0
    dec rdi
    mov rcx, 10
    
    test rax, rax
    jnz .loop
    mov byte [rdi], '0'
    mov rsi, rdi
    mov rax, 1
    ret

.loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop
    
    inc rdi
    mov rsi, rdi
    
    mov rax, num_str + 19
    sub rax, rdi
    ret