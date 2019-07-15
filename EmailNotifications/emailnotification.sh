#!/bin/sh /etc/rc.common
# Email notification boot script

 
START=99 
STOP=1


 
start() {   
		alertChoice="0"
		runningAlert="Your device is now up and running! "

		echo "Boot notification being sent now..."
		sleep 2

		if [[ $alertChoice -eq 0 ]]
		then
			python /email/smtprelay.py "$runningAlert"
		fi
}
 
stop() {          
        echo "Boot notification has been sent..."
}