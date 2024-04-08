#!/usr/bin/bash

# echo $@
for file in "$@"; do
    if [[ "$file" == "$MAIN" ]] || [[ "$file" == "temp.csv" ]]; then
        continue
    fi
    echo "Processing $file.csv..."
    # Check if $MAIN exists
    if [ ! -f "$MAIN" ]; then
        touch "$MAIN"
        # echo "Roll_number,Name,$file" > "$MAIN"
        tail -n +2 "$SCRIPT_DIR/$file.csv" >> "$MAIN"
    else
        echo "Roll_number,Name"
        # Check if $MAIN has total header
        if [[ $(head -n 1 "$MAIN") =~ ,total$ ]]; then
            # TODO: Write code if total exists...   
            echo "TODO"
        else
            awk -v file="$file" -f "$SCRIPT_DIR"/combine/add.awk "$MAIN" > "temp.csv"
            mv temp.csv "$MAIN"
        fi
    fi
done