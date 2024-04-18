BEGIN {
    FS = ","
    OFS = ","
    already_present = 0
    ind = -1;
}

NR == 1 {
    # print file
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
        out = $1
        for (i=2; i < NF; i++) {
            out = out OFS $i
        }
        out = out OFS file OFS $NF
        print out
    }
}

# If the file is already present in the csv file, then get the marks from the file are updated for every student in the main file
already_present && NR > 1 {
    # print "Already present"
    $1 = $1
    roll_no = $1
    roll_no_present = "grep -c " $1", " file ".csv"
    roll_no_present | getline present
    present = present > 0 ? 1 : 0
    close(roll_no_present)
    # print $0, present
    if (present == 1) {
        # print "Roll number present in the file"
        # Get marks from the for roll_no from the file
        get_marks = "grep \"" roll_no "\" " file ".csv | cut -d, -f 3 | sed \"s/\\s\\+//g\""
        get_marks |& getline marks
        $NF += marks - $ind
        $ind = marks
        # $NF += marks
        # print ind
        close(get_marks)
        print $0
    } else {
        # print "Roll number not present in the file"
        $ind = "a"
        print $0
    }
}

# If the file is not present in the csv file, then get the marks from the file are added for every student in the main file
!(already_present) && NR > 1 {
    $1 = $1
    roll_no = $1
    roll_no_present = "grep -c " $1", " file ".csv"
    roll_no_present | getline present
    present = present > 0 ? 1 : 0
    close(roll_no_present)
    # print present
    if (present == 1) {
        # print "Roll number present in the file"
        # Get marks from the for roll_no from the file
        get_marks = "grep \"" roll_no "\" " file ".csv | cut -d, -f 3 | sed \"s/\\s\\+//g\""
        # print get_marks
        get_marks |& getline marks
        close(get_marks)
        gsub(/\r$/, "", $0)
        # print $0, marks
        out = $1
        for (i=2; i < NF; i++) {
            out = out OFS $i
        }
        out = out OFS marks OFS $NF
        print out
    } else {
        # print "Roll number not present in the file"
        # print $0, "a"
        out = $1
        for (i=2; i < NF; i++) {
            out = out OFS $i
        }
        out = out OFS "a" OFS $NF
        print out
    }
}