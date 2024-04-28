#!/usr/bin/bash

usage="Usage: bash submission.sh git_commit -m <message>"

# Check if the user is in a mygit repository
if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a mygit repository.${NC}"
    exit 1
fi

# Check if the destination is set
if [[ ! -e $(cat .mygit/dest) ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

# Check if the flags are -h or --help or help
if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
    echo -e "${usage}"
    exit 0
fi

# Check if the number of arguments is correct
if [[ $# -le 1 || $# -gt 2 ]]; then
    echo -e "${usage}"
    exit 1
fi

# Get the destination
dest=$(realpath $(cat .mygit/dest))

# Check if the user's name and email are set
if [[ ! -e .mygit/user_name ]]; then
    echo -e "${RED}User name not set.${NC}"
    echo -e "${YELLOW}Use: bash submission.sh git_config user.name <name>${NC}"
    exit 1
fi

if [[ ! -e .mygit/user_email ]]; then
    echo -e "${RED}User email not set.${NC}"
    echo -e "${YELLOW}Use: bash submission.sh git_config user.email <email>${NC}"
    exit 1
fi

# Check if the flag -m is used
if [ "$1" == "-m" ]; then
    # Get the commit message
    message="$2"
    #Wed Mar 27 21:36:18 2024 +0530
    # Get the current date and time
    datetime=$(date +"%a %b %d %H:%M:%S %Y %z")
    # Get the hash
    hash=$(openssl rand -hex 20 )
    # Check if the commit is the first commit and edit the .git_log file accordingly
    if [[ $(grep -c "^commit," $dest/.git_log) -eq 0 ]]; then
        echo "commit,$hash,$(cat .mygit/user_name),$(cat .mygit/user_email),$datetime,$message" > $dest/.git_log
    else
        sed -i "1i commit,$hash,$(cat .mygit/user_name),$(cat .mygit/user_email),$datetime,$message" $dest/.git_log
    fi
    echo "Files different from previous commits:"

    declare -a files
    
    for file in $(ls | grep -E ".*\.csv"); do
        if [[ -e "$dest/last_commit/$file" ]]; then
            if [[ $(diff -q $file $dest/last_commit/$file) ]]; then
                files+=($file)
                echo -e "${BLUE}$file${NC}"
            fi
        else
            files+=($file)
            echo -e "${GREEN}$file${NC}"
        fi
    done
    # Print the hash of current commit into the HEAD file
    echo $hash > .mygit/HEAD
    # Create a directory for the commit according to the MOD value
    if [[ $(($(grep -c "^commit," $dest/.git_log) % MOD)) -eq 1 ]]; then
        mkdir -p $dest/commits/$hash
        cp $(ls | grep -E "^.*\.csv$") $dest/commits/$hash
    else
        mkdir -p $dest/commits/$hash
        for file in "${files[@]}"; do
            if [[ -e "$dest/last_commit/$file" ]]; then
                diff -u $dest/last_commit/$file $file > $dest/commits/$hash/${file%.csv}.patch
            else
                cp $file $dest/commits/$hash
            fi
        done
    fi

    # Updates the last_commit directory
    rm -rf $dest/last_commit/*
    cp $(ls | grep -E "^.*\.csv$") $dest/last_commit

    # Prints the commit message with data
    echo -e "\n${YELLOW}commit $hash (${BLUE}HEAD${YELLOW})${NC}"
    echo -e "Author:\t$(cat .mygit/user_name) <$(cat .mygit/user_email)>"
    echo -e "Date:\t$datetime"
    echo -e "\n    $message\n"
fi