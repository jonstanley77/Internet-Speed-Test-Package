#!/bin/bash
#script to pull device ips connected to wlan0 and the times they have been up
rm devicelog.txt
if [[ -e $devicelog.txt ]] ; then
	cp /dev/null devicelog.txt
else
	touch devicelog.txt
fi

echo "ip address(es) of current connected devices: "

active_stations=`iw wlan0 station dump | grep 'Station' | awk '{print $2}'`
active_stations_array=($active_stations)

for aS in $(cat /proc/net/arp | grep -v IP | awk '{print $4}')
do
	for station in ${active_stations_array[@]}
	do
		if [[ "$station" == "$aS" ]]; then
			cat /proc/net/arp | grep "$station" | awk '{print $1}' | tee -a devicelog.txt
		fi
        done
done

device_times=`iw wlan0 station dump | grep 'connected' | awk '{print $3}'`
device_times_array=($device_times)

i=1
for a in ${device_times_array[@]};
do
    echo "device $i has been connected for :  "
    T=$a
  	D=$((T/60/60/24))
  	H=$((T/60/60%24))
  	M=$((T/60%60))
  	S=$((T%60))
  	(( $D > 0 )) && printf '%d day(s) ' $D
  	(( $H > 0 )) && printf '%d hour(s) ' $H
  	(( $M > 0 )) && printf '%d minute(s) ' $M
    (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
 	 printf '%d seconds\n' $S
 	 i=$((i+1))
done

