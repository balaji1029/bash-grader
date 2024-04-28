#!/usr/bin/bash

usage="${RED}Usage: \n\tbash submission.sh git_config user.name <name>\n\tbash submission.sh git_config user.email <email>${NC}"

# Check if the number of arguments is correct
if [[ $# -ne 2 ]]; then
    echo -e "${usage}"
    exit 1
fi

# Check if .mygit exists
if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a git repository.${NC}"
    exit 1
fi

# Check if the destination is set
if [[ ! -e .mygit/dest ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

# Check if the user name and email are set
if [[ "$1" != "user.name" && "$1" != "user.email" ]]; then
    echo -e "${RED}Invalid argument.${NC}"
    exit 1
fi

# Check if the user name is being set
if [[ "$1" == "user.name" ]]; then
    echo "$2" > .mygit/user_name
    echo -e "${GREEN}User name set.${NC}"
    exit 0
fi

# Check if the user email is being set
if [[ "$1" == "user.email" ]]; then
    echo "$2" > .mygit/user_email
    echo -e "${GREEN}User email set.${NC}"
    exit 0
fi
