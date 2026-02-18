# Questões 6 — Versões Adicionais (Assembly x86-64)

Estas implementações repetem a lógica das Questões 4 e 5, mas explorando três formas diferentes de entrada de dados.

O objetivo continua sendo:

Calcular a soma dos dois maiores números entre três valores inteiros (com sinal)

Matematicamente:

```
resultado = (a + b + c) − min(a, b, c)
```

---

#  Visão Geral das Versões

| Versão | Entrada                        | Arquivo    |
| ------ | ------------------------------ | ---------- |
| 🖥️ V1 | Entrada pelo teclado           | `q6v4.asm` |
| ⌨️ V2  | Argumentos da linha de comando | `q6v5.asm` |
| 📄 V3  | Leitura de arquivo             | `q6v6.asm` |


---

# ➡️ Versão 1 — Entrada pelo Usuário (q6v4.asm)
 ## Objetivo

Solicitar três números ao usuário, um por vez, e calcular a soma dos dois maiores.

---

# Funcionamento

1. Exibe mensagens pedindo os números
2. Lê cada entrada usando syscall `read`
3. Converte string → inteiro (suporta números negativos)
4. Identifica o menor valor
5. Calcula:
```
soma_total − menor
```

6. Converte o resultado para string
7. Imprime na tela

---

# Lógica Principal
  ## Função ler_inteiro

Responsável por:

- Ler até 20 bytes do teclado
- Detectar sinal negativo
- Converter cada dígito ASCII para inteiro

Algoritmo:
```
resultado = resultado * 10 + digito
```

## Descoberta do menor número
```
mov r11, r8
cmp r9, r11
jge .skip1
mov r11, r9
cmp r10, r11
jge .skip2
mov r11, r10
```

---

# Compilação e Execução
```
nasm -f elf64 q6v4.asm -o q6v4.o
ld q6v4.o -o q6v4
./q6v4
```

---

# ➡️ Versão 2 — Argumentos da Linha de Comando (`6v5.asm`)
  ## Objetivo

Receber três números diretamente ao executar o programa.

Exemplo:
```
./q6v5 -7 4 -9
```

---

# Funcionamento

1. Verifica se existem exatamente 3 argumentos
2. Converte cada argumento para inteiro
3. Calcula a soma total
4. Determina o menor valor usando `cmov`
5. Subtrai o menor da soma
6. Converte e imprime o resultado

--- 

# Destaques Técnicos

  ## Layout da pilha no início

| Endereço   | Conteúdo |
| ---------- | -------- |
| `[rsp]`    | argc     |
| `[rsp+16]` | argv[1]  |
| `[rsp+24]` | argv[2]  |
| `[rsp+32]` | argv[3]  |


## Função `string_para_inteiro`

- Detecta sinal negativo
- Converte caracteres até encontrar algo fora de `0–9`

## Uso de cmov

Evita saltos condicionais:

- cmp rbx, r14
- cmovg rbx, r14

---

# Compilação e Execução
```
nasm -f elf64 q6v5.asm -o q6v5.o
ld q6v5.o -o q6v5
./q6v5 10 20 5
```

---

# ➡️ Versão 3 — Leitura de Arquivo (q6v6.asm)
## Objetivo

Ler três números de um arquivo texto (um por linha).

## Exemplo de arquivo
```
10
20
5
```

---

#  Funcionamento

1. Recebe o nome do arquivo como argumento
2. Abre o arquivo (`sys_open`)
3. Lê o conteúdo para um buffer
4. Extrai os três números do buffer
5. Calcula a soma dos dois maiores
6. Converte para string
7. Imprime o resultado

---

# Funções Importantes
  ## `inteiro_sinalizado`

- Lê caracteres até encontrar algo fora de `0–9`
- Detecta sinal negativo
- Avança até a próxima linha

## `string_sinalizado`

- Converte inteiro → string
- Usa pilha para inverter os dígitos

---

# Compilação e Execução
```
nasm -f elf64 q6v6.asm -o q6v6.o
ld q6v6.o -o q6v6
./q6v6 arquivo.txt
```

---

# Exemplos de Saída

Entrada
```
-7 4 -9
```

Saída
```
-3
```

---

# Conceitos Praticados

- Syscalls do Linux
- Conversão ASCII ↔ inteiro com sinal
- Manipulação da pilha
- Entrada por múltiplas fontes
- Leitura de arquivos
- Comparações e lógica condicional
- Uso de registradores estendidos

---

# Comparação das Implementações

| Versão | Entrada    | Dificuldade | Conceitos principais |
| ------ | ---------- | ----------- | -------------------- |
| V1     | Teclado    | ⭐⭐          | IO básica            |
| V2     | Argumentos | ⭐⭐⭐         | Stack e parsing      |
| V3     | Arquivo    | ⭐⭐⭐⭐        | Syscalls e buffer    |

---

# Conclusão

Essas três versões demonstram como a mesma lógica pode ser aplicada a diferentes formas de entrada, reforçando conceitos fundamentais de:

- Programação de baixo nível
- Interação com o sistema operacional
- Manipulação manual de memória

Esse tipo de exercício é essencial para compreender como programas funcionam sem abstrações de alto nível.
