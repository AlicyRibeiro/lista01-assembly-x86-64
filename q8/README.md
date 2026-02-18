# Questão 8 — Multiplicação de Matrizes 3×3 em Assembly (x86-64)

Programa em Assembly NASM que calcula e imprime o resultado da multiplicação de duas matrizes 3×3 definidas na seção `.data`.

O resultado é armazenado em uma terceira matriz e exibido no terminal usando syscalls do Linux.

---

# Objetivo


O propósito deste projeto é implementar manualmente o algoritmo de multiplicação de matrizes para duas matrizes de dimensão $3 \times 3$:

$$C = A \times B$$


Nesta implementação, cada elemento da matriz resultante $C$ é calculado individualmente através do somatório dos produtos entre a linha $i$ da matriz $A$ e a coluna $j$ da matriz $B$:

$$C_{i,j} = \sum_{k=0}^{2} A_{i,k} \cdot B_{k,j}$$

Onde:
* $i$ representa o índice da linha ($0 \dots 2$).
* $j$ representa o índice da coluna ($0 \dots 2$).
* $k$ é o índice auxiliar para o cálculo do produto escalar.

---

# Estratégia Utilizada

O programa segue exatamente a lógica matemática usando três loops aninhados:

- i → percorre as linhas da matriz A
- j → percorre as colunas da matriz B
-  k → calcula o produto escalar entre linha e coluna

Isso simula o algoritmo clássico de multiplicação de matrizes.

---

# Fluxo do Programa

1. Inicializa os índices `i`, `j` e `k`
2. Calcula cada elemento da matriz resultado
3. Armazena o valor em `C`
4. Percorre a matriz resultante
5. Converte cada número para string
6. Imprime no terminal em formato matricial

---

# Estrutura de Memória

## Seção `.data`

- Matrizes de entrada A e B
- Caracteres auxiliares (`newline` e `space`)

## Seção `.bss`

- Matriz resultado C
- Buffer para conversão de números

## Seção `.text`

- Lógica de multiplicação
- Rotina de impressão
- Função de conversão inteiro → string

---

# Como a Multiplicação é Feita

Para acessar elementos das matrizes em memória linear, o índice é calculado como:

```
posição = (linha * 3) + coluna
```

Como cada elemento tem 8 bytes (`dq`), o acesso final é:

```
[endereco + índice * 8]
```
---

# Impressão do Resultado

O programa:

- Converte cada elemento para ASCII
- Imprime os valores separados por espaço
- Quebra linha ao final de cada linha da matriz

Resultado exibido no formato:

```
30 24 18
84 69 54
138 114 90

```
(Resultado da multiplicação das matrizes definidas no código.)

---

# Como Compilar e Executar
```

nasm -f elf64 q8.asm -o q8.o
ld q8.o -o q8
./q8
```

---

# Função `int_to_str`

Responsável por converter um inteiro para string:

- Divide sucessivamente por 10
- Converte restos em ASCII

Retorna:

  - ponteiro da string em `RSI`
  - tamanho em `RAX`

Essa abordagem evita o uso de bibliotecas externas.

---

# Exemplo de Matrizes

Matriz A

```
1 2 3
4 5 6
7 8 9
```
Matriz B
```
9 8 7
6 5 4
3 2 1
```

---

# Resultado Esperado

```
30 24 18
84 69 54
138 114 90

```

---

# Conceitos Trabalhados

- Manipulação de matrizes em memória linear
- Implementação de loops aninhados em Assembly
- Multiplicação e soma acumulada
- Uso de registradores como índices
- Conversão manual de inteiros
- Saída formatada no terminal
