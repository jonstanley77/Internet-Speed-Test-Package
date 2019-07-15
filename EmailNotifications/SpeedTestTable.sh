#!/bin/bash
#create a speed test table with 5 columns 10 rows

#Create top of the table
echo "                                                  Speed Test Summary table           "
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------"


#Print the nums at top of table and format dashes
echo -n "      |"; printf "%-30s"      "location"      "download"      "upload"        "time"      "latency"       ; echo
echo  "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
itemarray=("location" "download" "upload" "time" "latency")
#for loops to create speed test number
for y in {0..9}
do  
    #Print the side nums and |  
    printf "%s %d | " "test" $y
    #for loop to create x   
    for x in {0..4}
    do 
    #item varibles referenced from the summary file, tab for spacing  
        dataop="${itemarray[x]}"
        datapos="$dataop:$y"
        itemval="$(grep "$datapos" summary.txt|awk '{print $2 $3}')"
        printf "%-30s" $itemval
    done
    #Print
    echo
done
#Print bottom dashes for format
echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------"