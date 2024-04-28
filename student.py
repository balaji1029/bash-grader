import os
import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import argparse
import closest_name

# Argument parser
parser = argparse.ArgumentParser(description='Analyse the marks of a student')

# Add the arguments
parser.add_argument('-r', '--roll-number', type=str, help='Roll number of the student')
parser.add_argument('-n', '--name', type=str, help='Name of the student')
parser.add_argument('-w', '--webpage', action='store_true', help='Open the webpage')
# parser.add_argument('-p', '--pdf', action='store_true', help='Show pdf')

args = parser.parse_args()

quizzes_img = 'webpages/graphs/quizzes.png'
percentile_img = 'webpages/graphs/percentiles.png'
student_template_web = 'templates/student-template.html'
webpage = 'webpages/student.html'
student_template_tex = 'templates/student_latex.tex'

print(os.path.exists('main.csv'))

# Check if the main.csv exists
if not os.path.exists('main.csv'):
    print('main.csv does not exist. Please combine first...')
    sys.exit(1)

# Read the main.csv file
df = pd.read_csv('main.csv')
df.iloc[2:] = df.iloc[2:].replace('a', 0)
df.iloc[:, 2:] = df.iloc[:, 2:].astype(float)

# Check if the total column exists
if 'total' in df.columns:
    df = df.drop('total', axis=1)

# Check if the student's roll number is provided
if args.roll_number:
    roll_number = args.roll_number
    student = df[df['Roll_number'] == roll_number.lower()]
    # Check if the student exists
    if student.empty:
        print('Student not found')
        sys.exit(1)
    # Get the student's name
    name = student['Name'].values[0]
    scores = student.drop(['Name', 'Roll_number'], axis=1).values[0]
    scores = np.array(scores).astype(np.float64)
    # Plot the scores
    plt.plot(np.arange(1, scores.__len__()+1), scores)
    # Plot the max and mean scores
    plt.plot(np.arange(1, scores.__len__()+1), df.iloc[:, 2:].max().values, 'r--')
    plt.plot(np.arange(1, scores.__len__()+1), df.iloc[:, 2:].mean().values, 'g--')

    # Add the legend
    plt.legend(['Individual Scores', 'Max Score', 'Mean Score'])
    # Add the xticks
    plt.xticks(np.arange(1, scores.__len__()+1), df.columns[2:].str.capitalize())
    
    max_overall = df.iloc[:, 2:].max().values
    plt.xlabel('Quiz')
    plt.ylabel('Score')
    plt.title('Performance in Quizzes')
    plt.savefig(quizzes_img)
    plt.close()
    percentiles = np.zeros(scores.__len__())
    # Calculate the percentiles
    for i, quiz in enumerate(df.columns[2:]):
        index = np.array(df[quiz].values).astype(np.float64)
        index.sort()
        index = index[::-1]
        percentile = 100 - (np.where(index == student[quiz].values[0])[0][0] / len(index) * 100)
        percentiles[i] = percentile
    # Plot the percentiles
    plt.plot(np.arange(1, scores.__len__()+1), percentiles)
    plt.xlabel('Quiz')
    plt.ylabel('Percentile')
    plt.title('Percentiles')
    plt.ylim(-10, 110)
    plt.xticks(np.arange(1, scores.__len__()+1), df.columns[2:].str.capitalize())
    plt.savefig(percentile_img)

# Check if the student's name is provided
if args.name:
    name = args.name
    student = df[df['Name'] == name]
    # Check if the student exists
    if student.empty:
        print('Student not found')
        print()
        print('Did you mean?:')
        closest_name.find('', name)
        # Find the closest names
        sys.exit(1)
    # Get the student's roll number
    roll_number = student['Roll_number'].values[0]
    scores = student.drop(['Name', 'Roll_number'], axis=1).values[0]
    scores = np.array(scores).astype(np.float64)
    # Plot the scores
    plt.plot(np.arange(1, scores.__len__()+1), scores)
    plt.plot(np.arange(1, scores.__len__()+1), df.iloc[:, 2:].max().values, 'r--')
    plt.plot(np.arange(1, scores.__len__()+1), df.iloc[:, 2:].mean().values, 'g--')

    plt.legend(['Individual Scores', 'Max Score', 'Mean Score'])
    # Add the xticks
    plt.xticks(np.arange(1, scores.__len__()+1), df.columns[2:].str.capitalize())
    
    max_overall = df.iloc[:, 2:].max().values
    plt.xlabel('Quiz')
    plt.ylabel('Score')
    plt.title('Performance in Quizzes')
    plt.savefig(quizzes_img)
    plt.close()
    percentiles = np.zeros(scores.__len__())
    # Calculate the percentiles
    for i, quiz in enumerate(df.columns[2:]):
        index = np.array(df[quiz].values).astype(np.float64)
        index.sort()
        index = index[::-1]
        percentile = 100 - (np.where(index == student[quiz].values[0])[0][0] / len(index) * 100)
        percentiles[i] = percentile
    # Plot the percentiles
    plt.plot(np.arange(1, scores.__len__()+1), percentiles)
    plt.xlabel('Quiz')
    plt.ylabel('Percentile')
    plt.title('Percentiles')
    plt.ylim(-10, 110)
    plt.xticks(np.arange(1, scores.__len__()+1), df.columns[2:].str.capitalize())
    plt.savefig(percentile_img)

