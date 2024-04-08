#!/usr/bin/bash

echo "Totalling files..."

# Check if the main.csv file exists
if [ -e main.csv ]; then
    # Get the names of the .csv files
    csv_files=$(find . -maxdepth 1 -type f -name "*.csv" -not -name "main.csv")
    # Add a column total to the main.csv file
    awk -F, 'BEGIN { OFS = "," } { if (NR == 1) { print $0, "total" } else { sum = 0; for (i = 2; i <= NF; i++) sum += $i; print $0, sum } }' main.csv > temp.csv
    mv temp.csv main.csv
    # Add the total scores of the students in all the tests
    for file in $csv_files; do
        awk -F, 'BEGIN { OFS = "," } { if (NR == 1) { next } else { sum = 0; for (i = 2; i <= NF; i++) sum += $i; print $0, sum } }' $file > temp.csv
        mv temp.csv "$file"
    done
    echo "Totalled files."
else
    echo "main.csv does not exist."
    echo "Combining the csv files first..."
    bash combine.sh
    echo "Finding the total"
    bash total.sh
fi