apt-get update
apt-get install mysql-server -y
sudo sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
cd zhajili
sudo mysql < user.sql