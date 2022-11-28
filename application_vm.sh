#!/bin/bash
# UPDATE SYSTEM PACKAGES
sudo apt update
sudo apt upgrade -y
sudo apt-get install git
sudo apt-get install maven -y
sudo apt install net-tools
sudo hostname app-vm


# SET ENV VARIABLE FOR DB CONNECTION
echo "Set up env variable!"
echo "export DB_PORT=3306" >> .bashrc
echo "export DB_NAME=petclinic" >> .bashrc
echo "export DB_USER=petclinic" >> .bashrc
echo "export DB_PASS=petclinic" >> .bashrc
source .bashrc
sleep 20
# DISCOVER IP ADDRESS OF DB_VM
sudo apt-get install nmap -y
# nmap -sn 172.31.18.0/24 | awk '/Nmap scan/{gsub(/[()]/,"",$NF); print $NF > "nmap_scanned_ips.txt"}'
sudo nmap -sn 172.31.18.0/24
sleep 10
arp -a > arp.txt
grep -v "172.31.18.1" arp.txt >> ip_db_string.txt
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ip_db_string.txt > real_db_vm.txt
DB_HOST=$( nmap_scanned_ips )
echo "export DB_HOST=$DB_HOST" >> .bashrc
source .bashrc


# GIT CLONE CODE ,BUILD AND RUN 

# git clone https://github.com/hacizeynal/Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant.git
# cd Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant

# ./mvnw package
# echo "Starting application!"
# java -jar target/*.jar &
