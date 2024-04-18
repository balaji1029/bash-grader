#!/usr/bin/bash

if $# -ne 1; then
    echo "${RED}Usage: bash submission.sh git_init${NC}"
    exit 1
fi

if [[ ! -d $1 ]]; then
    echo "${RED}A file exists at the Not a git repository.location with same name.${NC}"
    exit 1
fi

if [[ -e .mygit ]]; then
    if [[ -d .mygit ]]; then
        echo "${RED}.mygit already exists.${NC}"
        exit 1
    else
        echo "${RED}A file named .mygit already exist${NC}"
        exit 1
    fi
fi

mkdir .mygit

echo "Initialized empty MyGit repository in $(pwd)/.mygit"