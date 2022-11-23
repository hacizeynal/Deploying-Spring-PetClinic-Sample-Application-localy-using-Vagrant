#!/bin/bash
sudo hostname app-vm
sudo apt update
sudo apt upgrade -y
sudo apt-get install git
sudo apt-get install maven -y

export DB_HOST=172.31.18.160
export DB_PORT=3306
export DB_NAME=petclinic
export DB_USER=petclinic
export DB_PASS=petclinic

git clone https://github.com/hacizeynal/Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant.git
cd Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant/spring-petclinic
./mvnw package
java -jar target/*.jar

