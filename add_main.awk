BEGIN{
    OFS = ","
}
{
    print
    nf = NF
}
END{
    out = roll_no OFS name
    for(i=3; i<=nf; i++){
        if(i == field_number){
            out = out OFS marks
        } else {
            out = out OFS "a"
        }
    }
    print out
}