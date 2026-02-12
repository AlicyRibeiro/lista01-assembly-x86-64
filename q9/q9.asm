; 9) Crie um programa assembly que lê uma expressão numérica simples definida pelo usuário e mostra o resultado. 
; Considere apenas as 4 operações básicas e o uso de parênteses para definição de precedências.
       
section .bss
    expr resb 100                                               ; Buffer para armazenar a expressão de entrada do usuário (100 bytes).
    result resb 12                                              ; Buffer para armazenar o resultado convertido em string (suficiente para um inteiro de 64 bits).

section .data
    prompt db "Digite uma expressão: ", 0                       ; Mensagem a ser exibida para o usuário.
    prompt_len equ $ - prompt                                   ; Comprimento da mensagem do prompt, calculado em tempo de compilação.
    newline db 10                                               ; Caractere de nova linha (LF).

section .text
    global _start

_start:
    ; --- Imprime o prompt na tela ---
    mov rax, 1          ; syscall 1 (sys_write)
    mov rdi, 1          ; file descriptor 1 (stdout)
    mov rsi, prompt     ; ponteiro para a mensagem
    mov rdx, prompt_len ; comprimento da mensagem
    syscall             ; chama o kernel

    ; --- Lê a entrada do usuário ---
    mov rax, 0          ; syscall 0 (sys_read)
    mov rdi, 0          ; file descriptor 0 (stdin)
    mov rsi, expr       ; buffer de destino para a entrada
    mov rdx, 100        ; tamanho máximo do buffer
    syscall             ; chama o kernel

    ; --- Inicia a avaliação da expressão ---
    mov rdi, expr       ; RDI aponta para o início da string da expressão.
    call eval_expr      ; Chama a função principal de avaliação. O resultado final estará em RAX.

    ; --- Converte o resultado (inteiro) para string ---
    mov rsi, rax        ; Move o resultado de eval_expr (RAX) para RSI, que é o argumento de int_to_str.
    call int_to_str     ; Chama a função de conversão. RAX retornará o comprimento e RSI o ponteiro da string.

    ; --- Imprime o resultado na tela ---
    mov rdx, rax        ; Salva o comprimento da string do resultado (retornado em RAX por int_to_str).
    mov rax, 1          ; syscall 1 (sys_write)
    mov rdi, 1          ; file descriptor 1 (stdout)
    ; RSI já contém o ponteiro para a string do resultado.
    syscall             ; chama o kernel

    ; --- Imprime uma nova linha para formatação ---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Finaliza o programa ---
    mov rax, 60         ; syscall 60 (sys_exit)
    xor rdi, rdi        ; código de saída 0 (sucesso)
    syscall

; =======================================================
; === AVALIADOR RECURSIVO DE EXPRESSÕES (DESCIDA RECURSIVA) ===
; =======================================================
; A gramática implementada é:
; expr   → term (('+' | '-') term)*
; term   → factor (('*' | '/') factor)*
; factor → number | '(' expr ')'
; =======================================================

; eval_expr: Lida com adição e subtração (menor precedência).
eval_expr:
    call eval_term      ; Avalia o primeiro termo e coloca o resultado em RAX.
.expr_loop:
    mov bl, byte [rdi]  ; Pega o caractere atual da expressão.
    cmp bl, '+'         ; É uma adição?
    je .add
    cmp bl, '-'         ; É uma subtração?
    je .sub
    ret                 ; Se não for '+' ou '-', a expressão terminou. Retorna.

.add:
    inc rdi             ; Avança o ponteiro da expressão para depois do '+'.
    push rax            ; Salva o resultado do termo anterior na pilha.
    call eval_term      ; Avalia o próximo termo. O resultado estará em RAX.
    pop rbx             ; Recupera o resultado anterior da pilha para RBX.
    add rax, rbx        ; Soma os dois resultados (RAX = RBX + RAX).
    jmp .expr_loop      ; Volta ao loop para procurar mais operadores.

.sub:
    inc rdi             ; Avança o ponteiro da expressão para depois do '-'.
    push rax            ; Salva o resultado do termo anterior na pilha.
    call eval_term      ; Avalia o próximo termo. O resultado estará em RAX.
    pop rbx             ; Recupera o resultado anterior da pilha para RBX.
    sub rbx, rax        ; Subtrai (RBX = RBX - RAX).
    mov rax, rbx        ; Move o resultado final da subtração para RAX.
    jmp .expr_loop      ; Volta ao loop.

; eval_term: Lida com multiplicação e divisão (maior precedência).
eval_term:
    call eval_factor    ; Avalia o primeiro fator e coloca o resultado em RAX.
.term_loop:
    mov bl, byte [rdi]  ; Pega o caractere atual.
    cmp bl, '*'         ; É uma multiplicação?
    je .mul
    cmp bl, '/'         ; É uma divisão?
    je .div
    ret                 ; Se não for '*' ou '/', o termo terminou. Retorna.

