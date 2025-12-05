import numpy as np

def tamanho_sistema():
    while True:
        try:
            n = int(input('Digite o tamanho do sistema: '))
            if n > 0:
                return n
            else:
                print('O tamanho deve ser um número inteiro positivo.')
        except ValueError:
            print('Erro: Digite um número inteiro válido.')


def ler_matriz_e_b(n):
    A = np.zeros((n, n), dtype=float)
    b = np.zeros(n, dtype=float)

    print("\nDigite os coeficientes da matriz:")
    for i in range(n):
        for j in range(n):
            A[i, j] = float(input(f"A[{i + 1}][{j + 1}]: "))

    print("\nDigite os termos independentes:")
    for i in range(n):
        b[i] = float(input(f"b[{i + 1}]: "))

    return A, b


def imprimir_sistema(A, b):
    print("\nSistema de Equações:")
    for i in range(len(A)):
        linha = " + ".join([f"{A[i][j]}x{j + 1}" for j in range(len(A[i]))])
        print(f"{linha} = {b[i]}")


def escalonar(A, b):
    n = len(A)
    for i in range(n):
        max_linha = max(range(i, n), key=lambda x: abs(A[x][i]))
        A[[i, max_linha]] = A[[max_linha, i]]
        b[i], b[max_linha] = b[max_linha], b[i]

        for j in range(i + 1, n):
            if A[j][i] != 0:
                fator = A[j][i] / A[i][i]
                A[j, i:] -= fator * A[i, i:]
                b[j] -= fator * b[i]

    return A, b


def verificar_solucao(A, b):
    n = len(A)
    for i in range(n):
        if np.all(A[i] == 0):
            return "Sem solução" if b[i] != 0 else "Infinitas soluções"
    return "Solução única"


def substituicao_regressiva(A, b):
    n = len(A)
    x = np.zeros(n)
    for i in range(n - 1, -1, -1):
        x[i] = (b[i] - np.dot(A[i, i + 1:], x[i + 1:])) / A[i, i] # produto escalar de da linha i a A com os valores de x
    return x


def main():
    n = tamanho_sistema()
    A, b = ler_matriz_e_b(n)
    imprimir_sistema(A, b)

    A, b = escalonar(A, b)
    print("\nSistema após escalonamento:")
    imprimir_sistema(A, b)

    resultado = verificar_solucao(A, b)
    print(f"\nResultado: {resultado}")


    if resultado == "Solução única":
        solucao = substituicao_regressiva(A, b)
        print("\nSolução do sistema:")
        print(solucao)


main()
