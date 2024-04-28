#!/usr/bin/bash

usage="Usage: bash submission.sh git_checkout <commit-hash>"

# Check if the no. of arguments is correct
if [[ $# -eq 0 ]]; then
    echo -e "${usage}"
    exit 1
fi

# Check if the user is in a mygit repository
if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a git repository.${NC}"
    exit 1
fi

# Check if the destination is set
if [[ ! -e $(cat .mygit/dest) ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

dest=$(realpath $(cat .mygit/dest))

# Check if the git log exists
if [[ ! -e "$dest/.git_log" ]]; then
    echo -e "${RED}No commits yet.${NC}"
    exit 1
fi

# Check if the commit hash is "LAST"
if [[ "$1" == "LAST" ]]; then
    go=$(head -n 1 $dest/.git_log | cut -d',' -f2)
else
    go=$1
fi

# Check if the commit hash exists
if [[ $(grep -q -E "^commit,$go" $dest/.git_log) ]]; then
    echo -e "${RED}No such commit.${NC}"
    exit 1
fi

# Check if the commit hash is ambiguous
if [[ $(grep -c -E "^commit,$go" $dest/.git_log) -gt 1 ]]; then
    echo -e "${RED}Ambiguous commit hash.${NC}"
    exit 1
fi
# Check if there are uncommitted changes
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


# Get the commit line of the target commit
commit=$(grep -E "^commit,$go" $dest/.git_log)

# Get the commit data into an array
IFS=',' read -r -a array <<< "$commit"

# Get the commit hash
hash=${array[1]}

# Check if the HEAD is already at the target commit
if [[ -e .mygit/HEAD ]]; then
    if [[ $(cat .mygit/HEAD) == $hash ]]; then
        echo -e "${YELLOW}Already at commit $hash.${NC}"
        exit 0
    fi
fi

# Get the total number of commits
total=$(grep -c "^commit," $dest/.git_log)
# Get the line number of the target commit 
line_number=$(grep -n -E "^commit,$1" $dest/.git_log | cut -d':' -f1)
# Get the index of the commit from the end
index=$((total - line_number))
# Get the number of commits to be checked out (cuz the MOD 😉)
len=$(( (index) % MOD + 1))

# Get the commit hashes of the commits to be checked out
commits=()
while IFS= read -r commit; do
    commits+=("$commit")
done < <(head -n $((line_number + len - 1)) $dest/.git_log | tail -n $len | cut -d',' -f2 | tac)

# Go through the commits and apply the patches
cp "$dest/commits/${commits[0]}"/* .
for i in $(seq 1 $len); do
    if [[ $i -lt ${#commits[@]} ]]; then
        for file in $(ls "$dest/commits/${commits[$i]}/"); do
            if [[ "${file: -4}" == ".csv" ]]; then
                cp "$dest/commits/${commits[$i]}/$file" .
            else
                patch -s ${file%.patch}.csv "$dest/commits/${commits[$i]}/$file"
            fi
        done
    fi
done

# Update the HEAD file
echo $hash > .mygit/HEAD

echo -e "${CYAN}HEAD ${GREEN}is now at $hash${NC}"