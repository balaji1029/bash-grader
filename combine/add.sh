#!/usr/bin/bash

# echo $@
for file in "$@"; do
    if [[ "$file" == "$MAIN" ]] || [[ "$file.csv" == "temp.csv" ]]; then
        continue
    fi
    echo "Processing $file.csv..."
    # Check if $MAIN exists
    if [ ! -f "$MAIN" ]; then
        touch "$MAIN"
        echo "Roll_number,Name,$file" > "$MAIN"
        # tail -n +2 "$SCRIPT_DIR/$file.csv" | sed -E "s/^([^,])*,/\L\1,/" >> "$MAIN"
        # tail -n +2 "$SCRIPT_DIR/$file.csv"  >> "$MAIN"
        awk 'BEGIN{ FS = ","; OFS = "," } NR > 1 { $1 = tolower($1); print }' "$file.csv" >> "$MAIN"
    else
        # Check if $MAIN has total header
        if [[ $(head -n 1 "$MAIN") =~ ,total$ ]]; then
            # TODO: Write code if total exists...
            # echo "TODO"
            awk -v file="$file" -f "$SCRIPT_DIR"/combine/add_total.awk "$MAIN" > "$SCRIPT_DIR/temp.csv"
            mv "$SCRIPT_DIR/temp.csv" "$MAIN"
            awk -v main="$MAIN" -v file="$file" -f "$SCRIPT_DIR"/combine/readd_total.awk "$SCRIPT_DIR/$file.csv"
        else
            awk -v file="$file" -f "$SCRIPT_DIR"/combine/add.awk "$MAIN" > "$SCRIPT_DIR/temp.csv"
            mv "$SCRIPT_DIR/temp.csv" "$MAIN"
            awk -v main="$MAIN" -v file="$file" -f "$SCRIPT_DIR"/combine/readd.awk "$SCRIPT_DIR/$file.csv"
        fi
    fi
done