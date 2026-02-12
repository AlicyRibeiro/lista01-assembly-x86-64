;compilação:
;nasm -f elf64 q6v5.asm -o q6v5.o
;ld q6v5.o -o q6v5
;execução:
;./q6v5 -7 4 -9

;Cálculo final: (Soma total) - (Menor número)


section .data
    msg_erro_args db "Erro: Forneca exatamente 3 numeros como argumentos.", 10, 0
    tam_msg_erro equ $ - msg_erro_args
    newline db 10

section .bss
    res_str resb 21         ; Buffer para conversão do resultado para string.

section .text
    global _start

_start:
    ; Verifica se o número de argumentos é 4 (programa + 3 números).
    mov r12, [rsp]
    cmp r12, 4
    jne .erro_args

    ; Converte o primeiro argumento (argv[1]) e armazena em R13.
    mov rdi, [rsp + 16]
    call string_para_inteiro
    mov r13, rax

    ; Converte o segundo argumento (argv[2]) e armazena em R14.
    mov rdi, [rsp + 24]
    call string_para_inteiro
    mov r14, rax

    ; Converte o terceiro argumento (argv[3]) e armazena em R15.
    mov rdi, [rsp + 32]
    call string_para_inteiro
    mov r15, rax

    ; Lógica para achar a soma dos dois maiores: (a+b+c) - min(a,b,c).
    ; 1. Soma todos os números.
    mov rax, r13
    add rax, r14
    add rax, r15

    ; 2. Encontra o menor número.
    mov rbx, r13
    cmp rbx, r14
    cmovg rbx, r14  ; Se rbx > r14, rbx = r14.
    cmp rbx, r15
    cmovg rbx, r15  ; Se rbx > r15, rbx = r15.

    ; 3. Subtrai o menor da soma total.
    sub rax, rbx

    ; Imprime o resultado final.
    mov rdi, rax
    call print_sinalizado

    jmp .fim

.erro_args:
    ; Exibe mensagem de erro se o número de argumentos for incorreto.
    mov rax, 1
    mov rdi, 2 ; Escreve na saída de erro (stderr).
    mov rsi, msg_erro_args
    mov rdx, tam_msg_erro
    syscall

.fim:
    ; Finaliza o programa.
    mov rax, 60
    xor rdi, rdi
    syscall

; Converte uma string (em RDI) para um inteiro com sinal (retorna em RAX).
string_para_inteiro:
    xor rax, rax
    xor rcx, rcx ; Usa RCX como flag de sinal (0 = positivo, 1 = negativo).
    cmp byte [rdi], '-'
    jne .loop
    mov rcx, 1   ; Define a flag como negativo.
    inc rdi      ; Pula o caractere '-'.
.loop:
    movzx rdx, byte [rdi]
    cmp rdx, '0'
    jb .done
    cmp rdx, '9'
    ja .done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rdi
    jmp .loop
.done:
    cmp rcx, 1   ; Verifica se a flag de negativo está ativa.
    jne .ret
    neg rax      ; Se sim, nega o resultado.
.ret:
    ret

; Converte um inteiro com sinal (em RDI) para string e imprime na tela.
print_sinalizado:
    mov rax, rdi            ; Copia o número para RAX para os cálculos.
    mov r11, 0              ; Usa R11 como flag de número negativo (0=não, 1=sim).
    
    mov rsi, res_str + 20   ; Aponta para o final do buffer.
    mov byte [rsi], 0       ; Adiciona o terminador nulo.
    dec rsi
    
    mov rbx, 10             ; Divisor.
    mov rcx, 0              ; Contador de dígitos.

    test rax, rax
    jz .handle_zero         ; Se o número for 0, trata separadamente.

    jns .convert_loop       ; Se o número não for negativo (jump if not sign), pula.
    
    ; Se for negativo:
    mov r11, 1              ; Ativa a flag de negativo.
    neg rax                 ; Torna o número positivo para a conversão.

.convert_loop:
    xor rdx, rdx
    div rbx                 ; Divide RAX por 10, resto em RDX.
    add rdx, '0'            ; Converte o dígito para caractere ASCII.
    mov [rsi], dl           ; Armazena o dígito no buffer.
    dec rsi
    inc rcx
    test rax, rax
    jnz .convert_loop
    jmp .add_sign_if_needed

.handle_zero:
    mov byte [rsi], '0'
    dec rsi
    inc rcx

.add_sign_if_needed:
    ; Verifica a flag para ver se precisa adicionar o sinal de '-'.
    cmp r11, 1
    jne .print_string
    mov byte [rsi], '-'
    dec rsi
    inc rcx

.print_string:
    inc rsi                 ; Ajusta o ponteiro para o início do número na string.
    
    ; Imprime o número.
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx            ; RCX contém o número de caracteres a imprimir.
    syscall
    
    ; Imprime a quebra de linha.
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ret