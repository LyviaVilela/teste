#Criar uma função que pede ao usuário o tamanho do sistema.
#Criar uma matriz vazia onde vamos armazenar os números.
#Criar um vetor para os termos independentes.
#Fazer um loop para que o usuário possa preencher esses valores.
#Criar uma função que recebe a matriz de coeficientes e os termos independentes.
# Percorrer as linhas da matriz e imprimir cada equação no formato adequado.

import numpy as np

def tamanho_sistema():
    while True:
        try:
            sistema = int(input('Qual o tamanho do sistema? '))
            return sistema
        except ValueError:
            print('Erro: Por favor, digite um número inteiro: ')


def ler_matriz_b(sistema):
    matriz = np.zeros((sistema, sistema), dtype=float)
    b = np.zeros(sistema, dtype=float)

    for i in range(sistema):
        for j in range(sistema):
            matriz[i, j] = float(input(f"Digite o coeficiente a[{i + 1}][{j + 1}]: "))

    for i in range(sistema):
        b[i] = float(input(f"Digite o termo independente b[{i + 1}]: "))

    return matriz, b


def imprimir_sistema(matriz, b):
    print("\nSistema Original:")
    for i in range(len(matriz)):
        equacao = ""
        for j in range(len(matriz[i])):
            if j == len(matriz[i]) - 1:
                equacao += f"{matriz[i][j]}x{j + 1} = {b[i]}"
            else:
                equacao += f"{matriz[i][j]}x{j + 1} + "
        print(equacao)


def escalonar(matriz, b):
    sistema = len(matriz)


    for i in range(sistema):

        max_row = max(range(i, sistema), key=lambda x: abs(matriz[x][i]))
        matriz[i], matriz[max_row] = matriz[max_row], matriz[i]
        b[i], b[max_row] = b[max_row], b[i]

        # Faz o pivoteamento da linha
        for j in range(i + 1, sistema):
            if matriz[j][i] != 0:
                fator = matriz[j][i] / matriz[i][i]
                matriz[j, i:] -= fator * matriz[i, i:]
                b[j] -= fator * b[i]

    return matriz, b


def verificar_solucao(matriz, b):
    sistema = len(matriz)

    for i in range(sistema):

        if all(matriz[i][j] == 0 for j in range(sistema)):
            if b[i] != 0:
                return "Sem solução"
            else:
                return "Infinitas soluções"
    return "Sistema tem solução única"


def substituicao_regressiva(matriz, b):
    sistema = len(matriz)
    solucao = np.zeros(sistema)

    for i in range(sistema - 1, -1, -1):
        soma = b[i]
        for j in range(i + 1, sistema):
            soma -= matriz[i][j] * solucao[j]
        solucao[i] = soma / matriz[i][i]

    return solucao


def main():
    sistema = tamanho_sistema()
    matriz, b = ler_matriz_b(sistema)
    imprimir_sistema(matriz, b)


    matriz, b = escalonar(matriz, b)
    print("\nSistema Escalonado:")
    imprimir_sistema(matriz, b)


    resultado = verificar_solucao(matriz, b)
    print(f"\nResultado: {resultado}")

    if resultado == "Sistema tem solução única":

        solucao = substituicao_regressiva(matriz, b)
        print("\nSolução:")
        print(solucao)


main()
