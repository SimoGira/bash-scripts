#!/bin/bash
# This file contains all functions for program booking system management
#=========================================================================================
#                                        FUNCTIONS
#=========================================================================================
# function for leap year
#-----------------------------------------------------------------------------------------
function isLeapYear(){
    if ([ $((yy % 4)) -eq 0 ] && [ $((yy % 100)) -ne 0 ]) || [ $((yy % 400)) -eq 0 ];
        then
            return 29 #  it is a leap year
        else
            return 28 #  not a leap year : means do nothing and use old value of days
	fi 
}
#-----------------------------------------------------------------------------------------
# function to check if a date as 'YYYYmmdd' is valid (0=TRUE 1=FALSE) 
#-----------------------------------------------------------------------------------------
function checkDate() {
    # check if the date is a numerical number with 8 digits
    local date=$1
    if [ ${#date} -ne 8 ] || ! [[ "$date" =~ ^[0-9]+$ ]]
        then
            printf '\e[1;31minvalid format date.\e[0m\n'
            return 1
    fi
    
    # stripe the date in yy mm dd leading '0' value in mm and dd
    yy=${date:0:4} 
    mm=$(echo ${date:4:2} | sed 's/^0//')
    dd=$(echo ${date:6:2} | sed 's/^0//')

    # if date is less than current date
    # then it is invalid date for book (mean you want make a booking to past)
    if [ $yy -lt `date +%Y` ] || (([ $yy -eq `date +%Y` ] && [ $mm -lt `date +%m` ]) || ([ $yy -eq `date +%Y` ] && [ $mm -eq `date +%m` ] && [ $dd -lt `date +%d` ]))
        then
            printf '\e[1;31mdate is in past or invalid\e[0m.\n'
            return 1
    fi

    # if month is less then 1 or greater than 12
    # then it is invalid month
    if [ $mm -lt 1 ] || [ $mm -gt 12 ]
        then
            printf '%s is \e[1;31minvalid month.\e[0m\n' $mm
            return 1
    fi

    # Find out number of days in given month
    case $mm in
        1) days=31;;
        2) isLeapYear # find out if it is a leap year or not
           days=$? ;;
        3) days=31 ;;
        4) days=30 ;;
        5) days=31 ;;
        6) days=30 ;;
        7) days=31 ;;
        8) days=31 ;;
        9) days=30 ;;
        10) days=31 ;;
        11) days=30 ;;
        12) days=31 ;;
        *) days=-1;;
    esac

    # if day is negative (<=0) and if day is more than that months days
    # then day is invaild
    if [ $dd -le 0 ] || [ $dd -gt $days ];
        then
            printf '%s is \e[1;31minvalid day.\e[0m\n' $dd
            return 1
    fi
    # if no error that means date YYYYmmdd is valid one
    return 0
}
#-----------------------------------------------------------------------------------------
# function to check availability for Delete
#-----------------------------------------------------------------------------------------
function checkAvailabilityForDelete(){  # $name $date $hour $username
    # check existence in file
    if grep -i -q "$name;$date;$hour" "$BOOKFILE"
        then
            return 1
        else
            return 0
    fi
}
#-----------------------------------------------------------------------------------------
# function to get <name;date;hour> from user for delete
#-----------------------------------------------------------------------------------------
function getDataForDelete(){
    # Ask the user for a name and assign to a variable
    echo -n "Insert classroom name: "   
    read name
    
    # The first if statement will return true if a variable is unset or set to the empty string.
    # then it check if there are spaces in name
    while [ -z "$name" ] || [[ "$name" =~ [^0-9A-Za-z]+ ]]
        do 
           printf 'classroom \e[1;31mnot valid\e[0m.\n' 
           echo -n "Please insert classroom name: " 
           read name
    done

    # Ask the user for a date in format ddmmYY and assign to a variable
    echo -n "Insert date <YYYYmmdd>: " 
    read date 
    checkDate $date
    while [ $? -eq 1 ]
        do
            echo -n "Insert date <YYYYmmdd>: " 
            read date 
            checkDate $date
    done
    
    # Ask the user for hour and assign to a variable
    echo -n "Insert hour <h>: "
    read hour
    checkHour
}
#-----------------------------------------------------------------------------------------
# function to check for availability for book
#-----------------------------------------------------------------------------------------
function checkAvailabilityForBook(){  # $name $date $hour $username
    # if file not exist
    if [ ! -e $BOOKFILE ]                              
        then
            printf '\e[1;36mFile not exist\e[0m, creating %s...\n' $BOOKFILE
            touch $BOOKFILE
            return 0
                
        elif grep -i -q "$name;$date;$hour" "$BOOKFILE"
        then
            # code if found
            printf '%s \e[1;31malready exist\e[0m%s\n\n' 'This book' ', try again!'
            return 1
        else
            return 0
    fi
}
#-----------------------------------------------------------------------------------------
# function to get <name;date;hour;username> from user for book
#-----------------------------------------------------------------------------------------
function getDataForBook(){
    # Ask the user for a name and save it in a variable
    echo -n "Insert classroom name: "   
    read name
    
    # The first if statement will return true if a variable is unset or set to the empty string ("").
    # then it check if there are spaces in name
    while [ -z "$name" ] || [[ "$name" =~ [^0-9A-Za-z]+ ]]
        do 
           printf 'classroom name \e[1;31mnot valid\e[0m.\n' 
           echo -n "Please insert a valid classroom name: " 
           read name
    done
    
    name="$(echo $name | tr '[:lower:]' '[:upper:]')"

    # Ask the user for a date in format ddmmYY and assign to a variable
    echo -n "Insert date <YYYYmmdd>: " 
    read date 
    checkDate $date
    while [ $? -eq 1 ]
        do
            echo -n "Insert date <YYYYmmdd>: " 
            read date 
            checkDate $date
    done
    
    # Ask the user for hour and assign to a variable
    echo -n "Insert hour <h>: "
    read hour
    checkHour

    # Ask the user for user name and assign to a variable
    echo -n "Insert username: " 
    read username
}
#-----------------------------------------------------------------------------------------
# function to check for correct insert of hour
#-----------------------------------------------------------------------------------------
function checkHour(){
    # if out of range or if is in past   
    while ! [[ "$hour" =~ ^[0-9]+$ ]] || [ $hour -lt 8 ] || [ $hour -gt 17 ] || ([ $date -eq `date +%Y%m%d` ] && [ $hour -le `date +%H` ])
        do
            printf 'Hour \e[1;31mnot valid\e[0m, range is from 8 to 17\n'
            echo -n "Please insert hour <h>: "
            read hour
    done     
}
#-----------------------------------------------------------------------------------------
# function show the content of file with opportune message description (arguments: file, message)
#-----------------------------------------------------------------------------------------
function printContentOfFile(){
    local MESSAGE=$(echo $2 | tr ';' ' ')
    printf "\n\e[4m%s\e[0m:\n" "$MESSAGE"
    tr ';' '[:space:]' < $1 # translate: questa va bene per show book and show booking for
    echo
}
#-----------------------------------------------------------------------------------------
# function to check if file exist
#-----------------------------------------------------------------------------------------
function fileIsAvailable(){
    if [ ! -e $BOOKFILE ] || [ ! -s $BOOKFILE ]
        then
            printf 'Error \e[1;31mfile not exist or it is empty\e[0m, create it first.\n'
            return 1
        else
            return 0
    fi
}