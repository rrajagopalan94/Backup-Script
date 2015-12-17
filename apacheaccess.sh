#!/usr/bin/bash

set -o errexit

function help_message() {
    cat << EOF
This script will help you analyze Apache log files. Here are the arguments you can use
 -t - Provides the Top 10 requested pages and the number of requests made for each
 -s - Provides the percentage of successful requests (anything in the 200s and 300s range)
 -u - Provides the percentage of unsuccessful requests (anything that is not in the 200s or 300s range)
 -p - Provides the top 10 unsuccessful page requests
 -i - Provides the top 10 IPs making the most requests, displaying the IP address and number of requests made

e.g.
If you would like to see all reports:
# ./assignment.sh -tsupi

If you would like to multiple, but not all reports:
# ./assignment.sh -sup

If you would only like to see one report:
# ./assignment.sh -i
EOF
}

if [ $# -eq 0 ];
then
    help_message
    exit 0
fi

while getopts ":tsupi" opt

 do

   case $opt in
    t)
    echo -e "    Top 10 requested pages \n    ======================"
    awk -F\" '{print $2}'  access_log | sort | uniq -c | sort -nr | head -10
    echo

    ;;
    s)
    #Percentage of successful requests (anything in the 200s and 300s range)
    number_of_requests=$(wc -l < access_log)
    for a in $(awk '{print $9}' access_log | grep "[2|3][0-9][0-9]" | sort | uniq -c | sort -rn | awk '{print $1}')

        do echo -e "Successful requests in % \n=======================" ; echo $a/$number_of_requests*100  | bc -l | cut -c1-4
    done
    echo

    ;;
    u)
    #Percentage of unsuccessful requests (anything that is not in the 200s or 300s range)
    number_of_requests=$(wc -l < access_log)
    for b in $(awk '{print $9}' access_log | grep "[^23][0-9][0-9]" | sort | uniq -c | sort -rn | awk '{print $1}')

        do echo -e "Unsuccessful requests in % \n=========================" ; echo $b/$number_of_requests*100  | bc -l | cut -c1-4
    done
    echo

    ;;
    p)
    echo -e "    Top 10 unsuccessful page requests \n    ================================="
    awk '($9 ~ /404/)'  access_log | awk '{print $9,$7}' | sort |uniq -c | sort -nr | head -10
    echo

    ;;
    i)
    echo -e "    Top 10 IPs making the most requests \n    ================================="
    awk '{print $1}' access_log | sort | uniq -c | sort -nr | head -10

    ;;
    *)
    help_message
    ;;
    esac

 done
exit 0
