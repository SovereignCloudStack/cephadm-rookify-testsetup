def configure_virtualbox(config)
  # Define provider settings for VirtualBox
  config.vm.provider :virtualbox do |vb, override|
      #  Use Ubuntu 22.04 cloud image
      override.vm.box = "ubuntu/jammy64"
      override.vm.box_version = "20241002.0.0"

      # Set disk usage
      override.vm.disk :disk, size: "10GB", name: "vdb"
      case ENV["DISK_SCENARIO"]
      when "scenario2"
        override.vm.disk :disk, size: "10GB", name: "vdc"
      when "scenario3"
        override.vm.disk :disk, size: "10GB", name: "vdc"
        override.vm.disk :disk, size: "10GB", name: "vdd"
      end

      # Set other hardware settings like memory and cpus
      vb.memory = 6144
      vb.cpus = 3
    end
  end
  