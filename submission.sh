#!/usr/bin/bash

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m'

# usage: This script is used to perform some task.
usage="Usage: $0 [arguments]\nThis script is used to perform some task.\n
\nArguments:\n\n\t\
${YELLOW}-h, --help, help${NC}\tShow this help message and exit\n\n\t\
${YELLOW}combine${NC}\tCombines the .csv files to give the main.csv\n\n\t\
${YELLOW}upload${NC}\tUploads the files given as arguments\n\t\tto the present working directory\n\n\t\
${YELLOW}total${NC}\tAdds up the scores of the students\n\t\tin all the tests\n\t\tand adds a column total in main.csv\n
..."

# Check if there are no arguments
if [ $# -eq 0 ]; then
    echo -e ${usage}
    exit 1
fi

# Check if the first argument is help
if [[ $1 == "-h" || $1 == "--help" || $1 == "help" ]]; then
    echo -e ${usage}
    exit 0
fi

# Check if the command is combine
if [ $1 == "combine" ]; then
    bash combine.sh

# Check if the command is upload
elif [ $1 == "upload" ]; then
    shift
    bash upload.sh "$@"

# Check if the command is total
elif [ $1 == "total" ]; then
    bash total.sh

# If the command is not valid
else
    echo "Invalid argument. Please use -h, --help, or help to see the usage."
    exit 1
fi