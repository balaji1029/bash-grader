import os
import sys
import pandas as pd
import itertools

students = pd.read_csv('main.csv')

lis = [1, 2, 3]

permutations = list(itertools.permutations(lis))
print(permutations)

def levenshtein(s1, s2):
    if len(s1) > len(s2):
        s1, s2 = s2, s1

    distances = range(len(s1) + 1)
    for i2, c2 in enumerate(s2):
        distances_ = [i2 + 1]
        for i1, c1 in enumerate(s1):
            if c1 == c2:
                distances_.append(distances[i1])
            else:
                distances_.append(1 + min((distances[i1], distances[i1 + 1], distances_[-1])))
        distances = distances_
    return distances[-1]

def jumbled(name):
    for i, student in students.iterrows():
        given = name.split(' ')
        student_name = student['Name'].split(' ')
            

# if len(sys.argv) > 1:
#     jumbled(sys.argv[1])


print(levenshtein('Balaji', 'aalai'))