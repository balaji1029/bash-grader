#!/usr/bin/bash

frames_file="train.txt"
frames=()
while IFS= read -r line; do
    frames+=("$line")
done < "$frames_file"

# Calculate the width of the terminal
term_width=$(tput cols)
term_height=$(tput lines)
train_lines=${#frames[@]}
offset=$((term_height / 2 - train_lines / 2 - 1))

# Function to clear the screen and display the next frame
animate_train() {
    lower_limit=$((-${#frames[0]}))
    upper_limit=$term_width
    train_length=${#frames[0]}
    for ((i = $upper_limit; i >= $lower_limit; i--)); do
        clear
        length=$((train_length + i))
        for ((j = 0; j < offset; j++)); do
            echo
        done
        for frame in "${frames[@]}"; do
            if [[ $i -ge 0 ]] && [[ $((i + train_length)) -ge $term_width ]]; then
                length=$((term_width - i))
                printf "%${term_width}s\n" "${frame:0:$length}"
            elif [[ $i -ge 0 ]] && [[ $((i + train_length)) -lt $term_width ]]; then
                printf "%$((i + train_length))s\n" "${frame}"
            elif [[ $i -lt 0 ]] && [[ $((i + train_length)) -ge $term_width ]]; then
                length=$term_width
                printf "%s\n" "${frame:0:$term_width}"
            else
                printf "%s\n" "${frame:$((-i))}"
                # j=2
            fi
        done
        sleep 0.02
    done
}

# Run the animation function
animate_train