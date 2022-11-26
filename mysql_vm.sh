#!/bin/bash
sudo hostname db-vm
sudo apt update -y
sudo apt list --upgradable # get a list of upgrades
sudo apt upgrade -y
sudo apt-get install debconf-utils -y
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
sudo apt-get install mysql-server -y

git clone https://github.com/hacizeynal/Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant.git
cd Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant


export DATABASE_PASS='1234'
sudo mysql -u root -p"$DATABASE_PASS" -e "create database petclinic" > /dev/null 2>&1
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on petclinic.* TO 'petclinic'@'localhost' identified by 'petclinic'" > /dev/null 2>&1
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on petclinic.* TO 'petclinic'@'%' identified by 'petclinic'" > /dev/null 2>&1
sudo mysql -u root -p"$DATABASE_PASS" petclinic < src/main/resources/db/mysql/user.sql > /dev/null 2>&1
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES" > /dev/null 2>&1

echo "Updating mysql configs in /etc/mysql/my.cnf."
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "Updated mysql bind address in /etc/mysql/my.cnf to 0.0.0.0 to allow external connections."
sudo service mysql stop
sudo service mysql start