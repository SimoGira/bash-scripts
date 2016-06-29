#!/bin/bash

# Il comando Prenotazioni per aula deve mostrare il numero totale di prenotazioni per ciascuna aula,
# ordinato in modo crescente. Un possibile output potrebbe essere il seguente:
# C: 2
# A: 7
# Tessari: 14

if fileIsAvailable $0                        
then
    printf '\n\e[4mNUMBER OF BOOKINGS PER CLASSROOM\e[0m:\n\e[1;36mBookings   Classroom\e[0m\n'
    cut -d \; -f1 "$BOOKFILE" | sort | uniq -ic | sort -n | sed 's/^[ \t]*//' | sed 's/ /          /' | sed 's/^/    /'
fi