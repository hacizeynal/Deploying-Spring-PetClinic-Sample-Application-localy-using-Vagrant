#!/bin/bash
sudo hostname db-vm
sudo apt update -y
sudo apt list --upgradable # get a list of upgrades
sudo apt upgrade
sudo apt-get install debconf-utils -y
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
sudo apt-get install mysql-server -y

# sudo ufw allow from 10.8.0.5 to any port 3306

