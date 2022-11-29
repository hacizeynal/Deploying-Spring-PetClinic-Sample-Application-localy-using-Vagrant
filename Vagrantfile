Vagrant.configure("2") do |config|
    config.vm.define "mysql" do |mysql|
      mysql.vm.box = "ubuntu/focal64"
      mysql.vm.hostname = "mysql"
      mysql.vm.network "private_network", ip: "192.168.56.100"
      mysql.vm.synced_folder ".", "/home/vagrant/zhajili"
      mysql.vm.provision "shell", inline: <<-SHELL
       apt-get update
       apt-get install mysql-server -y
       sudo sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
       sudo service mysql restart
       cd zhajili
       sudo mysql < user.sql
     SHELL
  end
  
    config.vm.define "app" do |app|
     app.vm.box = "ubuntu/focal64"
     app.vm.network "private_network", ip: "192.168.56.200"
     app.vm.hostname = "app"
     app.vm.provision "shell", inline: <<-SHELL
       apt-get update
       apt-get upgrade -y
       apt-get install default-jre -y
       apt-get install maven -y
       apt-get install git -y 
       sudo apt install net-tools
       git clone https://github.com/hacizeynal/Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant.git
       cd Deploying-Spring-PetClinic-Sample-Application-localy-using-Vagrant
       sudo sed -i "s/localhost/192.168.56.100:3306/g" src/main/resources/application-mysql.properties
       mvn spring-boot:run -Dspring-boot.run.profiles=mysql
       echo "Starting application!"
       java -jar target/*.jar &
     SHELL
    end
  end
