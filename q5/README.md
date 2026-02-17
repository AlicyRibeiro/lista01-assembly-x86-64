# Questão 5 — Soma dos Dois Maiores (Assembly x86-64)

Programa em Assembly (NASM) que lê três números inteiros sinalizados definidos na seção .data, determina quais são os dois maiores e imprime na tela a soma entre eles.

---

# Objetivo

Implementar um algoritmo em baixo nível que:

1. Carregue três inteiros da memória
2. Compare os valores para identificar os dois maiores
3. Realize a soma
4. Converta o resultado para string
5. Exiba a mensagem e o valor no terminal

---

# Lógica do Algoritmo

O programa segue os passos abaixo:

1️. Carrega os números (`num1`, `num2`, `num3`) em registradores de 64 bits com extensão de sinal (`movsx`)

2️. Realiza comparações com cmp e saltos condicionais para reorganizar os valores, garantindo que:

- `RAX` → maior número
- `RBX `→ segundo maior

3️. Soma os dois maiores

```
add rax, rbx
```

4️. Imprime a mensagem usando syscall `write`

5️. Converte o número para string com a rotina `converte_num`

6️. Exibe o resultado e finaliza com `exit`

---

# Estrutura do Código
```

section .data   → números e mensagens
section .bss    → buffer de saída
section .text   → lógica principal
```

## Principais Rotinas

-  `_start ` → fluxo principal do programa
-  `converte_num ` → converte inteiro para ASCII (base 10)

---

# Como Compilar e Executar
```
nasm -f elf64 q5.asm -o q5.o
ld q5.o -o q5
./q5
```
---

# Saída Esperada
```
Soma dos dois maiores:  12
```

(O valor varia conforme os números definidos na seção  `.data `)

---

# Conceitos Envolvidos

- Convenção de registradores no Linux x86-64
- Chamadas de sistema ( `syscall `)
- Comparações e desvios condicionais
- Manipulação de inteiros com sinal
- Conversão manual número → string
- Organização de memória ( `.data `,  `.bss `,  `.text `)
