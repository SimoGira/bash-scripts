#! /bin/bash 

# UTILITA' E VARIE
# `date -j -f '%d%m%Y' "12102014" +'%d/%m/%Y'` date formatted as dd/mm/yyyy

#=========================================================================================
#                               START SCRIPT FOR BOOKING
#=========================================================================================
# if file already exist display the unavailable bookings
if test -e $BOOKFILE
    then 
        printContentOfFile $BOOKFILE "Booking;not;available"
fi

# ask user data for the book
getDataForBook

# check availability (0=TRUE, 1=FALSE)
checkAvailabilityForBook
while [ $? -eq 1 ]
    do
        getDataForBook
        checkAvailabilityForBook
done

# Echo the answers and ask for confirmation
echo -e "\nShould I enter the values:"
echo -e "$name $date $hour $username"
echo -n "y/n? "
read answer

# if answer is yes, insert sorted data in file
if [ "$answer" == "y" ] 
        then
            # Write the values to file
            echo "$name;$date;$hour;$username" >>$BOOKFILE
            sort -t ';' -k2,2n -k3,3n $BOOKFILE -o $BOOKFILE
            printf '\e[1;32mdone\e[0m.\n'
        else
            # Give the user a message
            printf '%s ; %s ; %s ; %s \e[1;31mnot written\e[0m to %s\n' $name $date $hour $username $BOOKFILE
fi