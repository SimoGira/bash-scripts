#!/bin/bash
# Il comando Elimina prenotazione consente di eliminare una prenotazione.
# Verranno richieste le informazioni necessarie (aula, data, ora) tramite riga di comando.
# In caso di prenotazione inesistente, verra' restituito un errore all'utente.

if fileIsAvailable $0
    then
        printContentOfFile $BOOKFILE "Booking;contained;in;file"
        getDataForDelete
    
    if checkAvailabilityForDelete $1
        then
            printf 'Error: %s ; %s ; %s \e[1;31mnot exist\e[0m in %s\n' $name $date $hour $BOOKFILE
    else
        # Echo the answers and ask for confirmation
        echo -e "\nAre you sure to delete this book:"
        echo -e "$name $date $hour"
        echo -n "y/n? "
        read answer
    
        # if answer is yes, delete data from file
        if [ "$answer" == "y" ] 
                then
                    # Delete the line containing the pattern '$name;$date;$hour' and create/update a file.bak
                    pattern=$(grep -i -w "$name;$date;$hour" $BOOKFILE)
                    sed -i.bak "/${pattern}/ d" $BOOKFILE    
                    printf '\e[1;32mdone\e[0m.\n'
                else
                    # Give the user a message
                    printf '%s ; %s ; %s ; %s \e[1;31mnot deleted\e[0m to %s\n' $name $date $hour $username $BOOKFILE
        fi 
    fi
fi









