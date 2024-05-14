# Bash Grader
Overview
The Bash Grader project is a collection of bash scripts designed to manage student data in CSV files and incorporate version control functionality similar to Git. The project includes commands to combine multiple CSV files, update student marks, and revert to previous versions of the data, among other tasks.

Features
CSV File Management: Combine multiple CSV files, update student marks, and calculate total marks.
Version Control: Initialize a repository, commit changes, and checkout previous versions.
Statistics: Generate statistical analyses and histograms of student marks.
Command Autocomplete: Provides command-line auto-completion for enhanced user experience.
Prerequisites
Bash
AWK
Sed
Python 3.x
Python Libraries: argparse, os, matplotlib, pandas, numpy
Installation
Clone the repository to your local machine:

sh
Copy code
git clone <repository-url>
cd Bash-Grader
Usage
Basic Commands
combine
Combines multiple CSV files into a single file.

sh
Copy code
./combine.sh
upload
Uploads CSV files to the current directory and processes them.

sh
Copy code
./upload.sh file1.csv file2.csv ...
total
Calculates and adds a total column to the main.csv file.

sh
Copy code
./total.sh
Git-like Commands
git_init
Initializes a new version control repository.

sh
Copy code
./git_init.sh <repository-name>
git_config
Configures user information for the repository.

sh
Copy code
./git_config.sh user.name "Your Name"
./git_config.sh user.email "your.email@example.com"
git_commit
Commits changes to the repository with a message.

sh
Copy code
./git_commit.sh -m "Your commit message"
git_checkout
Checks out a specific commit.

sh
Copy code
./git_checkout.sh <commit-hash>
git_log
Displays the commit log.

sh
Copy code
./git_log.sh [--oneline]
Update Command
update
Updates a student's marks in a quiz.

sh
Copy code
./update.sh <quiz-name>
Custom Commands
train
A fun implementation that animates a train moving across the terminal.

sh
Copy code
./train.sh
Command Autocomplete
Provides auto-completion for submission.sh.

sh
Copy code
source completion.sh
statistics
Analyzes the marks of students and generates histograms.

sh
Copy code
python3 statistics.py [-b <bins>] [-q <quiz-name>] [-w]
Scripts Breakdown
combine.sh
Combines multiple CSV files into one, with optional totaling.

upload.sh
Uploads and processes CSV files, converting roll numbers to lowercase.

total.sh
Adds a total column to the main.csv file.

init.sh
Initializes a new git-like repository.

config.sh
Configures user information for the repository.

commit.sh
Commits changes to the repository with a message.

checkout.sh
Checks out a specific commit.

log.sh
Displays the commit log.

update.sh
Updates student marks in a specific quiz.

train.sh
Animates a train moving across the terminal.

completion.sh
Provides command-line auto-completion for submission.sh.

statistics.py
Analyzes student marks and generates histograms.

Utilities Used
bash: For running shell commands.
sed: For stream editing.
awk: For pattern scanning and processing.
grep: For searching text.
python3: For running Python scripts.
Python Libraries
argparse: For parsing command-line arguments.
os: For interacting with the operating system.
matplotlib: For creating plots.
pandas: For data manipulation.
numpy: For numerical calculations.
Customizations
Train Animation: A fun terminal animation inspired by the sl command.
Command Autocomplete: Enhanced user experience with auto-completion for submission.sh.
Statistics Generation: Detailed analysis of student marks, including histograms.
License
This project is licensed under the MIT License. See the LICENSE file for more details.

Author
Balaji Karedla

Acknowledgements
Inspired by various open-source projects and the Unix philosophy of building small, modular utilities.
