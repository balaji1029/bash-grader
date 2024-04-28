import sys
import numpy as np
import pandas as pd
import os
import matplotlib.pyplot as plt
import argparse

graded = 'graded.csv'
stats_without_grades = 'templates/statistics-template.html'
stats_with_grades = 'templates/graded-statistics-template.html'
stats_quiz = 'templates/quiz-statistics.html'
output = 'webpages/statistics.html'

# Create the parser
parser = argparse.ArgumentParser(description='Analyse the marks of students')

# Modify the usage message
parser.usage = "bash submission.sh stats [-b BINS] [-q QUIZ] [-w]"

# Add the arguments
parser.add_argument('-b', '--bins', type=int, help='Make a histogram with the given number of bins')
parser.add_argument('-q', '--quiz', type=str, help='Name of the quiz')
parser.add_argument('-w', '--webpage', action='store_true', help='Generate a webpage with the statistics')

# Parse the arguments
args = parser.parse_args()

# Check if the main.csv exists
csv_file = "./main.csv"
if not os.path.exists(csv_file):
    print("Combine the csv files first...")
    sys.exit(1)

# Read the main.csv file
df = pd.read_csv('./main.csv')
df.iloc[:, 2:] = df.iloc[:, 2:].replace('a', 0)
if 'total' not in df.columns:
    df['total'] = df.iloc[:, 2:].astype(float).sum(axis=1)
# print(df)

totals = np.array(df['total'])

# Check if the webpage flag is set
if args.webpage:
    # Check if the quiz flag is set
    if not args.quiz:
        # Check if the graded.csv file exists
        if os.path.exists('graded.csv'):
            page = open(stats_with_grades, 'r')
            text = page.read()
            total_hist = 'webpages/graphs/total-hist.png'
            total_scatter = 'webpages/graphs/total-scatter.png'
            # Identify good bins from the data
            if not args.bins:
                _, args.bins, _ = plt.hist(totals, bins='auto')
            else:
                plt.hist(totals, bins=args.bins)
            plt.xlabel('Marks')
            plt.ylabel('No. of students')
            plt.title('Histogram of Total')
            plt.savefig(total_hist)
            plt.close()
            df_sorted = df.sort_values('total')
            plt.scatter(np.arange(len(df['total'])), df_sorted['total'])
            plt.xlabel('Students')
            plt.ylabel('Scores')
            # Check if rubrics.csv exists
            if os.path.exists('rubrics.csv'):
                rubrics = pd.read_csv('rubrics.csv')
                for i in range(len(rubrics)):
                    # Add horizontal lines for each grade
                    plt.axhline(y=rubrics['marks'][i], color='magenta', linestyle='--', label=rubrics['grades'][i])
            plt.title('Performance of Students')
            plt.savefig(total_scatter)
            page.close()
            # Replace the placeholders with the statistics
            text = text.replace('$0$', str(len(totals)))
            text = text.replace('$1$', "{:.3f}".format(np.mean(totals)))
            text = text.replace('$2$', "{:.3f}".format(np.median(totals)))
            text = text.replace('$3$', "{:.3f}".format(np.std(totals)))
            text = text.replace('$4$', "{:.3f}".format(np.max(totals)))
            text = text.replace('$5$', "{:.3f}".format(np.percentile(totals, 25)))
            text = text.replace('$6$', "{:.3f}".format(np.percentile(totals, 75)))
            text = text.replace('$7$', "{:.3f}".format(np.percentile(totals, 90)))
            text = text.replace('$8$', total_hist.replace('webpages/', ''))
            text = text.replace('$9$', total_scatter.replace('webpages/', ''))
            table = pd.read_csv('graded.csv')['grade'].value_counts()
            # print(table, table.__len__())
            table_html = ''
            for i in range(table.__len__()):
                table_html += f'<tr><td style="text-align: center;">{table.index[i]}</td><td style="text-align: center;">{table.iloc[i]}</td></tr>'
            text = text.replace('$10$', table_html)
            page = open(output, 'w')
            page.write(text)
            page.close()
            os.system(f'xdg-open {output}')
        else:
            page = open(stats_without_grades, 'r')
            text = page.read()
            total_hist = 'webpages/graphs/total-hist.png'
            total_scatter = 'webpages/graphs/total-scatter.png'
            # Identify good bins from the data
            if not args.bins:
                _, args.bins, _ = plt.hist(totals, bins='auto')
            else:
                plt.hist(totals, bins=args.bins)
            plt.xlabel('Marks')
            plt.ylabel('No. of students')
            plt.title('Histogram of Total')
            plt.savefig(total_hist)
            plt.close()
            df_sorted = df.sort_values('total')
            plt.scatter(np.arange(len(df['total'])), df_sorted['total'])
            plt.xlabel('Students')
            plt.ylabel('Scores')
            plt.title('Performance of Students')
            plt.savefig(total_scatter)
            page.close()
            text = text.replace('$0$', str(len(totals)))
            text = text.replace('$1$', "{:.3f}".format(np.mean(totals)))
            text = text.replace('$2$', "{:.3f}".format(np.median(totals)))
            text = text.replace('$3$', "{:.3f}".format(np.std(totals)))
            text = text.replace('$4$', "{:.3f}".format(np.max(totals)))
            text = text.replace('$5$', "{:.3f}".format(np.percentile(totals, 25)))
            text = text.replace('$6$', "{:.3f}".format(np.percentile(totals, 75)))
            text = text.replace('$7$', "{:.3f}".format(np.percentile(totals, 90)))
            text = text.replace('$8$', total_hist.replace('webpages/', ''))
            text = text.replace('$9$', total_scatter.replace('webpages/', ''))
            page = open(output, 'w')
            page.write(text)
            page.close()
            os.system(f'xdg-open {output}')
    else:
        if os.path.exists(f'{args.quiz}.csv'):
            page = open(stats_quiz, 'r')
            text = page.read()
            df = pd.read_csv(f'{args.quiz}.csv')
            totals = np.array(df[f'Marks'])
            total_hist = 'webpages/graphs/total-hist.png'
            total_scatter = 'webpages/graphs/total-scatter.png'
            # Identify good bins from the data
            if not args.bins:
                _, args.bins, _ = plt.hist(totals, bins='auto')
            else:
                plt.hist(totals, bins=args.bins)
            plt.xlabel('Marks')
            plt.ylabel('No. of students')
            plt.title(f'Histogram of {args.quiz}')
            plt.savefig(total_hist)
            plt.close()
            df_sorted = df.sort_values(f'Marks')
            plt.scatter(np.arange(len(df[f'Marks'])), df_sorted[f'Marks'])
            plt.xlabel('Students')
            plt.ylabel('Scores')
            plt.title(f'Performance of Students in {args.quiz}')
            plt.savefig(total_scatter)
            page.close()
            text = text.replace('$0$', str(len(totals)))
            text = text.replace('$1$', "{:.3f}".format(np.mean(totals)))
            text = text.replace('$2$', "{:.3f}".format(np.median(totals)))
            text = text.replace('$3$', "{:.3f}".format(np.std(totals)))
            text = text.replace('$4$', "{:.3f}".format(np.max(totals)))
            text = text.replace('$5$', "{:.3f}".format(np.percentile(totals, 25)))
            text = text.replace('$6$', "{:.3f}".format(np.percentile(totals, 75)))
            text = text.replace('$7$', "{:.3f}".format(np.percentile(totals, 90)))
            text = text.replace('$8$', total_hist.replace('webpages/', ''))
            text = text.replace('$9$', total_scatter.replace('webpages/', ''))
            text = text.replace('$10$', args.quiz.capitalize())
            page = open(output, 'w')
            page.write(text)
            page.close()
            os.system(f'xdg-open {output}')

        else:
            print(f"{args.quiz}.csv does not exist")
            sys.exit(1)
