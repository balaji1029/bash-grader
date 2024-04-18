#!/usr/bin/bash
shift

if [[ $# -ne 1 ]]; then
    echo "Usage: bash submission.sh update <quiz-name>"
    exit 1
fi

if [[ ! -f "$SCRIPT_DIR/$1.csv" ]]; then
    echo "File not found."
    exit 1
fi

quiz="$1"

while true
do
    echo -n "Enter the Student's name: "
    read name
    echo -n "Enter the roll number: "
    read roll_no
    roll_no=$(echo "$roll_no" | tr "[:upper:]" "[:lower:]")
    echo -n "Enter the marks: "
    read marks

    count=$(grep -c "^$roll_no,$name," "$quiz.csv")
    echo $count
    # TODO
    if [[ $count -eq 1 ]]; then
        # grep -cE "^$roll_no,$name,[0-9.a]+$" "$quiz.csv"
        sed -i -E "s/^($roll_no),($name),[0-9.a]+$/\\1,\\2,$marks/" "$quiz.csv"
        if [[ $(head -n 1 "$MAIN") =~ ,total$ ]]; then
            
        else
            awk -F, -v roll_no=$roll_no 'BEGIN{ OFS = "," } {if ($1 ==)}' main.csv > temp.csv
        fi
    else
        echo "${RED}No student with $name and $roll_no exists."
    fi
    
    echo -n "Do you want to add more marks? (y/n) "
    read taking

    if [[ "$taking" -ne "y" && "$taking" -ne "Y" ]]; then
        break
    fi

    if [[ "$talking" -eq "n" || "$taking" -eq "N" ]]; then
        break
    fi
done < /dev/tty