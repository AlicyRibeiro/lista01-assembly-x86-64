#  Questão 1 – Impressão de Inteiro Não Sinalizado (x86-64 NASM)

##  Objetivo

Criar uma função em Assembly x86-64 capaz de imprimir na tela um número inteiro **não sinalizado (unsigned)** definido na seção `.data`, independentemente da quantidade de dígitos.

---

#  Conceito Principal

Em Assembly não existe função pronta para converter número em texto.

Portanto, precisamos:

1. Converter o número para **string manualmente**
2. Armazenar os dígitos em memória
3. Chamar a syscall `write` para imprimir

A conversão é feita usando **divisões sucessivas por 10**, pois:

- O resto da divisão por 10 → último dígito
- O quociente → número restante

### Exemplo de conversão:

    2025 ÷ 10 = 202 resto 5
    202 ÷ 10 = 20 resto 2
    20 ÷ 10 = 2 resto 0
    2 ÷ 10 = 0 resto 2


Os dígitos são gerados na ordem inversa (5 2 0 2),  
por isso armazenamos do final para o início do buffer.

---

#  Estrutura do Programa

##  Seção `.data`

```asm
  section .data
    num dq 2025
```

- dq → define um inteiro de 64 bits (8 bytes).
- O número está armazenado na memória.
- Precisamos carregá-lo em um registrador antes de manipulá-lo.

## Seção `.bss`
```
section .bss
    saida resb 22
```

Reserva 22 bytes:

- 20 → máximo de dígitos de um unsigned 64 bits
(máx: 18446744073709551615 → 20 dígitos)
- 1 → caractere \n
- 1 → espaço extra de segurança

## Seção `.text`
```
global _start
```
Define _start como ponto de entrada do programa.

---

# Fluxo do Programa

## Início `(_start) `
```
mov rax, [num]
call Q1
```

- Carrega o número em  `RAX `
-  `RAX ` será o argumento da função
- Chama a função  `q1 `

Finalização do programa:
```
mov rax, 60
xor rdi, rdi
syscall
```

- `rax = 60` → syscall `exit`
- `rdi = 0` → código de saída

## Função q1 – Explicação Detalhada

Salvando registradores
```
push rax
push rcx
push rdx
push rdi
push rsi
```

Preserva os registradores que serão modificados.

Isso evita efeitos colaterais e segue boas práticas de organização.

---

# Conversão do Número para String
 
## Estratégia

Como os dígitos são gerados do menos significativo para o mais significativo, armazenamos do final para o início do buffer.

## Preparação do Buffer

```
mov rdi, saida + 20
mov byte [rdi], 10
dec rdi
```

- `rdi ` aponta para quase o final do buffer
- Coloca o caractere  `\n `
- Move o ponteiro para posição do último dígito

---

# Caso Especial: Número Zero

Se não tratarmos o zero, o loop nunca executaria.
```
cmp rax, 0
jne .verifica_valor
```

Se for zero:
```
mov byte [rdi], '0'
mov rcx, 1
jmp printf_string
```

Define:
- String =`"0"`
- Quantidade de dígitos = 1

---

# Loop de Conversão
```
.loop_conv:
    xor rdx, rdx
    mov rbx, 10
    div rbx
```

## Funcionamento da instrução div

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

É necessário zerar RDX antes da divisão, pois a instrução usa um dividendo de 128 bits (RDX:RAX).

---

## Conversão para ASCII
```
add rdx, '0'
mov byte [rdi], dl
```

Se o resto for 5:
```
ASCII de '0' = 48
48 + 5 = 53 → caractere '5'
```

## Atualização do ponteiro e contador
```
dec rdi
inc rcx
```

- Move o ponteiro uma posição para a esquerda
- Incrementa o contador de dígitos

## Condição de parada
```
cmp rax, 0
jne .loop_conv
```

Quando o quociente se torna 0, o número foi totalmente convertido.

---

# Impressão da String

Após o loop:
```
inc rdi
```
Corrige o ponteiro (pois foi decrementado uma vez a mais).

## Preparando a syscall write
```
mov rsi, rdi
mov rdx, rcx
add rdx, 1
```
Registradores usados:

| Registrador | Função                 |
| ----------- | ---------------------- |
| RAX         | número da syscall (1)  |
| RDI         | descritor (1 = stdout) |
| RSI         | endereço da string     |
| RDX         | tamanho                |


## Executando a syscall
```
mov rax, 1
mov rdi, 1
syscall
```

Imprime o número na tela.

## Final da Função
```
pop rsi
pop rdi
pop rdx
pop rcx
pop rax
ret
```

Restaura os registradores e retorna.

---

# Conceitos Demonstrados

- Manipulação de registradores
- Uso da pilha
- Conversão manual inteiro → string
- Uso da instrução `div`
- Uso de syscall Linux (`write` e `exit`)
- Controle de fluxo com labels
- Tratamento de caso especial (zero)

---

# Complexidade

- Tempo: O(d), onde d é o número de dígitos
- Espaço: 22 bytes fixos

---

# Conclusão

Esta implementação demonstra como linguagens de baixo nível exigem controle total sobre:

- Conversão de tipos
- Manipulação de memória
- Chamadas ao sistema operacional
- Organização do fluxo de execução

Ela mostra, na prática, como funções como:

```
printf("%u", num);
```

são implementadas internamente em nível de sistema.