else:
    if args.bins and args.quiz:
        if os.path.exists(f'{args.quiz}.csv'):
            df = pd.read_csv(f'{args.quiz}.csv')
            totals = np.array(df[f'Marks'])
            plt.hist(totals, bins=args.bins)
            plt.show()
        else:
            print(f"{args.quiz}.csv does not exist")
    elif args.bins:
        plt.hist(totals, bins=args.bins)
        plt.show()
    elif args.quiz:
        if os.path.exists(f'{args.quiz}.csv'):
            df = pd.read_csv(f'{args.quiz}.csv')
            totals = np.array(df[f'Marks'])
            print("Total number of students: ", len(totals))
            print("Mean: ", np.mean(totals))
            print("Standard deviation: ", np.std(totals))
            print("Maximum: ", "{:.3f}".format(np.max(totals)))
            print("Median: ", "{:.3f}".format(np.median(totals)))
            print("25th percentile: ", "{:.3f}".format(np.percentile(totals, 25)))
            print("75th percentile: ", "{:.3f}".format(np.percentile(totals, 75)))
            print("90th percentile: ", "{:.3f}".format(np.percentile(totals, 90)))
        else:
            print(f"{args.quiz}.csv does not exist")
    else:
        print("Total number of students: ", len(totals))
        print("Mean: ", "{:.3f}".format(np.mean(totals)))
        print("Standard deviation: ", "{:.3f}".format(np.std(totals)))
        print("Maximum: ", "{:.3f}".format(np.max(totals)))
        print("Median: ", "{:.3f}".format(np.median(totals)))
        print("25th percentile: ", "{:.3f}".format(np.percentile(totals, 25)))
        print("75th percentile: ", "{:.3f}".format(np.percentile(totals, 75)))
        print("90th percentile: ", "{:.3f}".format(np.percentile(totals, 90)))
        if os.path.exists('graded.csv'):
            print()
            table = pd.read_csv('graded.csv')['grade'].value_counts().to_string().upper()
            print(table) # type: ignore