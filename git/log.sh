#!/usr/bin/bash

usage="${RED}Usage: bash submission.sh git_log${NC}"

if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a git repository.${NC}"
    exit 1
fi

if [[ ! -e $(cat .mygit/dest) ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
    echo -e "${usage}"
    exit 0
fi

dest=$(cat .mygit/dest)

if [[ $# -ne 0 ]]; then
    echo -e "${usage}"
    exit 1
fi

if [[ ! -e $dest/.git_log ]]; then
    echo -e "${RED}No commits yet.${NC}"
    exit 1
fi

echo

while read -r line; do
    IFS=',' read -r -a array <<< "$line"
    echo -ne "${YELLOW}commit ${array[1]}${NC}"
    if [[ $(cat $dest/commits/HEAD) == ${array[1]} ]]; then
        echo -e " ${YELLOW}(${BLUE}HEAD${YELLOW})${NC}"
    else
        echo
    fi
    echo -e "Date:\t${array[2]}"
    echo -e "\n\t${array[3]}"
    echo
done < $dest/.git_log