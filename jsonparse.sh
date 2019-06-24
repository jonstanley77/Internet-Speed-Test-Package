#!/bin/bash

#check for linux updates and the appropiate packages
sudo apt-get dist-upgrade
sudo apt-get install speedtest-cli
sudo apt-get install bi
sudo apt-get install jq

TEMPFILE=/tmp/$$.tmp
echo 0 > $TEMPFILE

#create a file to store speed test summary
sudo touch summary.txt
sudo chmod 777 summary.txt

#for loop to run the test ten times
(for test in $(seq 1 10); do

(
  (


#create a temporary file to store json data from each test if such a
#file name exists then it will create another file 
name=speedtestdata
if [[ -e $name.save ]] ; then
	i=0
    while [[ -e $name-$i.save ]] ; do
        let i++
    done
    name=$name-$i
fi

#calls speed test program and pipes json output to the speed test file 
sudo speedtest-cli  --server 1776 --json | sudo tee "$name".save >/dev/null
#changes permission on data file so the anyone can read or write to it
sudo chmod 777 "$name".save

#parsing variables from json file with jq program
location=$(jq '.server.name' "$name".save)
download=$(jq '.download' "$name".save)
upload=$(jq '.upload' "$name".save)
time=$(jq '.timestamp' "$name".save)
latency=$(jq '.server.latency' "$name".save)

btoMb=1000000
#echos all results
printf "\nlocation of the server is: $location\n"
echo "your download speed is:"
echo "$download / 1000000" | bc -l
echo "your upload speed is:"
echo "$upload / 1000000" | bc -l
echo "time is: $time"
echo "latency is: $latency" 

#counter to keep track of test run
COUNTER=$[$(cat $TEMPFILE)]

#stores results in the accumalated summary file
echo "location:$COUNTER $location" | sudo tee -a summary.txt >/dev/null
echo "download:$COUNTER $download" | sudo tee -a summary.txt >/dev/null
echo "upload:$COUNTER $upload" | sudo tee -a summary.txt >/dev/null
echo "time:$COUNTER $time" | sudo tee -a summary.txt >/dev/null
echo "latency:$COUNTER $latency" | sudo tee -a summary.txt >/dev/null

) &

PID=$! #simulate a long process

#stores count in tempfile
COUNTER2=$[$(cat $TEMPFILE)]

printf "THIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE \nINTERNET SPEED TEST $COUNTER2 IS RUNNING...\n"
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 2
done

COUNTER=$[$(cat $TEMPFILE) + 1]
echo $COUNTER > $TEMPFILE

printf "\nAlways know your internet speed!\n"
)

sleep 1; done;)
unlink $TEMPFILE

#run table parse for summary file
echo "records of your internet speeds are also saved to a file named "\"SpeedTestTable.txt"\" " 
echo ":)"
sudo touch SpeedTestTable.txt
sudo chmod 777 SpeedTestTable.txt
./SpeedTestTable.sh  | sudo tee SpeedTestTable.txt