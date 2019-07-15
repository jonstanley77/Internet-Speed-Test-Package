#!/bin/bash
#script to scan ports of all devices connected to ap and return port status for all
# ./connected_devices.sh >/dev/null
# nmap -oG device_ports_status.txt -iL devicelog.txt 

cat device_ports_status.txt | grep 'open' | awk '{print $3}' \
	