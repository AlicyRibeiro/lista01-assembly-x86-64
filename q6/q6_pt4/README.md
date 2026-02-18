# Questão 6 — Soma dos Dois Maiores (Assembly x86-64)

Implementação em Assembly NASM de um programa que lê três números inteiros e calcula a soma dos dois maiores valores.

A questão foi resolvida em três versões, cada uma explorando uma forma diferente de entrada de dados:

- Entrada pelo teclado
- Argumentos de linha de comando
- Leitura de arquivo

---

# Objetivo

Dado três números:
```
a, b, c
```

O programa deve calcular:
```
soma = (a + b + c) − menor(a, b, c)
```

Ou seja, remove o menor valor e soma os outros dois.

---

# Estratégia Utilizada

Ao invés de comparar todos os pares, o algoritmo:

1. Soma os três números
2. Descobre qual é o menor
3. Subtrai o menor da soma total

Isso reduz a lógica e evita múltiplas comparações.

---

# ➡️ Versão 1 — Entrada pelo Teclado (q6v1.asm)

  ## Funcionamento

1. Exibe prompts solicitando os três números
2. Lê cada valor usando syscall read
3. Converte a string para inteiro
4. Calcula a soma dos dois maiores
5. Converte o resultado para string
6. Imprime na tela

---

# Destaques Técnicos

- Função ler_inteiro

    - Converte ASCII → inteiro
    - Multiplica por 10 a cada dígito

- Uso dos registradores:

| Registrador | Uso             |
| ----------- | --------------- |
| R8          | Primeiro número |
| R9          | Segundo número  |
| R10         | Terceiro número |
| R11         | Menor valor     |

---

# Compilação e Execução

```
nasm -f elf64 q6v1.asm -o q6v1.o
ld q6v1.o -o q6v1
./q6v1
```

---

# ➡️ Versão 2 — Argumentos de Linha de Comando (`q6v2.asm`)

  ## Funcionamento

Os números são passados diretamente ao executar o programa:
```
./q6v2 10 25 5
```

O programa:

1. Verifica se existem exatamente 3 argumentos
2. Converte cada string para inteiro
3. Calcula a soma dos dois maiores
4. Imprime o resultado

--- 

# Destaques Técnicos
  ## Acesso aos argumentos

Na stack inicial:

| Posição    | Conteúdo |
| ---------- | -------- |
| `[rsp]`    | argc     |
| `[rsp+16]` | argv[1]  |
| `[rsp+24]` | argv[2]  |
| `[rsp+32]` | argv[3]  |

---

# `Funções`

- `string_para_natural` → string → inteiro
- `print_natural` → inteiro → string

---

# Compilação e Execução
```
nasm -f elf64 q6v2.asm -o q6v2.o
ld q6v2.o -o q6v2
./q6v2 10 25 5
```

---

# ➡️ Versão 3 — Leitura de Arquivo (q6v3.asm)
 ## Funcionamento

O programa lê três números do arquivo:
```
numeros.txt
```

Exemplo do arquivo:
```
10
25
5
```

Etapas:

1. Abre o arquivo com syscall open
2. Lê o conteúdo para um buffer
3. Extrai os três números
4. Calcula a soma dos dois maiores
5. Converte para string
6. Imprime com mensagem

--- 

#  Destaques Técnicos
 ## Syscalls utilizadas

| Syscall | Função         |
| ------- | -------------- |
| `open`  | abrir arquivo  |
| `read`  | ler conteúdo   |
| `close` | fechar arquivo |

---

# Funções auxiliares

- `inteiro_nao_sinalizado` → lê número do buffer
- `string_nao_sinalizado` → converte inteiro para string

--- 

# Compilação e Execução
```
nasm -f elf64 q6v3.asm -o q6v3.o
ld q6v3.o -o q6v3
./q6v3
```

--- 

# Exemplos de Execução

Entrada
```
10 25 5
```

Saída
```
35
```

---


# Conceitos Trabalhados

- Manipulação de entrada e saída em Assembly
- Conversão ASCII ↔ inteiro
- Uso da pilha e registradores
- Syscalls do Linux
- Leitura de argumentos
- Leitura de arquivos
- Comparação e lógica condicional

---

# Comparação das Versões

| Versão | Tipo de Entrada | Complexidade | Conceitos principais |
| ------ | --------------- | ------------ | -------------------- |
| V1     | Teclado         | ⭐⭐           | IO básica            |
| V2     | Argumentos      | ⭐⭐⭐          | Stack e argc         |
| V3     | Arquivo         | ⭐⭐⭐⭐         | Syscalls de arquivo  |
