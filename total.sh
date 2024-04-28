#!/usr/bin/bash

echo "Totalling files..."

# Check if the main.csv file exists
if [[ -e "$MAIN" ]]; then
    # Add a column total to the main.csv file
    if [[ $(head -n 1 "$MAIN") =~ ,total$ ]]; then
        awk -F, 'BEGIN{ OFS = "," } { if (NR == 1) { next } else { sum = 0; for (i = 2; i < NF; i++) sum += $i; $NF = sum; print $0 } }' main.csv > temp.csv
        echo "Totalled files."
    else
        awk -F, 'BEGIN { OFS = "," } { if (NR == 1) { print $0, "total" } else { sum = 0; for (i = 2; i <= NF; i++) sum += $i; print $0, sum } }' main.csv > temp.csv
        mv temp.csv main.csv
        echo "Totalled files."
    fi
else
    echo "main.csv does not exist."
    echo "Combining the csv files first..."
    bash "$SCRIPT_DIR/combine/combine.sh"
    echo "Finding the total"
    bash "$SCRIPT_DIR/total.sh"
fi