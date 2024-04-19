#!/usr/bin/bash

usage="Usage: bash submission.sh git_log\n\t${YELLOW}--oneline${NC}\tShow only the commit messages"

if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a git repository.${NC}"
    exit 1
fi

if [[ ! -e $(cat .mygit/dest) ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

dest=$(realpath $(cat .mygit/dest))

if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
    echo -e "${usage}"
    exit 0
fi

if [[ $1 == "--oneline" ]]; then
    while read -r line; do
        IFS=',' read -r -a array <<< "$line"
        if [[ $(cat .mygit/HEAD) == ${array[1]} ]]; then
            echo -e "${YELLOW}${array[1]:0:7} (${CYAN}HEAD${YELLOW})${NC} ${array[5]}"
            continue
        fi
        echo -e "${YELLOW}${array[1]:0:7}${NC} ${array[5]}"
    done < $dest/.git_log
    exit 0
fi

if [[ $# -eq 1 ]]; then
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
    if [[ $(cat .mygit/HEAD) == ${array[1]} ]]; then
        echo -e " ${YELLOW}(${CYAN}HEAD${YELLOW})${NC}"
    else
        echo
    fi
    echo -e "Author:\t${array[2]} <${array[3]}>"
    echo -e "Date:\t${array[4]}"
    echo -e "\n\t${array[5]}"
    echo
done < $dest/.git_log