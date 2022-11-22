#!/bin/bash
sudo hostname EC2
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
sudo apt-get install git
sudo apt-get install maven

git clone git@github.com:spring-projects/spring-petclinic.git
cd spring-petclinic
./mvnw package
java -jar target/*.jar

