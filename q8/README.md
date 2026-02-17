# Questão 8 — Multiplicação de Matrizes 3×3 em Assembly (x86-64)

Programa em Assembly NASM que calcula e imprime o resultado da multiplicação de duas matrizes 3×3 definidas na seção .data.

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

1. Inicializa os índices i, j e k
2. Calcula cada elemento da matriz resultado
3. Armazena o valor em C
4. Percorre a matriz resultante
5. Converte cada número para string
6. Imprime no terminal em formato matricial

---

# Estrutura de Memória

## Seção .data

- Matrizes de entrada A e B
- Caracteres auxiliares (newline e space)

## Seção .bss

- Matriz resultado C
- Buffer para conversão de números

## Seção .text

- Lógica de multiplicação
- Rotina de impressão
- Função de conversão inteiro → string

---

# 
