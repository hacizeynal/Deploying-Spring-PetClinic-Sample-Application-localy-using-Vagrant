#!/bin/bash
sudo hostname EC2
sudo apt update
sudo apt upgrade -y
sudo apt-get install git
sudo apt-get install maven -y

git clone git@github.com:hacizeynal/Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant.git
cd Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant/spring-petclinic
./mvnw package
java -jar target/*.jar

