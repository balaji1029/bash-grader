#!/usr/bin/bash

if [[ $# -ne 1 ]]; then
    echo -e "${RED}Usage: bash submission.sh git_init <path-to-directory>${NC}"
    exit 1
fi

if [[ ! -e $1 ]]; then
    if [[ ! -e $(dirname "$1") ]]; then
        echo -e "${RED}No such directory.${NC}"
        exit 1
    fi
    if [[ ! -d $(dirname "$1") ]]; then
        echo -e "${RED}$(dirname "$1") is a file.${NC}"
        exit 1
    fi
    mkdir "$1"
    mkdir "$1/commits"
    touch "$1/commits/HEAD"
    touch "$1/.git_log"
    mkdir "$1/last_commit"
    echo -n "" > "$1/.git_log"
else
    rm -rf "${1:?}"/*
    mkdir "$1/commits"
    touch "$1/commits/HEAD"
    touch "$1/.git_log"
    mkdir "$1/last_commit"
    echo -n "" > "$1/.git_log"
fi

if [[ -e .mygit ]]; then
    if [[ -d .mygit ]]; then
        echo -e "${RED}.mygit already exists.${NC}"
        exit 1
    else
        echo -e "${RED}A file named .mygit already exist${NC}"
        exit 1
    fi
fi

# echo "Hello"
mkdir .mygit
touch .mygit/dest .mygit/tracking_files

find . -maxdepth 1 -type f -name "*.csv" -not -name "$MAIN" | sed 's/\.csv$//' | sed -E "s_^\.\/__"  > .mygit/tracking_files

echo "$1" > .mygit/dest

echo "Initialized empty MyGit repository in $1"