#!/usr/bin/bash

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m'

# usage: This script is used to upload files.
if [ $# -eq 0 ]; then
    echo -e "Usage: ${BLUE}bash submission.sh upload [path/to/file1.csv] [path/to/file2.csv] [path/to/file3.csv] [...]${NC}"
    exit 1
else
    echo "Uploading files..."
    echo "------------------"
    for file in "$@"; do
        if [ -e $file ]; then
            if [ -f $file ]; then
                if [[ $file =~ \.csv$ ]]; then
                    cp $file `pwd`
                    echo -e "${GREEN}${file} uploaded.${NC}"
                else
                    echo -e "${RED}Invalid file format: $file${NC}"
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