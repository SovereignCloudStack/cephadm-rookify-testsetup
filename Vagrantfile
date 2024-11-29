# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_COMMAND = ARGV[0]

# Load external provider configuration
require_relative 'VagrantLibvirt'
require_relative 'VagrantVirtualbox'

Vagrant.configure("2") do |config|

  # Set name of the VMs
  config.vm.define :cephadm_master do |master|
    master.vm.hostname = "master"
  end
  config.vm.define :cephadm_worker1 do |worker1|
    worker1.vm.hostname = "worker1"
  end
  config.vm.define :cephadm_worker2 do |worker2|
    worker2.vm.hostname = "worker2"
  end
  config.vm.define :cephadm_worker3 do |worker3|
    worker3.vm.hostname = "worker3"
  end

  # Run Config for Provisioners
  configure_virtualbox(config)
  configure_libvirt(config)
  
  #
  # Run Ansible from the Vagrant Host
  #
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "provisioning/main.yaml"
    ansible.groups = {  
      "master" => ["cephadm_master"],
      "workers" => ["cephadm_worker1", "cephadm_worker2", "cephadm_worker3"],
      "all:vars" => {"user" => "dude"},
    }
  end

  # Set different vagrant ssh user
  # Do not forget to uncomment "VAGRANT_COMMAND = ARGV[0]" at the start of the Vagrantfile!
  # Nice hack, described here: https://github.com/hashicorp/vagrant/issues/1753#issuecomment-53970750
  # if VAGRANT_COMMAND == "ssh"
  #   config.ssh.username = ENV['USER']
  #   config.ssh.private_key_path = ["~/.ssh/id_rsa"]
  # end
end
