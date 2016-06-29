#! /bin/bash 

# UTILITA'
# --------------------------------------------------------------------------
#  the file is sorted by date and time:

# sed -n '\.^02/04/2002.,$p' dates.list > results.list
# Prints from the first line starting with 02/04/2002 to the end of the file.

if fileIsAvailable $0     
then
	printContentOfFile $BOOKFILE "Booking;contained;in;file"
    echo -n "Insert classroom name: "   
    read name
    # if enterend name is invalid try again
    while [ -z "$name" ]
        do    
            printf 'classroom name \e[1;31mnot valid\e[0m.\n' 
            echo -n "Please insert classroom name: " 
            read name
    done
    
    # if name of classroom exist in file
    if cut -d \; -f1 "$BOOKFILE" | grep -i -q -w "$name"
    then
        printf '\n\e[4mBOOKINGS FOR CLASSROOM %s\e[0m:\n\e[1;36mDay             Hour    User\e[0m\n' $name
        grep -i -w "$name" "$BOOKFILE" | cut -d \; -f2,3,4 | tr ';' '[:space:]'
    else
        printf "There are \e[1;31mno booked classrooms with this name\e[0m."
    fi
            
fi