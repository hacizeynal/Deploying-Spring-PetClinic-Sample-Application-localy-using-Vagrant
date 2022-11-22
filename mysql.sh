#!/bin/bash
sudo hostname db-vm
sudo apt update -y
sudo apt list --upgradable # get a list of upgrades
sudo apt upgrade
sudo apt install mysql-server -y
# sudo mysql_secure_installation
