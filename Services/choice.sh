#!/bin/bash

while true; do
	echo " ================================ "
	echo " Welcome To The Console "
	echo " ================================ "
	echo " AWS Service Menu "
	echo " ================================ "
	echo " 1. EC2 Management "
	echo " 2. Volume Management "
	echo " 3. IAM user Management "
	echo " 4. Database Management "
	echo " 5. Exit "
	read -p " Choose an option [1-4] :  " choice

	case $choice in
		1)
			./ec2-launch.sh
			;;
		2)
			./Volume.sh
			;;
		3)
			./IAM.sh
			;;
		4)
			./Database.sh
			;;
		5)
			echo " Exiting.... "
			break
			;;
		*)
			echo " Invalid Option!! Please try again. "
			;;
	esac
done
	


