#!/bin/bash

sudo apt update -y
sudo apt list --upgradable # get a list of upgrades
sudo apt upgrade -y
sudo apt upgrade
sudo apt-get install debconf-utils -y
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
sudo apt-get install mysql-server -y
echo "export DATABASE_PASS=1234" >> /home/vagrant/.bashrc
source .bashrc
cd zhajili

# sudo mysql -u root -p"$DATABASE_PASS" -e "UPDATE user SET authentication_string = PASSWORD('$DATABASE_PASS') WHERE user.User = 'root'"
# sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
# sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
# sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='petclinic' OR Db='petclinic\_%'"
# sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database petclinic"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on petclinic.* TO 'petclinic'@'localhost' identified by 'petclinic'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on petclinic.* TO 'petclinic'@'%' identified by 'petclinic'"
sudo mysql -u root -p"$DATABASE_PASS" petclinic < user.sql 
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

echo "Updating mysql configs in /etc/mysql/my.cnf."
sudo sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "Updated mysql bind address in /etc/mysql/my.cnf to 0.0.0.0 to allow external connections."
sudo service mysql stop
sudo service mysql start