#!/bin/bash
#might need opkg upgrade coreutils-sort
#script to scan ports of all devices connected to ap and return port status for all
bash /etc/nmapscripts/connected_devices.sh >/dev/null
nmap -oG device_ports_status.grep -iL devicelog.txt >/dev/null

NMAP_FILE=device_ports_status.grep

open_ports() {
	egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
	sed -n -e 's/Ignored.*//p' | \
	awk -F, '{split($0,a," "); printf "Host: %-20s Ports Open: %d\n" , a[1], NF}' \
	| sort -k 5 -g
}

top_ports() {
	egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f4- | \
	sed -n -e 's/Ignored.*//p' | tr ',' '\n' | sed -e 's/^[ \t]*//' | \
	sort -n | uniq -c | sort -k 1 -r | head -n 50
}

port_detail() {
	egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2,4- | \
	sed -n -e 's/Ignored.*//p'  | \
	awk '{print "Host: " $1 " Ports: " NF-1; $1=""; for(i=2; i<=NF; i++) { a=a" "$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/"); printf "%-8s %s/%-7s %s\n" , v[2], v[3], v[1], v[5]}; a="" }'
}

option=$1
case $option
in 
	openports) open_ports ;;
    topports) top_ports ;;
	portdetail) port_detail ;; 
	*) echo "please specify an option"
		exit ;;
esac

