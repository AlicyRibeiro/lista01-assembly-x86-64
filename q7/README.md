# Questão 7 — Determinante de Matriz 3×3 em Assembly (x86-64)

Programa em Assembly NASM que calcula e imprime o determinante de uma matriz 3×3 com inteiros sinalizados, definida diretamente na seção `.data`.

---

# Objetivo

Implementar o cálculo do determinante utilizando operações aritméticas em registradores, sem bibliotecas externas, e exibir o resultado no terminal usando syscalls do Linux.

---

# Fórmula do Determinante

Para uma matriz $A$ definida como:

$$
A = \begin{pmatrix} 
a_{11} & a_{12} & a_{13} \\ 
a_{21} & a_{22} & a_{23} \\ 
a_{31} & a_{32} & a_{33} 
\end{pmatrix}
$$


## Cálculo do Determinante

O determinante é calculado através da seguinte fórmula:

$$
\text{det} = a_{11}(a_{22}a_{33} - a_{23}a_{32}) - a_{12}(a_{21}a_{33} - a_{23}a_{31}) + a_{13}(a_{21}a_{32} - a_{22}a_{31})
$$



O código implementa exatamente essa **expansão por cofatores da primeira linha**.


---

# Lógica do Programa

1️. Carrega os 9 elementos da matriz da memória para registradores

2️. Calcula os cofatores:

C11 = a22·a33 − a23·a32

C12 = a21·a33 − a23·a31

C13 = a21·a32 − a22·a31

3️. Calcula o determinante:

````
det = a11*C11 − a12*C12 + a13*C13

````
4️. Converte o valor para string

5️. Imprime o resultado no terminal

---

# Estrutura do Código
````
section .data   → matriz e newline
section .bss    → buffer de saída
section .text   → lógica e funções
````
## Principais Partes

- _start → fluxo principal
- print → converte número para ASCII
- print_newline → imprime quebra de linha​

--- 

# Como Compilar e Executar
````
nasm -f elf64 q7.asm -o q7.o
ld q7.o -o q7
./q7
````

---

# Exemplo de Entrada (definida no código)
````
matriz dq 0,1,2
       dq 3,4,5
       dq 6,7,8
````
---

# Saída Esperada
````
0
````

(Essa matriz possui determinante zero, pois as linhas são linearmente dependentes.)

---

# Conceitos Envolvidos

- Manipulação de matrizes em memória linear
- Operações aritméticas com imul
- Uso de registradores de propósito geral
- Chamadas de sistema (write e exit)
- Conversão manual de inteiro para string
- Organização de programa Assembly no Linux
