# Require the AWS provider plugin
require 'vagrant-aws'

# Create and configure the AWS instance(s)
Vagrant.configure('2') do |config|

  # Use dummy AWS box
  config.vm.box = 'aws-dummy'

  # Specify AWS provider configuration
  config.vm.provider 'aws' do |aws, override|
    # Read AWS authentication information from environment variables
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

    # Specify SSH keypair to use
    aws.keypair_name = 'AWS_KEY_PAIR'

    # Specify region, AMI ID, and security group(s)
    aws.region = 'us-east-1'
    aws.ami = 'ami-0149b2da6ceec4bb0'
    aws.security_groups = ['ENDHOSTS-SG']

    # Specify username and private key path
    override.ssh.username = 'ubuntu'
    override.ssh.private_key_path = '~/.ssh/key_pair_zhajili_AWS.pem'
  end
end