#!/bin/sh /etc/rc.common
# Email notification boot script
 
START=99 
STOP=1


boot(){

	if [[ -e $email/email.txt ]]
	then
		emailboot=$(cat $email/email.txt)
		echo "email address for this user is: $emailboot"
	else
		touch email/email.txt
		echo "there is no saved email for notifications, what email address would you like to use?: "
		read varemail
		echo $varemail > $email/email.txt
		emailboot=$(cat $email/email.txt)
		echo "email address saved"
	fi

	/quick_mount
	echo "boot notification being sent now..."
	sleep 10
	echo "boot notification send confirmed :)"

	python3 /mnt/mmcblk0p3/ubuntu/etc/my_mail/smtprelay.py "Your device is up and running" "$emailboot"
	sleep 10
	while [ true ]
	do
		nohup /etc/nmapscripts/connected_devices.sh newdevicecheck >/dev/null
		sleep 30
	done

}

 
start() { 

		if [[ -e $email/email.txt ]]
		then
			emailstart=$(cat $email/email.txt)
			echo "email address for this user is: $emailstart"
		else
			touch email/email.txt
			echo "there is no saved email for notifications, what email address would you like to use?: "
			read varemail
			echo $varemail > $email/email.txt
			emailstart=$(cat $email/email.txt)
			echo "email address saved"
		fi

		echo "network notification being sent now..."
		sleep 2

		choice=$1
		deviceAm=$2

		if [[ $choice -gt 4 ]]; then
			echo "invalid parameter passed to options field, please investigate"
		fi

		if [[ $choice -eq 1 ]]; then
			python3 /mnt/mmcblk0p3/ubuntu/etc/my_mail/smtprelay.py "Your device is now up and running" "$emailstart"
 	  	fi

 	  	if [[ $choice -eq 2 ]]; then
			python3 /mnt/mmcblk0p3/ubuntu/etc/my_mail/smtprelay.py "You have a suspicious port open!" "$emailstart"
 	  	fi

 	  	if [[ $choice -eq 3 ]]; then
			python3 /mnt/mmcblk0p3/ubuntu/etc/my_mail/smtprelay.py "There appears to be $2 new device(s) connected to your network!" "$emailstart"
 	  	fi

 	  	if [[ $choice -eq 4 ]]; then
			python3 /mnt/mmcblk0p3/ubuntu/etc/my_mail/smtprelay.py "Your internet speed is below average" "$emailstart"
 	  	fi

}
 
stop() {          
        echo "network notification has been sent..."
}
