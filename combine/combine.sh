#!/usr/bin/bash

usage="Usage: bash submission.sh combine"

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
    echo -e "${usage}"
    exit 0
elif [ $# != 0 ]; then
    echo -e "${RED}${usage}${NC}"
    exit 1
fi

csv_files=$(find . -maxdepth 1 -type f -name "*.csv" -not -name "$MAIN" | sed 's/\.csv$//' | sed -E "s_^\.\/__" | paste -sd " ")
# echo "$csv_files"
if [ -z "$csv_files" ]; then
    echo -e "${RED}No .csv files found.${NC}"
else
    bash "$SCRIPT_DIR"/combine/add.sh ${csv_files}
fi

# cat "$MAIN"