# Require the AWS provider plugin
require 'vagrant-aws'

# Create and configure the AWS instance(s)
Vagrant.configure('2') do |config|

  # Use dummy AWS box
  config.vm.box = 'aws-dummy'

  # Specify AWS provider configuration
  config.vm.provider 'aws' do |aws, override|
    override.vm.synced_folder ".", "/vagrant", disabled: true
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = 'AWS_KEY_PAIR'
    aws.ami = 'ami-0149b2da6ceec4bb0'
    aws.region = 'us-east-1'
    aws.instance_type = "t2.micro"    
    aws.security_groups = ['sg-0afee790418d871a5']
    aws.subnet_id = "subnet-0eac26c67bd7e38da"
    aws.associate_public_ip = true
    override.ssh.username = 'ubuntu'
    override.ssh.private_key_path = '~/.ssh/AWS_KEY_PAIR.pem'
  end
  config.vm.define "app" do |app|
    app.vm.hostname = "app"
    app.vm.provision :shell, :path => "application_vm.sh"
    app.vm.network "forwarded_port", guest: 80, host: 8080
  end
  config.vm.define "db" do |db|
    db.vm.hostname ="db"
    db.vm.provision :shell, :path => "mysql.sh"
  end
  # config.vm.define "db2" do |db2|
  #   db2.vm.hostname ="db2"
  #   db2.vm.provision :shell, :path => "nginx.sh"
  # end
end

