;Repita as questões 4 e 5, mas gerando três versões adicionais, sendo elas:
;Versão 3: Os números são lidos de um arquivo de texto contendo um número por linha.

;compilação:
; nasm -f elf64 q6v6.asm -o q6v6.o
; ld q6v6.o -o q6v6 
; ./q6v6 arquivo.txt


section .bss
    buffer resb 128          ; Buffer para ler o conteúdo do arquivo.
    res_str resb 21          ; Buffer para armazenar o resultado convertido para string.

section .data
    nova_linha db 10         ; Caractere de nova linha.

section .text
    global _start

_start:
    ; Verifica se o nome do arquivo foi passado como argumento.
    mov r12, [rsp]              
    cmp r12, 2                   
    jne .fim

    ; Abre o arquivo especificado no argumento da linha de comando.
    mov rdi, [rsp + 16]       ; RDI aponta para argv[1] (nome do arquivo).
    mov rax, 2                ; syscall 2 (sys_open).
    xor rsi, rsi              ; Flags de modo (0 para leitura).
    syscall
    cmp rax, 0
    js .fim                   ; Se rax < 0, houve erro ao abrir.
    mov r13, rax              ; Salva o descritor do arquivo em R13.

    ; Lê o conteúdo do arquivo para o buffer.
    mov rdi, r13                
    mov rsi, buffer            
    mov rdx, 128                
    mov rax, 0                  ; syscall 0 (sys_read).
    syscall

    ; Fecha o arquivo.
    mov rdi, r13
    mov rax, 3                  ; syscall 3 (sys_close).
    syscall

    ; Lê os três números do buffer.
    mov rsi, buffer             ; RSI aponta para o início do buffer.
    call inteiro_sinalizado
    mov r14, rax                ; Armazena o primeiro número.

    call inteiro_sinalizado
    mov r15, rax                ; Armazena o segundo número.

    call inteiro_sinalizado
    mov rbx, rax                ; Armazena o terceiro número.

    ; Calcula a soma total.
    mov rax, r14
    add rax, r15
    add rax, rbx

    ; Encontra o menor dos três números.
    mov rdi, r14
    cmp rdi, r15
    jle .c1
    mov rdi, r15
.c1:
    cmp rdi, rbx
    jle .menos
    mov rdi, rbx
.menos:
    ; Subtrai o menor da soma total para obter a soma dos dois maiores.
    sub rax, rdi   
    mov r12, rax

    ; Converte o resultado final para uma string.
    mov rax, r12
    mov rdi, res_str
    call string_sinalizado

    ; Imprime a string do resultado.
    mov rax, 1
    mov rdi, 1
    mov rsi, res_str
    mov rdx, 21
    syscall

    ; Imprime uma nova linha.
    mov rax, 1
    mov rdi, 1
    mov rsi, nova_linha
    mov rdx, 1
    syscall

.fim:
    ; Finaliza o programa.
    mov rax, 60
    xor rdi, rdi
    syscall

; Converte uma string do buffer para um inteiro com sinal.
inteiro_sinalizado:
    xor rax, rax
    xor r10, r10    ; Flag para número negativo (0=positivo, 1=negativo).

    cmp byte [rsi], '-'
    jne .loop
    mov r10, 1
    inc rsi
.loop:
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
    cmp r10, 1
    jne .skip_neg
    neg rax
.skip_neg:
    ; Avança o ponteiro RSI até a próxima linha no buffer.
.skip_line:
    movzx rdx, byte [rsi]
    inc rsi
    cmp dl, 10
    jne .skip_line
    ret

; Converte um inteiro com sinal para uma string.
string_sinalizado:
    mov r9, rdi     ; R9 aponta para o buffer de destino da string.
    test rax, rax
    jns .positivo
    mov byte [r9], '-'
    inc r9
    neg rax
.positivo:
    mov r8, 10
    mov rcx, 0
.conv_loop:
    xor rdx, rdx
    div r8          ; Divide por 10, resto em RDX.
    add rdx, '0'
    push rdx        ; Empilha os dígitos (ordem invertida).
    inc rcx
    test rax, rax
    jnz .conv_loop
.write_loop:
    pop rax         ; Desempilha os dígitos na ordem correta.
    mov [r9], al
    inc r9
    dec rcx
    jnz .write_loop
    mov byte [r9], 0 ; Adiciona o terminador nulo.
    ret