#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt-get install git
sudo apt-get install maven -y
sudo apt install net-tools
sudo hostname app-vm



export DB_HOST=172.31.18.239 >> ~/.bashrc # ip address for MySQL server
export DB_PORT=3306 >> ~/.bashrc # default port MySQL server
export DB_NAME=petclinic >> ~/.bashrc # database name for MySQL server
export DB_USER=petclinic >> ~/.bashrc # username for MySQL server
export DB_PASS=petclinic >> ~/.bashrc # password for MySQL server
source ~/.bashrc

git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
# ./mvnw package
# java -jar target/*.jar &
