#!/bin/bash


echo "======================================================================"
echo " Fill details for Relational Database System "

read -p "Enter Identifier name for database : " identifier
echo " Instance Classes: "
echo "1) db.t3.micro"
echo "2) db.t2.micro"
read -p "Enter Choice for Intance Classes (1-2) : " instance_class
case $instance_class in
	1) instance_class="db.t3.micro";;
	2) instance_class="db.t2.micro";;
	*) echo "Invalid Choice"; exit 1;;
esac

DB_ENGINE="mysql"

echo "Engine for the database is : mysql"

read -p "Enter username : " username
username=${username:-admin}
read -p "Enter password : " pass
pass=${pass:-Gaurav252693}
Storage=20
read -p "Enter Database name : " db_name
region="us-east-1"

echo "Launching RDS free tier instance : $identifier"

aws rds create-db-instance\
	--db-instance-identifier $identifier \
	--db-instance-class $instance_class \
	--engine $DB_ENGINE \
	--master-username $username \
	--master-user-password $pass \
	--allocated-storage $Storage \
	--db-name $db_name \
	--region $region \
	--backup-retention-period 7 \
	--no-publicly-accessible \
	--storage-type gp2 
aws rds wait db-instance-available --db-instance-identifier $identifier --region $region

# Get the RDS endpoint
ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier $identifier \
    --region $region \
    --query "DBInstances[0].Endpoint.Address" \
    --output text)

echo "✅ RDS Instance is now available."

# Print Connection Details
echo "==============================================="
echo "🟢 Database Endpoint: $ENDPOINT"
echo "🟢 Database Username: $username"
echo "🟢 Database Password: $password"
echo "🟢 Database Name    : $db_name"
echo "🟢 MySQL Connection String:"
echo "mysql -h $ENDPOINT -P 3306 -u $username -p$password"
echo "==============================================="


