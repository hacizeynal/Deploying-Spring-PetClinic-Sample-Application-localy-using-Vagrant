#!/bin/bash
sudo apt update -y
sudo apt list --upgradable # get a list of upgrades
sudo apt upgrade -y
sudo apt-get install debconf-utils -y
sudo apt-get install mysql-server -y
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
sudo sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf

echo "Setting ENV variable for DB password"
echo "export DATABASE_PASS=1234" >> ~/.profile
source ~/.bashrc

echo "Configuring MySQL and importing user.sql"
cd zhajili
sudo mysql -u root -p"$DATABASE_PASS" < user.sql 
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

echo "Restarting MySQL"
sudo service mysql stop
sudo service mysql start
