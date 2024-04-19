#!/usr/bin/bash

usage="Usage: bash submission.sh git_checkout <commit-hash>"

if [[ $# -eq 0 ]]; then
    echo -e "${usage}"
    exit 1
fi

if [[ ! -e .mygit ]]; then
    echo -e "${RED}Not a git repository.${NC}"
    exit 1
fi

if [[ ! -e $(cat .mygit/dest) ]]; then
    echo -e "${RED}Destination not set.${NC}"
    exit 1
fi

dest=$(realpath $(cat .mygit/dest))

if [[ ! -e "$dest/.git_log" ]]; then
    echo -e "${RED}No commits yet.${NC}"
    exit 1
fi

if [[ $(grep -q -E "^commit,$1" $dest/.git_log) ]]; then
    echo -e "${RED}No such commit.${NC}"
    exit 1
fi

if [[ $(grep -c -E "^commit,$1" $dest/.git_log) -gt 1 ]]; then
    echo -e "${RED}Ambiguous commit hash.${NC}"
    exit 1
fi

commit=$(grep -E "^commit,$1" $dest/.git_log)

IFS=',' read -r -a array <<< "$commit"

hash=${array[1]}

if [[ -e .mygit/HEAD ]]; then
    if [[ $(cat .mygit/HEAD) == $hash ]]; then
        echo -e "${YELLOW}Already at commit $hash.${NC}"
        exit 0
    fi
fi

total=$(grep -c "^commit," $dest/.git_log)
line_number=$(grep -n -E "^commit,$1" $dest/.git_log | cut -d':' -f1)
index=$((total - line_number))
len=$(( (index) % 5 + 1))

commits=()
while IFS= read -r commit; do
    commits+=("$commit")
done < <(head -n $((line_number + len - 1)) $dest/.git_log | tail -n $len | cut -d',' -f2 | tac)

# head -n $((line_number + len - 1)) $dest/.git_log | tail -n $len | cut -d',' -f2 | tac

# echo "${commits[@]}"
# rm *.csv 2> /dev/null
# if [[ ${#commits[@]} -ge 1 ]]; then
#     echo -e "${RED}No commits yet.${NC}"
#     exit 1
# fi
cp "$dest/commits/${commits[0]}"/* .
# seq 1 $len
# ls "$dest/commits/${commits[1]}/"
for i in $(seq 1 $len); do
    if [[ $i -lt ${#commits[@]} ]]; then
        for file in $(ls "$dest/commits/${commits[$i]}/"); do
            # if [[ -e "$file" ]]; then
            #     diff -q "$file" "$dest/commits/${commits[$i]}/$file"
            # else
            #     cp "$dest/commits/${commits[$i]}/$file" .
            # fi

            if [[ "${file: -4}" == ".csv" ]]; then
                cp "$dest/commits/${commits[$i]}/$file" .
            else
                # echo ${file%.patch}.csv "$dest/commits/${commits[$i]}/$file"
                patch -s ${file%.patch}.csv "$dest/commits/${commits[$i]}/$file"
            fi
        done
    fi
done

echo $hash > .mygit/HEAD

echo "${GREEN}HEAD is now at $hash${NC}"

# echo "Line number: $line_number"