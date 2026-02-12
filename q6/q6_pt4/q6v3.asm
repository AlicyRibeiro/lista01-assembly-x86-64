section .data
    filename    db 'numeros.txt', 0
    msg         db 'Soma dos dois maiores: ',0
    nova_linha  db 10

section .bss
    buffer  resb 128
    res_str resb 21

section .text
    global _start

_start:
    ; abrir arquivo fixo
    mov rdi, filename
    mov rax, 2                  ; syscall: open
    xor rsi, rsi                ; O_RDONLY
    syscall
    test rax, rax
    js fim
    mov r13, rax                ; file descriptor

    ; ler arquivo
    mov rdi, r13
    mov rsi, buffer
    mov rdx, 128
    mov rax, 0                  ; syscall: read
    syscall

    ; após leitura do arquivo
    lea r10, [buffer + rax]  ; r10 = fim do buffer (rsi original + bytes lidos)

    ; fechar arquivo
    mov rdi, r13
    mov rax, 3                  ; syscall: close
    syscall

    ; interpretar 3 inteiros não sinalizados
    mov rsi, buffer
    mov rdi, r10             ; fim do buffer
    call inteiro_nao_sinalizado
    mov r14, rax             ; primeiro inteiro

    mov rsi, rsi             ; já está atualizado pelo retorno da função
    mov rdi, r10
    call inteiro_nao_sinalizado
    mov r15, rax             ; segundo inteiro

    mov rsi, rsi
    mov rdi, r10
    call inteiro_nao_sinalizado
    mov rbx, rax             ; terceiro inteiro

    ; soma total
    mov rax, r14
    add rax, r15
    add rax, rbx

    ; menor valor
    mov rdi, r14
    cmp rdi, r15
    jle .c1
    mov rdi, r15
.c1:
    cmp rdi, rbx
    jle .menos
    mov rdi, rbx
.menos:
    sub rax, rdi        ; soma dos dois maiores
    mov r12, rax

    ; imprimir mensagem
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 22
    syscall

    ; converter para string
    mov rax, r12
    mov rdi, res_str
    call string_nao_sinalizado

    ; calcular quantidade de dígitos
    mov rsi, res_str
    xor rcx, rcx
.conta:
    mov al, [rsi+rcx]
    cmp al, 0
    je .pronto
    inc rcx
    jmp .conta
.pronto:
    ; imprimir resultado (apenas os dígitos)
    mov rax, 1
    mov rdi, 1
    mov rsi, res_str
    mov rdx, rcx
    syscall

    ; nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, nova_linha
    mov rdx, 1
    syscall

fim:
    mov rax, 60
    xor rdi, rdi
    syscall

; -----------------------------
; Lê inteiro não sinalizado (avança buffer para próxima linha)
; entrada:
; rsi = ponteiro atual no buffer
; rdi = fim do buffer
; saída:
; rax = valor inteiro lido
; rsi = atualizado para próximo início de linha
inteiro_nao_sinalizado:
    xor rax, rax
.loop:
    cmp rsi, rdi
    jge .end        ; se passou do buffer, termina
    movzx rdx, byte [rsi]
    cmp rdx, '0'
    jb .end
    cmp rdx, '9'
    ja .end
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rsi
    jmp .loop
.end:
.skip_line:
    cmp rsi, rdi
    jge .retorno
    movzx rdx, byte [rsi]
    inc rsi
    cmp dl, 10
    jne .skip_line
.retorno:
    ret

; -----------------------------
; Converte inteiro não sinalizado p/ string null-terminada
; entrada:
;   rax = número
;   rdi = ponteiro para onde escrever a string
; saída:
;   [rdi] = string null-terminada
string_nao_sinalizado:
    mov r9, rdi        ; salva o início da string
    mov r8, 10         ; divisor fixo
    mov rcx, 0         ; contador de dígitos
.conv_loop:
    xor rdx, rdx
    div r8             ; divide rax por 10
    add rdx, '0'       ; converte dígito para ASCII
    push rdx           ; empilha caractere
    inc rcx            ; conta dígito
    test rax, rax
    jnz .conv_loop     ; continua enquanto quociente > 0

.write_loop:
    pop rax
    mov [r9], al
    inc r9
    dec rcx
    jnz .write_loop

    mov byte [r9], 0   ; termina com null byte
    ret