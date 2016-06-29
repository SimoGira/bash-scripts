#! /bin/bash 
printf '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\e[7;36m CLASSROOMS MANAGEMENT SYSTEM \e[0m\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'


# setup some values
# delimiter=;
BOOKFILE="aule.txt" # Filename for bookings 
COLUMNS=1

# load functions
source Functions.sh


PS3=$'\nPlease enter your choice: '
select opt in "Book" "Delete booking" "Show classroom" "Bookings per classroom" "Exit"; do
    case $opt in
        "Book")
            source Book.sh
            ;;
        "Delete booking")
            source DeleteBooking.sh
            ;;
        "Show classroom")
            source ShowClassroom.sh
            ;;
        "Bookings per classroom")
            source BookingsPerClassroom.sh
            ;;
        "Exit")
            echo exiting...
            break
            ;;
        *) 
            printf 'Error: \e[1;31mselection not exist\e[0m, try again (select 1..5)!\n'
            ;;
    esac
done
