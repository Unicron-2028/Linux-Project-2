#!/bin/bash

echo "==========================================================================="
echo " IAM user detaile : "

read -p "Enter username : " name

if [ -z "$name" ]; then
	echo "Error!!!! Username can't be empty "
	exit 1
fi

aws iam create-user --user-name "$name"

if [ $? -eq 0 ]; then
	echo "IAM user created Successfully with name : "$name""
else
	echo "IAM user creation failed. Please check the CLI permissions"
fi

echo "Aws Policies you can attach : "
echo "1) AdministratorAccess"
echo "2) AmazonAppFlowFullAccess"
echo "3) AmazonAppFlowReadOnlyAccess"

read -p "Enter Choice (1-3) Or Enter your own Policy(e.g., arn:aws:iam::aws:policy/AdministratorAccess): " policy
case $policy in
	1) policy="arn:aws:iam::aws:policy/AdministratorAccess";;
	2) policy="arn:aws:iam::aws:policy/AmazonAppFlowFullAccess";;
	3) policy="arn:aws:iam::aws:policy/AmazonAppFlowReadOnlyAccess";;
esac

aws iam attach-user-policy --user-name "$name" --policy-arn "$policy"

if [ $? -eq 0 ]; then
	echo "Policy '$policy' attached to the user '$name'"
	exit 1
fi




ACCESS_KEYS=$(aws iam create-access-key --user-name "$name")

# Extract Access Key ID and Secret Access Key
id=$(echo "$ACCESS_KEYS" | jq -r '.AccessKey.AccessKeyId')
key=$(echo "$ACCESS_KEYS" | jq -r '.AccessKey.SecretAccessKey')

# Validate if keys were created successfully
if [ -z "$id" ] || [ -z "$key" ]; then
    echo "❌ Failed to create the access keys."
    exit 1
fi

# Print keys to terminal
echo "✅ Access Keys successfully Created!"
echo "Access ID : $id"
echo "Secret Access Key : $key"

echo "============================================================================================="

# Save keys to a file
echo -e "IAM User : $name\nAccess Key ID: $id\nSecret Access Key : $key" > access_keys.txt
echo "🔹 Access keys saved to: $(pwd)/access_keys.txt"
