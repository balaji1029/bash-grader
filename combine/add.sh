#!/usr/bin/bash

# Check if -t flag is set
if [[ "$1" == "-t" ]]; then
    total=1
    shift
else
    total=0
fi

for file in "$@"; do
    if [[ "$file" == "$MAIN" ]] || [[ "$file.csv" == "temp.csv" ]] || [[ "$file.csv" == "rubrics.csv" ]] || [[ "$file.csv" == "graded.csv" ]]; then
        continue
    fi
    echo "Processing $file.csv..."
    # Check if $MAIN exists
    if [ ! -f "$MAIN" ]; then
        touch "$MAIN"
        echo "Roll_number,Name,$file" > "$MAIN"
        awk 'BEGIN{ FS = ","; OFS = "," } NR > 1 { $1 = tolower($1); print }' "$file.csv" >> "$MAIN"
    else
        # Add the scores of all the students in the $MAIN from $file to $MAIN
        awk -v file="$file" -f "$SCRIPT_DIR"/combine/add.awk "$MAIN" > "$SCRIPT_DIR/temp.csv"
        mv "$SCRIPT_DIR/temp.csv" "$MAIN"
        # Add the scores of the students in $file.csv who are not in $MAIN
        awk -v main="$MAIN" -v file="$file" -f "$SCRIPT_DIR"/combine/readd.awk "$SCRIPT_DIR/$file.csv"
    fi
done

if [[ "$total" -eq 1 ]]; then
    # Add total to $MAIN
    echo "Adding total to $MAIN..."
    bash "$SCRIPT_DIR"/total.sh
fi
