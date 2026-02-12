#  Questão 2 – Impressão de Inteiro Sinalizado (x86-64 NASM)

##  Objetivo

Criar uma função em Assembly x86-64 capaz de imprimir na tela um número inteiro **sinalizado (signed)** definido na seção `.data`, independentemente da quantidade de dígitos.

Diferente da Questão 1 (não sinalizado), aqui é necessário tratar:

- Números positivos
- Números negativos
- O caso especial do zero

---

#  Conceito Principal

A conversão de inteiro para string é feita através de **divisões sucessivas por 10**.

Para números negativos:

1. Detectamos o sinal
2. Armazenamos que o número era negativo
3. Convertimos o valor para positivo usando `neg`
4. Após converter os dígitos, adicionamos o caractere `'-'`

---

#  Estrutura do Programa

##  Seção `.data`

```asm
section .data
    num dq -2025
```

- `dq` define um inteiro de 64 bits
- O número pode ser positivo ou negativo

## Seção `.bss`

```
section .bss
    saida resb 22
```

Reserva 22 bytes:

- Até 19 dígitos (signed 64 bits)
- 1 caractere de sinal (`-`)
- 1 nova linha (`\n`)
- Espaço extra de segurança

## Seção `.text`
```
global _start
```

Define o ponto de entrada do programa.

---

# Fluxo do Programa

## Início
```
mov rax, [num]
call print_sinal
```

- O valor é carregado em `RAX`
- `RAX` é usado como argumento da função

Finalização:
```
mov rax, 60
xor rdi, rdi
syscall
```

- `rax` = 60 → syscall `exit`
- `rdi` = 0 → código de saída

---

# Função print_sinal – Explicação Detalhada

## Salvando Registradores
```
push rax
push rcx
push rdx
push rdi
push rsi
push rbx
```

Preserva registradores utilizados na função.

## Preparação do Buffer
```
mov rdi, saida + 20
mov byte [rdi], 10
dec rdi
```

- Posiciona o ponteiro no final do buffer
- Insere `\n`
- Move para posição do último dígito

---

# Caso Especial: Zero
```
cmp rax, 0
jne veri_sinal
mov byte [rdi], '0'
dec rdi
jmp print_string
Se o número for zero:
```
- Insere `'0'`
- Vai direto para impressão

---

# Verificação de Sinal

```
test rax, rax
jns positivo
mov r10, 1
neg rax
```

## Como funciona:
- `test rax, rax` verifica se é negativo
- `jns` → jump if not sign (salta se positivo)
- Se for negativo:
    - `r10 = 1` indica que havia sinal negativo
    - `neg rax` transforma em positivo

⚠ O `neg` calcula complemento de dois.

---

# Loop de Conversão
```
loop_conv:
    xor rdx, rdx
    mov rbx, 10
    div rbx
```
A instrução:
```
div rbx
```
Divide:
```
RDX:RAX ÷ RBX
```
Resultado:

- Quociente → `RAX`
- Resto → `RDX`

## Conversão para ASCII
```
add rdx, '0'
mov byte [rdi], dl
```

Transforma o dígito numérico em caractere ASCII.


## Atualização
```
dec rdi
inc rcx
```

- Move o ponteiro
- Conta quantidade de dígitos

## Condição de parada
```
cmp rax, 0
jne loop_conv
```

Quando o quociente vira zero, termina a conversão.

---

# Inserindo o Sinal Negativo
```
cmp r10, 1
jne print_string

mov byte [rdi], '-'
dec rdi
inc rcx
```

Se o número era negativo:
- Insere `'-'`
- Incrementa contador

---

# Impressão da String
```
inc rdi
mov rsi, rdi
mov rdx, rcx
add rdx, 1
```

Registradores para `write`:

| Registrador | Função             |
| ----------- | ------------------ |
| RAX         | 1 (sys_write)      |
| RDI         | 1 (stdout)         |
| RSI         | endereço da string |
| RDX         | tamanho            |

Execução:
```
mov rax, 1
mov rdi, 1
syscall
```

---

# Final da Função
```
pop rbx
pop rsi
pop rdi
pop rdx
pop rcx
pop rax
ret
```

Restaura registradores e retorna.

---

# Conceitos Demonstrados
- Manipulação de inteiros sinalizados
- Detecção de sinal com `test`
- Uso da instrução `neg`
- Conversão manual inteiro → string
- Uso da instrução `div`
- Manipulação de buffer reverso
- Uso de syscalls Linux (`write`, `exit`)
- Controle de fluxo com labels

---

# Complexidade

- Tempo: O(d) onde d é o número de dígitos
- Espaço: 22 bytes fixos

---

# Conclusão

Esta implementação demonstra como tratar números sinalizados em baixo nível, incluindo:

- Identificação do sinal
- Conversão para valor absoluto
- Inserção manual do caractere negativo
- Impressão usando chamadas de sistema

Na prática, este código mostra como funções como:
```
printf("%ld", num);
```

são implementadas internamente em nível de arquitetura.
