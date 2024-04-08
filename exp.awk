BEGIN{
    FS = ","
    OFS = ","
}

NR > 1 {
    roll_no_present = "grep -c " $1", quiz1.csv"
    roll_no_present | getline roll_no_present
    roll_no_present = roll_no_present > 0 ? 1 : 0
    print roll_no_present
}