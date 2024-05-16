# Bash Grader
## Overview
The Bash Grader project is a collection of bash scripts designed to manage student data in CSV files and incorporate version control functionality similar to Git. The project includes commands to combine multiple CSV files, update student marks, and revert to previous versions of the data, among other tasks.

## Features
- CSV File Management: Combine multiple CSV files, update student marks, and calculate total marks.
- Version Control: Initialize a repository, commit changes, and checkout previous versions.
- Statistics: Generate statistical analyses and histograms of student marks.
- Command Autocomplete: Provides command-line auto-completion for enhanced user experience.
- Fuzzy Finder: Provides suggestions for names if the name is not found on the list.
## Prerequisites
- Bash
- AWK
- Sed
- Python 3.x
- Python Libraries: argparse, os, matplotlib, pandas, numpy
## Installation
Clone the repository to your local machine:

```sh
git clone https://github.com/balaji2005/bash-grader
cd bash-grader
```

## Usage
The tab autocompletion can be used by running the command

```sh
source completion.sh
```

### Basic Commands
#### combine
Combines multiple CSV files into a single file.

```sh
bash submission.sh combine
```

#### upload
Uploads CSV files to the current directory and processes them.

```sh
bash submission.sh upload file1.csv file2.csv ...
```

#### total
Calculates and adds a total column to the main.csv file.

```sh
bash submission.sh total
```
### Git-like Commands
#### git_init
Initializes a new version control repository.

```sh
bash submission.sh git_init <path/to/remote/repository>
```

#### git_config
Configures user information for the repository.

```sh
bash submission.sh git_config user.name "Your Name"
bash submission.sh git_config user.email "your.email@example.com"
```

#### git_commit
Commits changes to the repository with a message.

```sh
bash submission.sh git_commit.sh -m "Your commit message"
```

#### git_checkout
Checks out a specific commit.

```sh
bash submission.sh git_checkout <commit-hash>
```

#### git_log
Displays the commit log.

```sh
bash submission.sh git_log.sh [--oneline]
```
### Update Command
#### update
Updates a student's marks in a quiz.

```sh
bash submission.sh update <quiz-name>
```
### Custom Commands
#### train
A fun implementation that animates a train moving across the terminal.

```sh
bash submission.sh train
```

#### statistics
Analyzes the marks of students and generates histograms.

```sh
bash submission.sh stats [-b <bins>] [-q <quiz-name>] [-w]
```

#### student
Analyzes the marks of a given student.

```sh
bash submission.sh student [-n <student-name>] [-r <student-roll-number>] [-w]
```

## Author
Balaji Karedla

## Acknowledgements
Inspired by various open-source projects and the Unix philosophy of building small, modular utilities.
