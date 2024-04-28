import numpy as np
import pandas as pd

def levenshtein_distance(s1, s2):
    # Initialize a matrix to store the distances
    matrix = [[0] * (len(s2) + 1) for _ in range(len(s1) + 1)]

    # Initialize the first row and column of the matrix
    for i in range(len(s1) + 1):
        matrix[i][0] = i
    for j in range(len(s2) + 1):
        matrix[0][j] = j

    # Fill in the rest of the matrix
    for i in range(1, len(s1) + 1):
        for j in range(1, len(s2) + 1):
            cost = 0 if s1[i - 1] == s2[j - 1] else 1
            matrix[i][j] = min(matrix[i - 1][j] + 1,      # deletion
                               matrix[i][j - 1] + 1,      # insertion
                               matrix[i - 1][j - 1] + cost)  # substitution

    # Return the bottom-right cell of the matrix
    return matrix[-1][-1]

def find_close_names(input_string, string_list, threshold=2):
    close_names = []

    for string in string_list:
        distance = levenshtein_distance(input_string, string)
        if distance <= threshold:
            close_names.append(string)

    return close_names

names = np.array(pd.read_csv('main.csv')['Name'])

def find(name):
    close_names = find_close_names(name, names)
    print(' '.join(close_names))

find(input('Enter name: '))