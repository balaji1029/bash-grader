import sys
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import argparse

grades = ['AP', 'AA', 'AB', 'BB', 'BC', 'CC', 'CD', 'DD']
rubric = './rubrics.csv'
main = './main.csv'

parser = argparse.ArgumentParser(description='Assign grades to students based on rubrics')

parser.add_argument('-e', '--edit', action='store_true', help='Edit the rubrics')

args = parser.parse_args()

if args.edit:
    if not os.path.exists(rubric):
        os.system('touch rubrics.csv')
    rubrics = open(rubric, 'w')
    rubrics.write('grades,marks\n')
    for grade in grades:
        dec = input(f'Do you want to include {grade} in the rubrics? (Y/n): ').strip().lower()
        if dec == 'n':
            continue
        else:
            marks = input(f'Enter the marks for {grade}: ').strip()
            rubrics.write(f'{grade},{marks}\n')
    rubrics.close()
else:
    if not os.path.exists(rubric):
        print('rubrics.csv does not exist... Create the rubrics first...')
        sys.exit(1)

if not os.path.exists(main):
    print('main.csv does not exist... Combine the quizzes first...')
    sys.exit(1)

df = pd.read_csv(main)
df.iloc[:, 2:] = df.iloc[:, 2:].replace('a', 0)
if 'total' not in df.columns:
    df['total'] = df.iloc[:, 2:].astype(float).sum(axis=1).round(2)
rubrics_data = pd.read_csv(rubric)
rubrics_data = rubrics_data[::-1]
# print(rubrics_data.values.tolist())
grades = rubrics_data['grades'].tolist()
grades.insert(0, 'FR')
try:
    bins = [-np.inf, *rubrics_data['marks'], np.inf]
    df['grade'] = pd.cut(df['total'], bins=bins, labels=grades)
    df.to_csv('graded.csv', index=False)
    grade_counts = df['grade'].value_counts()
    print(grade_counts.to_string().upper())
except:
    print('Rubrics are not valid... Please check the rubrics...')