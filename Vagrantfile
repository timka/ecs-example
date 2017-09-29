# -*- mode: ruby -*-
# vi: set ft=ruby :

os = 'ubuntu/xenial64'


Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # A VM w/ Docker that works on old Macs that don't support Docker natively
  config.vm.define :dev do |vm_config|

    vm_config.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 1
        # Avoid clock skew issue
        vb.customize ["modifyvm", :id, "--paravirtprovider", "none"]

    end

    vm_config.vm.box = os

    vm_config.vm.provision :shell, inline: <<-SHELL
    curl -fsSL get.docker.com | sh -

    apt-get install -y python-pip jq
    su - ubuntu -c 'pip install --user --upgrade awscli'

    curl -o /usr/local/bin/ecs-cli \
      https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
    chmod +x /usr/local/bin/ecs-cli

    su - ubuntu -c 'aws configure set region us-east-1'
    SHELL
  end
end
