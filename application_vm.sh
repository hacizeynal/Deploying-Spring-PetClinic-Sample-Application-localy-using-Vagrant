apt-get update
apt-get upgrade -y
apt-get install default-jre -y
sudo apt-get install maven -y
apt-get install git -y 
sudo apt install net-tools
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
sudo sed -i "s/localhost/192.168.56.100:3306/g" src/main/resources/application-mysql.properties
sudo sed -i "s/database=h2/database=mysql/g" src/main/resources/application.properties
sudo bash -c 'echo "spring.profiles.active=mysql" >> src/main/resources/application.properties'
echo "Package the application!"
./mvnw package -Dcheckstyle.skip
echo "Starting application!"
java -jar target/*.jar &
