#include <stdio.h>

#define TAMANHO 10

// Apenas a declaração da função é mantida.
// Isso informa ao compilador C que o corpo (a implementação) desta função
// será encontrado em outro arquivo objeto durante a linkagem (no caso, q3.o).
void print_array_int(int *vetor, int tamanho);


// Função que soma dois vetores (continua em C)
void soma_array(int *vetor1, int *vetor2, int *resultado, int tamanho) {
    for (int i = 0; i < tamanho; i++) {
        resultado[i] = vetor1[i] + vetor2[i];
    }
}


int main() {
    int vetor1[TAMANHO]  = {1, 2, 3, 4, 5, 6, 7, 8, 9, 100};
    int vetor2[TAMANHO]  = {1000, 20, 30, 40, 50, 60, 70, 80, 90, 100};
    int resultado[TAMANHO];

    // Chama a função que soma os vetores
    soma_array(vetor1, vetor2, resultado, TAMANHO);

    // Chama a função que imprime o vetor resultado.
    // Agora, esta chamada será direcionada para a versão em Assembly.
    print_array_int(resultado, TAMANHO);

    return 0;
}


;// make
//./programa