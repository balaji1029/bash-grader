#!/bin/bash

usage="Usage: bash submission.sh upload [path/to/file1.csv] [path/to/file2.csv] [path/to/file3.csv] [...]"

# usage: This script is used to upload files.
if [ $# -eq 0 ]; then
    echo -e "${RED}${usage}${NC}"
    exit 1
else
    if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ]; then
        echo -e "${usage}"
        exit 0
    fi
    echo "Uploading files..."
    echo "------------------"
    for file in "$@"; do
        if [ -e "$file" ]; then
            if [ -f "$file" ]; then
                if [[ "$file" =~ \.csv$ ]]; then
                    cp "$file" "$(pwd)"
                    echo -e "${GREEN}${file} uploaded.${NC}"
                else
                    echo -e "${RED}Invalid file format: ${file}${NC}"
                fi
            else
                echo -e "${RED}${file} is not a file.${NC}"
            fi
        else
            echo -e "${RED}${file} does not exist.${NC}"
        fi
        echo "------------------"
    done
fi