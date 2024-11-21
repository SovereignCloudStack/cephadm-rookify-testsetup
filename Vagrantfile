# -*- mode: ruby -*-
# vi: set ft=ruby :

# VAGRANT_COMMAND = ARGV[0]

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


  #  Use Ubuntu 24.04 cloud image
  config.vm.box = "cloud-image/ubuntu-22.04"
  # Define the provider settings for libvirt
  config.vm.provider :libvirt do |domain|
    domain.memory = 6144
    domain.cpus = 6
    domain.disk_bus = 'virtio'
    domain.default_prefix = 'dev'
    # Increase disk spaces. Also check here: https://n40lab.wordpress.com/2016/07/28/project-atomic-installing-vm-with-vagrant-libvirt-and-get-more-space-for-the-varlibdocker-directory/
    # add sdb storage to the vm (volumes for ceph)
    domain.machine_virtual_size = 30

    case ENV["DISK_SCENARIO"]
    when  "scenario1"
        domain.storage :file, :size => '10G', :dev => 'vdb'
    when  "scenario2"
        domain.storage :file, :size => '10G', :dev => 'vdb'
        domain.storage :file, :size => '10G', :dev => 'vdc'
    when "scenario3"
        domain.storage :file, :size => '10G', :dev => 'vdb'
        domain.storage :file, :size => '10G', :dev => 'vdc'
        domain.storage :file, :size => '10G', :dev => 'vd'
    else
        domain.storage :file, :size => '10G', :dev => 'vdb'
    end
  end

  # Increase disk size (script not needed?)
  # config.vm.provision "shell", inline: <<-SHELL
  #     #dnf install -y cloud-utils-growpart
  #     sudo apt install cloud-guest-utils
  #     growpart /dev/vda 1
  #     resize2fs /dev/vda1
  #   SHELL

  #
  # Run Ansible from the Vagrant Host
  #
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "provisioning/playbook.yml"
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
