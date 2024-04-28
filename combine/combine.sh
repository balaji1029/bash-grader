#!/usr/bin/bash

usage="Usage: bash submission.sh combine"

# Check if the arguments are -h or --help or help
if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
    echo -e "${usage}"
    exit 0

# Check if the number of arguments is 0
elif [ $# != 0 ]; then
    echo -e "${RED}${usage}${NC}"
    exit 1
fi

# Check if the $MAIN file exists
if [[ -e "$MAIN" ]]; then
    # Check if $MAIN has total header
    if [[ $(head -n 1 "$MAIN") =~ ,total$ ]]; then
        total=1
    else
        total=0
    fi
    rm "$MAIN"
fi

# Find all .csv files in the current directory
csv_files=$(find . -maxdepth 1 -type f -name "*.csv" -not -name "$MAIN" | sed 's/\.csv$//' | sed -E "s_^\.\/__" | paste -sd " ")

# Check if no .csv files are found
if [ -z "$csv_files" ]; then
    echo -e "${RED}No .csv files found.${NC}"
    exit 1
else
    # Check if there was total header
    if [[ $total -eq 1 ]]; then
        bash "$SCRIPT_DIR"/combine/add.sh -t ${csv_files}
    else
        bash "$SCRIPT_DIR"/combine/add.sh ${csv_files}
    fi
fi

# cat "$MAIN"