#!/usr/bin/bash

usage="${RED}Usage: bash submission.sh git_add <files>${NC}"

if [[ $# -eq 0 ]]; then
    echo -e "$usage"
    exit 1
fi

if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a git repository.${NC}"
    exit 1
fi

if [[ ! -e .mygit/dest ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

for file in "$@"; do
    if [[ ! "$file" =~ \.csv$ ]]; then
        continue
    fi
    if [[ ! -e "$file" ]]; then
        echo -e "${RED}No such file: $file${NC}"
        continue
    fi
    if [[ ! -e .mygit/tracking_files ]]; then
        touch .mygit/tracking_files
    fi
    if [[ $(grep -q "$file" .mygit/tracking_files) ]]; then
        continue
    fi
    if [[ ! -e .mygit/commits/HEAD ]]; then
        touch .mygit/commits/HEAD
    fi
    if [[ ! -e .mygit/commit-list ]]; then
        echo -e "${RED}No commit list.${NC}"
        exit 1
    fi
    if [[ ! $(grep -q "$(cat .mygit/commits/HEAD)" .mygit/commit-list) ]]; then
        echo -e "${RED}No such commit.${NC}"
        exit 1
    fi
done