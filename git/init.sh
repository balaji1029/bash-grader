#!/usr/bin/bash

usage="Usage: bash submission.sh git_init <path-to-directory>"

# Check if the number of arguments is correct
if [[ $# -ne 1 ]]; then
    echo -e "${RED}$usage${NC}"
    exit 1
fi

# Check if the destination is correct
if [[ ! -e $1 ]]; then
    if [[ ! -e $(dirname "$1") ]]; then
        echo -e "${RED}No such directory.${NC}"
        exit 1
    fi

    if [[ ! -d $(dirname "$1") ]]; then
        echo -e "${RED}$(dirname "$1") is a file.${NC}"
        exit 1
    fi
    # Make the directory
    mkdir "$1"
    mkdir "$1/commits"
    touch "$1/.git_log"
    mkdir "$1/last_commit"
    echo -n "" > "$1/.git_log"
else
    # Check if the destination is a directory
    if [[ ! -d $1 ]]; then
        echo -e "${RED}$1 is a file.${NC}"
        exit 1
    fi
    # Empty the directory forcefully
    rm -rf "${1:?}"/*
    mkdir "$1/commits"
    touch "$1/.git_log"
    mkdir "$1/last_commit"
    echo -n "" > "$1/.git_log"
fi

# Check if .mygit exists
if [[ -e .mygit ]]; then
    if [[ -d .mygit ]]; then
        echo -e "${RED}.mygit already exists.${NC}"
        exit 1
    else
        echo -e "${RED}A file named .mygit already exist${NC}"
        exit 1
    fi
fi

# Create the .mygit directory
mkdir .mygit
touch .mygit/dest .mygit/HEAD

echo "$1" > .mygit/dest

echo "Initialized empty MyGit repository in $1"