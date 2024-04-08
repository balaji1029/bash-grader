BEGIN {
    FS = ","
    OFS = ","
    already_present = 0
    ind = -1;
}

NR == 1 {
    $1 = $1
    already_present = 0
    for (i = 1; i <= NF; i++) {
        # print $i, file
        if ($i == file) {
            already_present = 1;
            ind = i
            break
        }
    }

    if (already_present) {
        print $0
    } else {
        # file = gsub(/\s+$/, "", file)
        print $0, file
    }
}

already_present && NR > 1 {
    $1 = $1
    roll_no = $1
    roll_no_present = "grep -c " $1", quiz1.csv"
    roll_no_present | getline present
    present = present > 0 ? 1 : 0
    close(roll_no_present)
    # print present
    if (present == 1) {
        # print "Roll number present in the file"
        # Get marks from the for roll_no from the file
        get_marks = "grep \"" roll_no "\" " file ".csv | cut -d, -f 3 | sed \"s/\\s\\+//g\""
        get_marks |& getline marks
        $ind = marks
        # print ind
        close(get_marks)
        print $0
    } else {
        # print "Roll number not present in the file"
        $ind = "a"
    }
}

!(already_present) && NR > 1 {
    $1 = $1
    roll_no = $1
    # roll_no_present = "grep -q " roll_no " " file ".csv; echo $pipestatus"
    # roll_no_present |& getline present
    # print present
    roll_no_present = "grep -c " $1", quiz1.csv"
    roll_no_present | getline present
    present = present > 0 ? 1 : 0
    close(roll_no_present)
    # print present
    if (present == 1) {
        # print "Roll number present in the file"
        # Get marks from the for roll_no from the file
        get_marks = "grep \"" roll_no "\" " file ".csv | cut -d, -f 3 | sed \"s/\\s\\+//g\""
        # printf "%s", get_marks
        get_marks |& getline marks
        print marks
        close(get_marks)
        # $0 = gsub(/\n$/, "$", $0)
        print $0 marks
    } else {
        # print "Roll number not present in the file"
        print $0, "a"
    }
    
}

END {
    puts "This is the end"
}