# Questão 9 — Avaliador de Expressões em Assembly (x86-64)

Programa em Assembly NASM que lê uma expressão aritmética digitada pelo usuário, avalia o resultado respeitando precedência de operadores e parênteses, e imprime o valor final no terminal.

O programa implementa um interpretador simples, usando a técnica de descida recursiva (recursive descent parser). 

---

# Objetivo

Criar um avaliador capaz de processar expressões como:

```
2+3
10+5*2
(8+2)*3
20/(2+3)
```
Suportando:

- Soma `+`
- Subtração `-`
- Multiplicação `*`
- Divisão `/`
- Parênteses `( )`

---

# Conceito Principal

O programa funciona como um mini compilador dividido em etapas:

1. Leitura da entrada
2. Análise sintática da expressão
3. Avaliação recursiva
4. Conversão do resultado para string
5. Impressão no terminal

---

# Gramática Implementada

A lógica segue a hierarquia de precedência:
```
expr   → term (('+' | '-') term)*
term   → factor (('*' | '/') factor)*
factor → number | '(' expr ')'
```

Isso garante que:

- Multiplicação e divisão tenham prioridade
- Parênteses sejam avaliados primeiro


---

# Fluxo do Programa

## 1️. Exibe o prompt

O usuário vê:
```
Digite uma expressão:
```

## 2️. Lê a expressão do teclado

A string digitada é armazenada no buffer expr.

## 3️. Avalia a expressão

A função `eval_expr` inicia o processo recursivo:

- `eval_expr` → soma e subtração
- `eval_term` → multiplicação e divisão
- `eval_factor` → números e parênteses

## 4️. Converte o resultado para string

A função `int_to_st`r transforma o inteiro em ASCII.

## 5️. Imprime o resultado

Usa a syscall `write` para mostrar no terminal.

---

# Estrutura do Código

## `.bss`

- `expr` → buffer da expressão
- `result` → buffer do número convertido

## `.data`

- Mensagem do prompt
- Quebra de linha

## `.text`

Contém:

- Rotina principal `_start`
- Avaliador recursivo
- Conversor de número
- Parser de dígitos

---

# Como Funciona o Parser

## `eval_expr`

Responsável por:

- Somar
- Subtrair

Ele chama `eval_term` e continua processando enquanto encontrar `+` ou `-`.

## `eval_term`

Responsável por:

- Multiplicar
- Dividir

Garante precedência correta sobre soma e subtração.

## `eval_factor`

Responsável por:

- Detectar números
- Avaliar expressões entre parênteses

Se encontrar `(`, chama `eval_expr` novamente (recursão).

---

# Conversão de Número

## `parse_number`

Converte dígitos ASCII em inteiro:
```
"123" → 123
```

Multiplica o acumulador por 10 a cada novo dígito.

## `int_to_str`

Faz o processo inverso:
```
123 → "123"
```

Usa divisões sucessivas por 10.

---

# Exemplo de Execução
```
Digite uma expressão: (10+5)*2
30
```
---

# Como Compilar e Executar
```
nasm -f elf64 q9.asm -o q9.o
ld q9.o -o q9
./q9
```
---

# Conceitos Trabalhados

- Parsing de expressões
- Recursão em Assembly
- Manipulação de ponteiros de string
- Pilha para salvar estados
- Precedência de operadores
- Conversão ASCII ↔ inteiro
- Syscalls do Linux

