#!/bin/bash

echo "==== Launching EC2 instance ===="

echo "==== Key Pair Creation begins ===="

read -p "Enter Key pair name : " key

read -p "Enter download path (or press enter for current directory) : " path
path=${path:-$(pwd)} 
aws ec2 create-key-pair --key-name "$key" \
       --query 'KeyMaterial' --output text > "${path}/${key}.pem"

if [ $? -eq 0 ]; then
	echo "Key Pair named '$key' created successfully"
	echo "Path key Downloaded is : ${path}/${key}.pem"

	chmod 400 "${path}/${key}.pem"
else
	echo "Failed to create the Key-pair"
fi

echo "========================================================================="

read -p "Enter Instance Name : " Instance_Name
read -p " Enter no. of instances : " instance_count
instance_count=${instance_count:-1}
echo "Choose an AMI to launch:"
echo "1) Amazon Linux 2023 AMI - ami-08b5b3a93ed654d19"
echo "2) Ubuntu Server 24.04   - ami-084568db4383264d4"
echo "3) Windows Server 2025   - ami-02e3d076cbd5c28fa"
echo "4) Red Hat Enterprise Linux 9 - ami-0c15e602d3d6c6c4a"
read -p "Enter Choice (1-4) :" ami_choice

case $ami_choice in 
	1) ami_id="ami-08b5b3a93ed654d19";;
	2) ami_id="ami-084568db4383264d4";;
	3) ami_id="ami-02e3d076cbd5c28fa";;
	4) ami_id="ami-0c15e602d3d6c6c4a";;
	*) echo "Invalid Choice"; exit 1;;
esac

echo "Ami Id selected : $ami_id"

read -p "Enter the instance type (default t2.micro):" instance_type
instance_type=${instance_type:-t2.micro}

echo "====================================================================================="
aws ec2 run-instances \
	--image-id "$ami_id"\
	--count "$instance_count"\
	--instance-type "$instance_type"\
	--key-name "$key"\
	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$Instance_Name}]"
echo "===================================================================================="


echo "EC2 instance launching with AMI $ami_id"


