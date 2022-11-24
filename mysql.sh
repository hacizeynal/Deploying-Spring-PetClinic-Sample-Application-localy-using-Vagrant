#!/bin/bash
sudo hostname db-vm
sudo apt update -y
sudo apt list --upgradable # get a list of upgrades
sudo apt upgrade
sudo apt install mysql-server -y
sudo apt-get install curl -y
sudo apt-get install gnupg
sudo apt-get install ca-certificates
sudo apt-get install lsb-release