.mul:
    inc rdi             ; Avança o ponteiro para depois do '*'.
    push rax            ; Salva o resultado do fator anterior na pilha.
    call eval_factor    ; Avalia o próximo fator. O resultado estará em RAX.
    pop rbx             ; Recupera o resultado anterior da pilha para RBX.
    imul rax, rbx       ; Multiplica (RAX = RAX * RBX).
    jmp .term_loop      ; Volta ao loop.

.div:
    inc rdi             ; Avança o ponteiro para depois do '/'.
    push rax            ; Salva o resultado do fator anterior na pilha.
    call eval_factor    ; Avalia o próximo fator. O resultado estará em RAX.
    pop rbx             ; Recupera o resultado anterior da pilha para RBX.
    xor rdx, rdx        ; Zera RDX, pois a instrução DIV usa RDX:RAX como dividendo.
    xchg rax, rbx       ; Troca RAX e RBX. Agora RAX é o dividendo e RBX o divisor.
    div rbx             ; Divide RDX:RAX por RBX. O quociente fica em RAX.
    jmp .term_loop      ; Volta ao loop.

; eval_factor: Lida com números e parênteses.
eval_factor:
    mov al, byte [rdi]  ; Pega o caractere atual.
    cmp al, '('         ; É um parêntese de abertura?
    jne .is_number      ; Se não for, assume que é um número.
    ; Se for '(':
    inc rdi             ; Avança o ponteiro para depois do '('.
    call eval_expr      ; Faz uma chamada recursiva para avaliar a expressão dentro dos parênteses.
    inc rdi             ; Avança o ponteiro para pular o ')' de fechamento.
    ret                 ; Retorna com o resultado da sub-expressão em RAX.

.is_number:
    call parse_number   ; Chama a função para converter a string de número em um inteiro.
    mov rax, rbx        ; Move o número convertido (retornado em RBX) para RAX.
    ret                 ; Retorna.

; =======================================================
; === FUNÇÕES UTILITÁRIAS ===
; =======================================================

; parse_number: Converte uma sequência de dígitos ASCII para um inteiro.
; Entrada: RDI aponta para o início do número na string.
; Saída: RBX contém o valor inteiro. RDI aponta para o caractere após o número.
parse_number:
    xor rbx, rbx        ; Zera RBX, que será o acumulador do número.
.parse_loop:
    mov al, byte [rdi]  ; Pega o dígito atual.
    sub al, '0'         ; Converte o caractere ASCII ('0'-'9') para seu valor numérico (0-9).
    cmp al, 9           ; Verifica se o resultado é maior que 9 (ou seja, não era um dígito).
    ja .end             ; Se não for um dígito, termina a conversão.
    imul rbx, 10        ; Multiplica o acumulador por 10 (abre espaço para o novo dígito).
    add rbx, rax        ; Adiciona o novo dígito ao acumulador.
    inc rdi             ; Avança o ponteiro da string.
    jmp .parse_loop     ; Repete para o próximo dígito.
.end:
    ret                 ; Retorna. O número está em RBX.

; int_to_str: Converte um inteiro para uma string ASCII.
; Entrada: RSI = número a ser convertido.
; Saída: RSI = ponteiro para o início da string. RAX = comprimento da string.
int_to_str:
    mov rax, rsi        ; Move o número para RAX para a divisão.
    mov rcx, 10         ; Divisor será 10.
    lea rdi, [result + 11] ; Aponta RDI para o final do buffer de resultado.
    mov byte [rdi], 0   ; Coloca o terminador nulo no final.
    dec rdi             ; Move o ponteiro para a posição do último dígito.

    ; Caso especial: se o número for 0.
    test rax, rax       ; Verifica se RAX é 0.
    jnz .loop           ; Se não for, vai para o loop principal.
    mov byte [rdi], '0' ; Se for 0, coloca '0' no buffer.
    mov rsi, rdi        ; RSI aponta para o '0'.
    mov rax, 1          ; Comprimento é 1.
    ret                 ; Retorna.

.loop:
    xor rdx, rdx        ; Zera RDX para a divisão.
    div rcx             ; Divide RDX:RAX por 10. Quociente em RAX, resto em RDX.
    add dl, '0'         ; Converte o resto (dígito) para seu caractere ASCII.
    mov [rdi], dl       ; Armazena o dígito no buffer.
    dec rdi             ; Move o ponteiro para a esquerda.
    test rax, rax       ; O quociente (em RAX) é zero?
    jnz .loop           ; Se não for, repete o processo.
    
    ; Fim da conversão.
    inc rdi             ; Ajusta o ponteiro para o início do número na string.
    mov rsi, rdi        ; RSI agora aponta para o início da string do resultado.
    mov rax, result + 11 ; Calcula o comprimento da string.
    sub rax, rdi
    ret
