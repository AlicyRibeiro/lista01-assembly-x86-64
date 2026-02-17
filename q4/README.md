#  Questão 4 – Soma dos Dois Maiores (Inteiros Não Sinalizados)

##  Objetivo

Desenvolver um programa em Assembly x86-64 que:

1. Receba **três números inteiros não sinalizados** definidos na seção `.data`
2. Identifique os **dois maiores valores**
3. Calcule a soma entre eles
4. Imprima o resultado na tela

---

#  Conceitos Trabalhados

Esta questão envolve:

- Comparação de inteiros
- Ordenação simples com trocas (`xchg`)
- Manipulação de registradores
- Conversão de inteiro para string
- Uso de syscalls Linux
- Organização de código em função reutilizável

---

#  Estrutura de Memória

##  Seção `.data`

```asm
num1 dw 8
num2 dw 4
num3 dw 10
```

- dw → inteiro de 16 bits sem sinal
- Valores são carregados com extensão para 64 bits

Mensagem exibida:
```
msg db "Soma dos dois maiores: ", 0
msg_len equ $ - msg
```

equ calcula o tamanho da string em tempo de montagem.

## Seção `.bss`
```
num_buffer resb 12
```
Buffer usado para converter o número resultante em string.

---

# Fluxo Geral do Programa

1. Carrega os números nos registradores
2. Ordena os valores
3. Soma os dois maiores
4. Imprime mensagem
5. Converte número para string
6. Imprime resultado
7. Finaliza o programa

---

# Carregamento dos Valores
```
movzx rax, word [num1]
movzx rbx, word [num2]
movzx rcx, word [num3]
```

Por que usar movzx?

`movzx` → Move com zero extension

Como os valores são de 16 bits, eles são expandidos para 64 bits.

---

# Lógica de Ordenação

A estratégia utilizada é uma ordenação simples baseada em comparações e trocas.

## Primeira comparação
```
cmp rax, rbx
jle .check2
xchg rax, rbx
```

Garante:
```
RAX ≤ RBX
```

## Segunda comparação

```
cmp rbx, rcx
jle .check3
xchg rbx, rcx
```

Garante:
```
RBX ≤ RCX
```

## Ajuste final
```
cmp rax, rbx
jle .sum
xchg rax, rbx
```

Após essas etapas:
```
RAX → menor
RBX → segundo maior
RCX → maior
```

---

# Soma dos Dois Maiores
```
add rbx, rcx
```

Resultado final fica em `RBX`.

---

# Impressão da Mensagem
```
mov rax, 1
mov rdi, 1
mov rsi, msg
mov rdx, msg_len
syscall
```

Syscall `write `:

| Registrador | Função               |
| ----------- | -------------------- |
| RAX         | 1                    |
| RDI         | 1 (stdout)           |
| RSI         | ponteiro para string |
| RDX         | tamanho              |

---

# Conversão do Número para String
```
mov rax, rbx
mov rdi, num_buffer
call imprime_inteiro
```

A função imprime_inteiro:

1. Divide o número sucessivamente por 10
2. Converte cada dígito para ASCII
3. Armazena no buffer em ordem reversa
4. Imprime usando sys_write

---

# Algoritmo da Função imprime_inteiro

## Inicialização

```
mov rcx, 10
mov rsi, num_buffer + 10
```

- `rcx` → divisor
- `rsi` → ponteiro para final do buffer

## Caso especial zero
```
cmp eax, 0
jne .loop
```

Se o valor for zero, escreve `'0'`.

## Loop de conversão

```
div rcx
add dl, '0'
mov [rsi], dl
```

- Resto → dígito
- Convertido para ASCII

## Impressão

O tamanho da string é calculado dinamicamente:
```
mov rdx, num_buffer
add rdx, 11
sub rdx, rsi
```

Depois é feita a syscall `write`.

---

# Finalização

```
mov rax, 60
xor rdi, rdi
syscall
```

Chamada de sistema `exit`.

---

# Complexidade

- Comparações: O(1)
- Conversão numérica: O(d) (dígitos)

---

# Conclusão

O programa demonstra uma abordagem eficiente para encontrar os dois maiores valores entre três números sem usar estruturas complexas.

Além disso, reforça conceitos fundamentais de Assembly:

- Comparações e saltos condicionais
- Troca de registradores
- Conversão manual de números
- Uso direto de chamadas de sistema
