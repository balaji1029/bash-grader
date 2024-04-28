#!/usr/bin/bash
shift

# Check if the no. of arguments is correct
if [[ $# -ne 1 ]]; then
    echo "Usage: bash submission.sh update <quiz-name>"
    exit 1
fi

# Check if the quiz exists
if [[ ! -f "$SCRIPT_DIR/$1.csv" ]]; then
    echo "File not found."
    exit 1
fi

quiz="$1"

# Check if the quiz is already combined
if [[ $(head -n 1 "$MAIN") =~ ,$quiz$ ]]; then\
    echo "Quiz $quiz does not exist in main.csv."
    echo "Please combine the quiz first."
    exit 1
fi

# Get the field number of the quiz
field_number=$(awk -F',' '{for(i=1; i<=NF; i++) if($i == "'$quiz'") print i}' "$MAIN")

while true
do
    # Get the student's details
    echo -n "Enter the Student's name: "
    read name
    echo -n "Enter the roll number: "
    read roll_no
    roll_no=$(echo "$roll_no" | tr "[:upper:]" "[:lower:]")
    echo -n "Enter the marks: "
    read marks

    # Check if the marks are valid
    if [[ ! "$marks" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        echo "Invalid marks."
        echo
        continue
    fi

    # Check if the student exists
    if [[ $(grep -icE "^$roll_no,$name," "$MAIN") -eq $(grep -cE "^$roll_no," "$MAIN") ]]; then
        # Check if main is totalled
        if [[ $(grep -icE ",total$" "$MAIN") -eq 1 ]]; then
            # Check if the student has already been added
            if [[ $(grep -icE "^$roll_no,$name," "$quiz.csv") -eq 0 ]]; then
                echo "$roll_no,$name,$marks" >> "$quiz.csv"
            else
                sed -i -E "s/^($roll_no,[A-Za-z ]+,).*$/\1$marks/" "$quiz.csv"
            fi
            # Update the marks in main.csv
            awk -v field_number="$field_number" -v marks="$marks" -v roll_no="$roll_no" -v name="$name" -F',' '
            BEGIN {
                OFS = ","
            }
            {
                $1 = $1
                if($1 == roll_no && tolower($2) == tolower(name)){
                    if ($field_number == "a") {
                        $NF += marks
                    } else {
                        $NF += marks - $field_number
                    }
                    $field_number = marks
                }
                print
            }' "$MAIN" > "$SCRIPT_DIR/temp.csv"
            mv "$SCRIPT_DIR/temp.csv" "$MAIN"
        else
            # Check if the student has already been added
            if [[ $(grep -icE "^$roll_no,$name," "$quiz.csv") -eq 0 ]]; then
                echo "$roll_no,$name,$marks" >> "$quiz.csv"
            else
                sed -i -E "s/^($roll_no,[A-Za-z ]+,).*$/\1$marks/" "$quiz.csv"
            fi
            # Update the marks in main.csv
            awk -v field_number="$field_number" -v marks="$marks" -v roll_no="$roll_no" -v name="$name" -F',' '
            BEGIN {
                OFS = ","
            }
            {
                $1 = $1
                if($1 == roll_no && tolower($2) == tolower(name)){
                    $field_number = marks
                }
                print
            }' "$MAIN" > "$SCRIPT_DIR/temp.csv"
            mv "$SCRIPT_DIR/temp.csv" "$MAIN"
        fi
    else
        echo "The name and roll number do not match."
        echo
        continue
    fi
    
    echo -n "Do you want to add more marks? (y/n) "
    read taking

    taking=$(echo "$taking" | tr "[:upper:]" "[:lower:]")

    if [[ $(grep -cE "^y$" <<< "$taking") == 1 ]]; then
        echo
        continue
    fi

    if [[ $(grep -cE "^n$" <<< "$taking") == 1 ]]; then
        break
    else
        echo
        continue
    fi
done