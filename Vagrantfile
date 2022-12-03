Vagrant.configure("2") do |config|
    config.vm.define "mysql" do |mysql|
      mysql.vm.box = "ubuntu/focal64"
      mysql.vm.hostname = "mysql"
      mysql.vm.network "private_network", ip: "192.168.56.100"
      mysql.vm.synced_folder ".", "/home/vagrant/zhajili"
      mysql.vm.provision :shell, :path => "db_provision.sh"
  end
    config.vm.define "app" do |app|
     app.vm.box = "ubuntu/focal64"
     app.vm.network "private_network", ip: "192.168.56.200"
     app.vm.hostname = "app"
     app.vm.provision :shell, :path => "application_vm.sh"
    end
  end