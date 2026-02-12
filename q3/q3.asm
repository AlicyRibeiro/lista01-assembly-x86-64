section .text
    global print_array_int
    extern printf

print_array_int:
    ; --- Prólogo da Função ---
    ; Salva os registradores que serão modificados e que precisam ser preservados
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13

    ; --- Lógica Principal ---
    
    ; 1. Copia os argumentos de entrada para registradores seguros ("callee-saved")
    mov r12, rdi        ; r12 agora guarda o ponteiro para o vetor
    mov r13, rsi        ; r13 agora guarda o tamanho do vetor
    
    xor rbx, rbx        ; zera nosso contador de loop 'i' (em rbx)

.loop:
    ; 2. O loop agora usa os registradores seguros para seu controle
    cmp rbx, r13        ; compara i < tamanho
    jge .fim            ; se for maior ou igual, termina

    ; 3. Prepara os argumentos para 'printf' SOMENTE antes da chamada
    lea rdi, [rel fmt_int]             ; 1º arg para printf: o formato "%d\n"
    movsxd rsi, dword [r12 + rbx*4]    ; 2º arg para printf: o valor de vetor[i]
    xor rax, rax                       ; Necessário para funções variádicas como a printf

    call printf
    
    ; A 'printf' pode ter alterado rdi e rsi, mas não importa, pois
    ; nossos dados importantes estão a salvo em r12 e r13.
    
    inc rbx             ; i++
    jmp .loop

.fim:
    ; --- Epílogo da Função ---
    ; Restaura os registradores na ordem inversa em que foram salvos
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

section .rodata
    ; String de formato para printf: imprime um inteiro e uma quebra de linha
    fmt_int db "%d", 10, 0



;explicação:
; O código acima implementa uma função em Assembly que imprime os elementos de um vetor de inteiros.
; A função `print_array_int` recebe dois argumentos: um ponteiro para o vetor e
; o tamanho do vetor. Ela utiliza um loop para iterar sobre os elementos do vetor, imprimindo cada um deles usando a função `printf`.
; Os registradores são usados para armazenar temporariamente os valores necessários, e o código garante
; que os registradores importantes sejam preservados durante a execução da função.