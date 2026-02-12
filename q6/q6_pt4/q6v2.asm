; Objetivo: Ler três números passados como argumentos de linha de comando,
;           somar os dois maiores e imprimir o resultado.
;
; Compilação: 
; nasm -f elf64 q6v2.asm -o q6v2.o
; ld q6v2.o -o q6v2
;
; Execução:
; ./q6v2 10 25 5

section .data
    msg_erro_args db "Erro: Forneca exatamente 3 numeros como argumentos.", 10, 0
    tam_msg_erro equ $ - msg_erro_args
    newline db 10

section .bss
    res_str resb 21         ; Buffer para armazenar o resultado convertido para string.

section .text
    global _start

_start:
    ; A pilha (RSP) no início contém os argumentos da linha de comando:
    ; [rsp]      -> argc (contador de argumentos)
    ; [rsp + 8]  -> argv[0] (ponteiro para o nome do programa, ex: "./q6v2")
    ; [rsp + 16] -> argv[1] (ponteiro para o primeiro argumento, ex: "10")
    ; [rsp + 24] -> argv[2] (ponteiro para o segundo argumento, ex: "25")
    ; [rsp + 32] -> argv[3] (ponteiro para o terceiro argumento, ex: "5")

    ; Verifica se o número de argumentos (argc) é exatamente 4.
    mov rax, [rsp]
    cmp rax, 4
    jne .erro_args              ; Se não for 4, pula para a rotina de erro.

    ; --- Converte os argumentos de string para inteiro ---

    ; Converte o primeiro argumento numérico (argv[1])
    mov rdi, [rsp + 16]         ; Carrega o endereço de argv[1] em RDI (argumento para a função).
    call string_para_natural    ; Converte a string para inteiro, resultado em RAX.
    mov r13, rax                ; Armazena o primeiro número em R13.

    ; Converte o segundo argumento (argv[2])
    mov rdi, [rsp + 24]         ; Carrega o endereço de argv[2] em RDI.
    call string_para_natural
    mov r14, rax                ; Armazena o segundo número em R14.

    ; Converte o terceiro argumento (argv[3])
    mov rdi, [rsp + 32]         ; Carrega o endereço de argv[3] em RDI.
    call string_para_natural    
    mov r15, rax                ; Armazena o terceiro número em R15.

    ; --- Lógica para somar os dois maiores ---
    ; Estratégia: (soma de todos) - (o menor) = (soma dos dois maiores)

    ; 1. Calcula a soma total dos três números.
    mov rax, r13
    add rax, r14
    add rax, r15

    ; 2. Encontra o menor dos três para subtrair da soma total.
    ;    (Lógica original corrigida para maior clareza e correção).
    mov rbx, r13                ; Assume que o primeiro (r13) é o menor.
    cmp rbx, r14                ; Compara o menor atual (rbx) com o segundo número (r14).
    cmovg rbx, r14              ; Se rbx > r14, então r14 é o novo menor (rbx = r14).
    cmp rbx, r15                ; Compara o menor atual (rbx) com o terceiro número (r15).
    cmovg rbx, r15              ; Se rbx > r15, então r15 é o novo menor (rbx = r15).
                                ; Agora, RBX contém o menor dos três números.

    ; 3. Subtrai o menor da soma total. O resultado em RAX é a soma dos dois maiores.
    sub rax, rbx

    ; --- Imprime o resultado final ---
    mov rdi, rax                ; Move o resultado para RDI, o argumento de print_natural.
    call print_natural

    jmp .fim                    ; Pula para o final do programa.

.erro_args:
    ; Rotina para exibir mensagem de erro se o número de argumentos for inválido.
    mov rax, 1                  ; syscall 1 (sys_write)
    mov rdi, 2                  ; file descriptor 2 (stderr - saída de erro padrão).
    mov rsi, msg_erro_args      ; Ponteiro para a mensagem de erro.
    mov rdx, tam_msg_erro       ; Comprimento da mensagem.
    syscall

.fim:
    ; Finaliza o programa com sucesso.
    mov rax, 60                 ; syscall 60 (sys_exit)
    xor rdi, rdi                ; Código de saída 0.
    syscall

; ---------------------------------------------
; Função: string_para_natural
; Converte uma string de dígitos (terminada por um não-dígito) para um inteiro.
; Entrada: RDI = ponteiro para o início da string.
; Saída: RAX = valor inteiro convertido.
; ---------------------------------------------
string_para_natural:
    xor rax, rax                ; Zera RAX, o acumulador do resultado.
.loop:
    movzx rdx, byte [rdi]       ; Carrega um caractere da string em RDX, zerando os bits superiores.
    cmp rdx, '0'                ; É menor que '0'?
    jb .done                    ; Se sim, não é um dígito, fim.
    cmp rdx, '9'                ; É maior que '9'?
    ja .done                    ; Se sim, não é um dígito, fim.
    
    sub rdx, '0'                ; Converte o caractere ASCII para seu valor numérico.
    imul rax, 10                ; Multiplica o acumulador por 10.
    add rax, rdx                ; Adiciona o novo dígito.
    inc rdi                     ; Avança para o próximo caractere.
    jmp .loop
.done:
    ret

; ---------------------------------------------
; Função: print_natural
; Converte um inteiro sem sinal para string e a imprime na tela.
; Entrada: RDI = número a ser impresso.
; Saída: Nenhuma.
; ---------------------------------------------
print_natural:
    mov rsi, res_str + 20       ; Aponta RSI para o final do buffer de string.
    mov byte [rsi], 0           ; Coloca um terminador nulo (boa prática).
    dec rsi                     ; Move o ponteiro para a posição do último dígito.
    mov rbx, 10                 ; Divisor para a conversão.
    mov rcx, 0                  ; Zera RCX, o contador de dígitos.

    ; Trata o caso especial se o número de entrada for zero.
    test rdi, rdi
    jnz .loop_convert
    mov byte [rsi], '0'         ; Coloca '0' no buffer.
    inc rcx                     ; Conta 1 dígito.
    jmp .imprimir

.loop_convert:
    xor rdx, rdx                ; Zera RDX para a divisão (RDX:RAX).
    mov rax, rdi                ; Move o número a ser dividido para RAX.
    div rbx                     ; Divide por 10. Quociente em RAX, resto em RDX.
    add dl, '0'                 ; Converte o resto (dígito) para ASCII.
    mov [rsi], dl               ; Armazena o dígito no buffer.
    dec rsi                     ; Move o ponteiro do buffer para a esquerda.
    inc rcx                     ; Incrementa o contador de dígitos.
    mov rdi, rax                ; O novo número a ser dividido é o quociente.
    test rdi, rdi               ; O quociente é zero?
    jnz .loop_convert           ; Se não, continua o loop.

.imprimir:
    inc rsi                     ; Ajusta o ponteiro para o início do número na string.
    mov rax, 1                  ; syscall 1 (sys_write)
    mov rdi, 1                  ; stdout
    mov rdx, rcx                ; RDX é o número de caracteres a imprimir.
    syscall

    ; Imprime uma nova linha para formatação.
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret