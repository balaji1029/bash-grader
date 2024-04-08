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
<<<<<<< HEAD
        echo "Roll_number,Name,$file" > "$MAIN"
        tail -n +2 "$SCRIPT_DIR/$file.csv" >> "$MAIN"
        cat "$MAIN"
=======
        # echo "Roll_number,Name,$file" > "$MAIN"
        tail -n +2 "$SCRIPT_DIR/$file.csv" >> "$MAIN"
>>>>>>> bde852d416de6a9b9a578ad3f0bc5cddcdd64abc
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