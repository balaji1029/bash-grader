#!/usr/bin/bash

usage="Usage: bash submission.sh git_commit -m <message>"

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

if [[ $# -le 1 || $# -gt 2 ]]; then
    echo -e "${usage}"
    exit 1
fi

dest=$(realpath $(cat .mygit/dest))

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

if [ "$1" == "-m" ]; then
    message="$2"
    #Wed Mar 27 21:36:18 2024 +0530
    datetime=$(date +"%a %b %d %H:%M:%S %Y %z")
    hash=$(openssl rand -hex 8)
    if [[ $(grep -c "^commit," $dest/.git_log) -eq 0 ]]; then
        echo "commit,$hash,$(cat .mygit/user_name),$(cat .mygit/user_email),$datetime,$message" > $dest/.git_log
    else
        sed -i "1i commit,$hash,$(cat .mygit/user_name),$(cat .mygit/user_email),$datetime,$message" $dest/.git_log
    fi
    echo "Files different from previous commits:"
    # diff -rq . $dest/last_commit
    # diff -rq . $dest/last_commit | awk -F': ' '{print $2}' | grep -E "^.*\.csv$"
    # diff -rq . $dest/last_commit | sed -E "s/^Files \./([^ ]+\.csv).*/\1/"
    # files=$(diff -rq . $dest/last_commit | sed "s/Only in .: //" | grep -E "^.*\.csv$")

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

    echo $hash > $dest/commits/HEAD
    if [[ $(($(grep -c "^commit," $dest/.git_log) % 5)) -eq 1 ]]; then
        mkdir -p $dest/commits/$hash
        cp $(ls | grep -E "^.*\.csv$") $dest/commits/$hash
    else
        mkdir -p $dest/commits/$hash
        # diff <(cd $dest/last_commit && find . -name "*.csv" -exec md5sum {} \; | sort -k 2) <(cd . && find . -name "*.csv" -exec md5sum {} \; | sort -k 2)
        # diff -u $dest/last_commit . > $dest/commits/$hash/diff
        for file in "${files[@]}"; do
            # if [[ $(ls $dest/last_commit | grep -c "$file") -eq 1 ]]; then
            #     diff -u $dest/last_commit/$file $file > $dest/commits/$hash/{$file%.csv}.patch
            # else
            #     cp $dest/last_commit/$file $dest/commits/$hash
            # fi
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
    echo -e "\n\t$message\n"
fi