#  Questão 3 – Impressão de Vetor de Inteiros (Integração C + Assembly)

##  Objetivo

Implementar uma função em Assembly x86-64 chamada:

```c
void print_array_int(int *vetor, int tamanho);
```

Essa função deve:
- Receber um ponteiro para um vetor de inteiros
- Receber o tamanho do vetor
- Percorrer o vetor
- Imprimir cada elemento utilizando `printf`

A função é chamada a partir de um programa escrito em C, demonstrando integração entre C e Assembly.

---

# Conceitos Envolvidos

Esta questão demonstra:

- Convenção de chamada System V AMD64 ABI
- Integração entre C e Assembly
- Uso de registradores preservados (callee-saved)
- Manipulação de vetores em Assembly
- Chamada de função externa (`printf`)
- Uso de seção `.rodata`

---

# Convenção de Chamada (System V AMD64)

No Linux x86-64, os argumentos de função são passados assim:
| Argumento | Registrador |
| --------- | ----------- |
| 1º        | RDI         |
| 2º        | RSI         |
| 3º        | RDX         |
| 4º        | RCX         |
| 5º        | R8          |
| 6º        | R9          |

Portanto:
```
print_array_int(int *vetor, int tamanho);

```
Recebe:
- `RDI`→ ponteiro para vetor
- `RSI`→ tamanho

---

# Código Assembly – Explicação Detalhada

## Declarações Globais

```
global print_array_int
extern printf
```

- `global` → torna a função visível para o linker
- `extern printf` → indica que `printf` está em outra unidade (libc)

---

## Prólogo da Função
```
push rbp
mov rbp, rsp
push rbx
push r12
push r13
```

Objetivo:
Salvar registradores que precisam ser preservados.

Segundo a ABI:

- `rbx`, `rbp`, `r12–r15` → callee-saved
- Devem ser restaurados antes do `ret`

---

# Preservando Argumentos
```
mov r12, rdi
mov r13, rsi
```

- r12 guarda o ponteiro do vetor
- r13 guarda o tamanho

Isso é importante porque printf pode modificar rdi e rsi.

---

# Loop de Impressão
```
xor rbx, rbx
```

`rbx` será o contador `i`.

## Condição do Loop
```
cmp rbx, r13
jge .fim
```

Equivalente em C:
```
while (i < tamanho)
```

## Acessando vetor[i]
```
movsxd rsi, dword [r12 + rbx*4]

```
Explicação:
- `r12` → base do vetor
- `rbx*4` → cada `int` ocupa 4 bytes
- `movsxd` → move inteiro 32 bits para 64 bits com extensão de sinal

Isso é necessário porque `printf` espera argumento de 64 bits.

---

# Preparando printf
```
lea rdi, [rel fmt_int]
xor rax, rax
call printf
```

Argumentos:

| Registrador | Valor                                   |
| ----------- | --------------------------------------- |
| RDI         | ponteiro para "%d\n"                    |
| RSI         | valor do vetor                          |
| RAX         | 0 (obrigatório para funções variádicas) |

Importante:

Para funções variádicas como printf, é obrigatório zerar RAX.

---

# Incremento
```
inc rbx
jmp .loop
```

Incrementa índice.

---

# Epílogo da Função
```
pop r13
pop r12
pop rbx
pop rbp
ret
```

Restaura registradores preservados.

---

# Seção `.rodata`

```
section .rodata
fmt_int db "%d", 10, 0
```

Define string de formato:
```
"%d\n"
```

- `10` → nova linha (`\n`)
- `0` → terminador nulo

---

#  Código C (Integração)
```
void print_array_int(int *vetor, int tamanho);
```

A função é declarada, mas implementada em Assembly.

O programa:
1. Cria dois vetores
2. Soma os vetores
2. Chama a função Assembly para imprimir o resultado

--- 

# Fluxo Completo

1. main() cria vetores
2. soma_array() calcula soma
3. print_array_int() (Assembly) imprime
4. printf() é chamada dentro do Assembly

---

# Conceitos Demonstrados

- ABI System V
- Callee-saved registers
- Integração C + Assembly
- Acesso a vetor via aritmética de ponteiros
- Extensão de sinal (`movsxd`)
- Uso correto de função variádica
- Organização de prólogo/epílogo

---

# Equivalente em C

O loop em Assembly é equivalente a:

```
for (int i = 0; i < tamanho; i++) {
    printf("%d\n", vetor[i]);
}
```

---

# Conclusão

Esta questão demonstra a integração real entre C e Assembly, respeitando:
- Convenção de chamadas
- Preservação de registradores
- Organização de stack frame
- Comunicação com biblioteca padrão

É um exemplo clássico de como funções críticas podem ser implementadas em Assembly e chamadas a partir de programas em C.
