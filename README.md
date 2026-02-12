#  Organização de Computadores e Linguagem de Montagem I - Lista de Exercícios 01

Este repositório contém as soluções para a primeira lista de exercícios da disciplina de Organização de Computadores e Linguagem de Montagem I. Os programas foram desenvolvidos em **Assembly (NASM)** para a arquitetura **x86-64** e são compatíveis com o sistema operativo **Linux**.

---

##  Conteúdo das Questões

Aqui está um resumo do objetivo de cada questão presente neste projeto:

###  Questão 1
Função em Assembly que imprime um número inteiro **não sinalizado** de 64 bits, definido na seção `.data`.

### Questão 2
Função que imprime um número inteiro **sinalizado** de 64 bits, tratando valores negativos corretamente.

### Questão 3
Reimplementação do exemplo de soma de vetores:
- Lógica principal em **C**
- Rotina de impressão implementada em **Assembly**
- Demonstra interoperabilidade entre C e Assembly

### Questão 4
Programa que recebe 3 números inteiros **não sinalizados** e imprime a soma dos dois maiores.

###  Questão 5
Versão da Q4 para números **sinalizados**.

###  Questão 6
Variações das questões 4 e 5 com diferentes formas de entrada:

- Versão 1: Entrada via prompt interativo
- Versão 2: Argumentos de linha de comando
- Versão 3: Leitura a partir de arquivo

###  Questão 7
Cálculo do determinante de uma matriz 3x3 de inteiros sinalizados.

###  Questão 8
Multiplicação de duas matrizes 3x3.

###  Questão 9
Avaliador de expressões numéricas simples com:
- +, -, *, /
- Respeito à precedência
- Uso de parênteses

---

## Estrutura dos Ficheiros

```bash
.
├── Makefile # Makefile principal (compila Q1, Q2, Q4, Q5, Q7, Q8, Q9)
├── q1/
│ ├── q1.asm
│ └── Makefile
├── q2/
│ ├── q2.asm
│ └── Makefile
├── q3/
│ ├── main.c
│ ├── q3.asm
│ └── Makefile
├── q4/
│ ├── q4.asm
│ └── Makefile
├── q5/
│ ├── q5.asm
│ └── Makefile
├── q6/
├── q6_pt4/  → Baseada na Q4 (não sinalizados)
│   ├── q6v1.asm  (Entrada via prompt)
│   ├── q6v2.asm  (Argumentos linha de comando)
│   └── q6v3.asm  (Leitura de arquivo)
│
└── q6_pt5/  → Baseada na Q5 (sinalizados)
│    ├── q6v4.asm  (Entrada via prompt)
│    ├── q6v5.asm  (Argumentos linha de comando)
│    └── q6v6.asm  (Leitura de arquivo)
├── q7/
│ ├── q7.asm
│ └── Makefile
├── q8/
│ ├── q8.asm
│ └── Makefile
└── q9/
├── q9.asm
└── Makefile
```

---

## Ferramentas Utilizadas

* **Montador:** NASM (The Netwide Assembler)
* **Linker:** LD (GNU Linker)
* **Compilador C:** GCC (Para a Questão 3)

---

##  Clonando o Repositório

Para obter os arquivos do projeto, você pode clonar este repositório usando o seguinte comando no seu terminal:

```bash
git clone [https://github.com/AlicyRIbeiro/exercicios-assembly-lista-01.git](https://github.com/AlicyRibeiro/exercicios-assembly-lista-01.git)
```

Depois de clonar, entre na pasta do projeto:

```bash
cd exercicios-assembly-lista-01
```

---

##  Como Compilar individualmente

Pode compilar os projetos individualmente ou todos de uma vez, utilizando os Makefiles fornecidos.


* Exemplo (Questão 1):

```bash
cd q1
make
./q1
```

* Questão 3

```bash
cd q3
make
./programa
```

* Questão 6 (Exemplo números sinalizados)

    Versão 1 – Prompt
```bash
cd q6/q6_pt5
make
./q6v4
```

* Versão 2 – Argumentos
```bash
./q6v5 10 -50 22
```

* Versão 3 – Arquivo

Arquivo `entrada.txt`:
```bash
-10
-20
-30
```

Execução:
```
./q6v6 entrada.txt
```

## Compilação Geral 

Para compilar as questões principais (1, 2, 4, 5, 7, 8, 9).

No diretório raiz do projeto, execute:

```bash
make
```

Isso irá gerar os executáveis dentro de cada pasta correspondente.

a execução é feita assim:

```
./q1/q1
./q2/q2
./q4/q4
./q5/q5
./q7/q7
./q8/q8
./q9/q9
```


### Questão 3 (Integração C + Assembly)

A q3 possui um Makefile próprio.

Entre na pasta:

```bash
cd q3/
make
```

Depois execute:
```
./programa
```

Se o executável tiver outro nome, verifique com:
```
ls
```

### Questão 6

Cada subdiretório possui seu próprio Makefile.

Parte não sinalizada
```
cd q6/q6_pt4
make
./q6v1
```
Parte sinalizada
```
cd q6/q6_pt5
make
./q6v4
```


### Questão 9 – Avaliador de Expressões
```
./q9/q9
```

O programa solicitará a expressão:
```
(100 - 20) / 4

```
---

## Conceitos Trabalhados


### Arquitetura x86-64

  * Convenção System V AMD64
  * Uso de registradores
  * Manipulação de pilha
  * Saltos condicionais
  * Controle de fluxo em baixo nível

### Manipulação Numérica
  
  * Conversão manual inteiro → string
  * Divisão com div e idiv
  * Tratamento de sinal
  * Operações matriciais

### Syscalls Linux

 * `read`
 * `write`
 * `exit`
 * Manipulação de buffers


### Integração C + Assembly

  * Linkagem com GCC
  * Modularização de código
  * Interoperabilidade

---
## Objetivo do Projeto

Consolidar o entendimento de:

  * Execução em baixo nível
  * Organização de memória
  * Chamadas de sistema
  * Tradução de lógica de alto nível para Assembly

---

##  Autoras

Este projeto foi desenvolvido por **Ana Alicy Ribeiro & Kaylane Castro**.

* **GitHub:** @AlicyRibeiro(https://github.com/AlicyRibeiro)

---
