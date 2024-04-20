BEGIN{
    FS = ",";
    OFS = ",";
    head = "sed -n '1p' " main;
    head | getline header;
    gsub(/\r/, "", header);
    # print header
    split(header, headers, ",");
    for (i=3; i<=length(headers); i++){
        if (headers[i] == file){
            file_index = i;
            break
        }
    }
    # print file_index
}

NR > 1 {
    gsub(/\r/, "", $0);
    roll_no = $1;
    # print roll_no
    count = "grep -ic " roll_no ", " main;
    count | getline count;
    # print $0, count
    if (count < 1){
        # print $0
        string = roll_no OFS $2
        for (i=3; i<=NF+1; i++){
            if (i != file_index){
                string = string OFS "a"
            }
            else{
                string = string OFS $3
            }
        }
        # print string
        add = "echo " string " >> " main;
        system(add)
    }
    # print $file_index
}