# Check if the webpage flag is provided
if args.webpage:
    # Get the student template
    text = open(student_template_web, 'r').read()
    # Replace the placeholder with the student's name
    text = text.replace('$0$', name)
    table = ''
    # Create the table
    for quiz in student.columns[2:]:
        table += f'<tr><td style="text-align: center;">{quiz.capitalize()}</td><td style="text-align: center;">{student[quiz].values[0]}</td></tr>'
    text = text.replace('$1$', table)
    total = np.array(df.iloc[:, 2:].astype(float).sum(axis=1))
    # Replace the placeholders with the student's data
    text = text.replace('$2$', str(total.shape[0]))
    text = text.replace('$3$', "{:.3f}".format(np.mean(total)))
    text = text.replace('$4$', "{:.3f}".format(np.median(total)))
    text = text.replace('$5$', "{:.3f}".format(np.std(total)))
    text = text.replace('$6$', "{:.3f}".format(np.max(total)))
    text = text.replace('$7$', "{:.3f}".format(np.percentile(total, 25)))
    text = text.replace('$8$', "{:.3f}".format(np.percentile(total, 75)))
    text = text.replace('$9$', "{:.3f}".format(np.percentile(total, 90)))
    # Replace the placeholders with the images
    text = text.replace('$10$', quizzes_img.replace('webpages/', ''))
    text = text.replace('$11$', percentile_img.replace('webpages/', ''))
    open(webpage, 'w').write(text)
    os.system(f'open {webpage}')
else:
    print('Name: ', name)
    print('Roll Number: ', roll_number)
    print()
    print('Scores: ')
    # print(student.drop(['Name', 'Roll_number'], axis=1))
    for i, quiz in enumerate(student.columns[2:]):
        print(f'{quiz.capitalize()}: {student[quiz].values[0]}')
    print()
    total = np.array(df.iloc[:, 2:].astype(float).sum(axis=1))
    print('Total: ', total.shape[0])
    print('Mean: {:.3f}'.format(np.mean(total)))
    print('Median: {:.3f}'.format(np.median(total)))
    print('Standard Deviation: {:.3f}'.format(np.std(total)))
    print('Max: {:.3f}'.format(np.max(total)))
    print('25th Percentile: {:.3f}'.format(np.percentile(total, 25)))
    print('75th Percentile: {:.3f}'.format(np.percentile(total, 75)))
    print('90th Percentile: {:.3f}'.format(np.percentile(total, 90)))
    
# if args.pdf:
#     if not os.path.exists('graded.csv'):
#         print('graded.csv does not exist. Please grade first...')
#         sys.exit(1)
#     if not os.path.exists('rubrics.csv'):
#         print('rubrics.csv does not exist. Please grade first...')
#         sys.exit(1)
#     text = open(student_template_tex, 'r').read()
#     text = text.replace('$0$', name)
#     table = ''
#     for i, quiz in enumerate(student.columns[2:]):
#         if i == 0:
#             table += quiz.capitalize() + ' & \\vspace{0.15cm} \\rule[-0.5cm]{0pt}{0.3cm}' + str(student[quiz].values[0]) + ' \\\\ \n'
#         else:
#             table += '\t\t' + quiz.capitalize() + ' & \\rule[-0.5cm]{0pt}{0.3cm} ' + str(student[quiz].values[0]) + ' \\\\ \n'
#     text = text.replace('$1$', table)
#     total = np.array(df.iloc[:, 2:].astype(float).sum(axis=1))
#     text = text.replace('$2$', str(total.shape[0]))
#     table = ''
#     rubric = pd.read_csv('rubrics.csv')
#     for i, rub in rubric.iterrows():
#         if i == 0:
#             table += rub['grades'] + ' & \\vspace{0.15cm} \\rule[-0.5cm]{0pt}{0.3cm}' + str(rub['marks']) + ' \\\\ \n'
#         else:
#             table += '\t\t' + rub["grades"] + ' & \\rule[-0.5cm]{0pt}{0.3cm} ' + str(rub["marks"]) + ' \\\\ \n'
    
#     text = text.replace('$3$', table)
#     graded = pd.read_csv('graded.csv')
#     text = text.replace('$4$', graded[graded['Name'] == name]['grade'].values[0])
#     file = open('webpages/student_latex.tex', 'w')
#     file.write(text)
#     file.close()
#     os.system('pdflatex webpages/student_latex.tex')
#     os.system('open webpages/student_latex.pdf')
    