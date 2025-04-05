#!/bin/bash

echo "==== Launching The Volume ===="

echo "Availability Zones are : "
echo "1) us-east-1a"
echo "2) us-east-1b"
echo "3) us-east-1c"
read -p "Enter Availability Zone (1-3) (default : us-east-1a): " zone

case $zone in
	1) us-east-1a;;
	2) us-east-1b;;
	3) us-east-1c;;
esac
zone=${zone:-us-east-1a}
echo "Availability zone selected : $zone"

read -p " Enter volume size in GB (1-100): " volume_size

echo "Volume types are : "
echo "1) General Purpose SSD(gp3)"
echo "2) General Purpose SSD(gp2)"
read -p "Enter volume type (1-2) (default : gp2) : " volume_type

case $volume_type in
	1) volume_type="gp3";;
	2) volume_type="gp2";;
esac
volume_type=${volume_type:-gp2}

echo "Creating the Volume"

aws ec2 create-volume \
	--availability-zone "$zone"\
	--size "$volume_size"\
	--volume-type "$volume_type"

