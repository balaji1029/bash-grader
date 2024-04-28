import sys
import pandas as pd

# Get the levenshtein distance
def levenshtein_distance(s1, s2):
    if len(s1) < len(s2):
        return levenshtein_distance(s2, s1)
    if len(s2) == 0:
        return len(s1)
    previous_row = range(len(s2) + 1)
    for i, c1 in enumerate(s1):
        current_row = [i + 1]
        for j, c2 in enumerate(s2):
            insertions = previous_row[j + 1] + 1
            deletions = current_row[j] + 1
            substitutions = previous_row[j] + (c1 != c2)
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row
    # print('ll', previous_row[-1]/max(len(s1), len(s2)))
    return previous_row[-1]/min(len(s1), len(s2))

# Find the closest names
def find_close_names(input_string, string_list, threshold=0.3):
    close_names = []
    input_string = input_string.lower().split(' ')
    
    for i, student in string_list.iterrows():
        string = student['Name'].lower().split(' ')
        if sorted(input_string) == sorted(string):
            close_names.append(student)
            continue
        word_added = False
        for word in input_string:
            for word2 in string:
                distance = levenshtein_distance(word, word2)
                if distance < threshold:
                    close_names.append(student)
                    word_added = True
                    break
            if word_added:
                break

    return close_names

names = pd.read_csv('main.csv')

def find(roll_no, name):
    close_names = find_close_names(name, names)
    # print(close_names)
    for i, name in enumerate(close_names):
        if name['Roll_number'] == roll_no:
            close_names.pop(i)
            break
    if len(close_names) == 0:
        sys.exit(0)
    print('\n'.join([f'{name["Roll_number"]} {name["Name"]}' for i, name in enumerate(close_names)]))
    # print('\n'.join([f'{name['Roll_number']},{name["Name"]}' for i, name in enumerate(close_names)]))

if __name__ == '__main__':
    find(sys.argv[1], sys.argv[2])
