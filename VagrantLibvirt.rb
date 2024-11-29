def configure_libvirt(config)
# Define provider settings for Libvirt
config.vm.provider :libvirt do |domain, override|
    #  Use Ubuntu 22.04 cloud image
    config.vm.box = "cloud-image/ubuntu-22.04"

    # Domain specifics
    domain.memory = 6144
    domain.cpus = 3
    domain.disk_bus = 'virtio'
    domain.disk_driver :cache => 'none'
    domain.memtune :type => "hard_limit", :value => 7000000
    domain.default_prefix = 'dev_'
    domain.memballoon_enabled = false
    domain.machine_virtual_size = 30

    case ENV["DISK_SCENARIO"]
      when "scenario1"
        domain.storage :file, :size => '10G', :dev => 'vdb'
      when "scenario2"
        domain.storage :file, :size => '10G', :dev => 'vdb'
        domain.storage :file, :size => '10G', :dev => 'vdc'
      when "scenario3"
        domain.storage :file, :size => '10G', :dev => 'vdb'
        domain.storage :file, :size => '10G', :dev => 'vdc'
        domain.storage :file, :size => '10G', :dev => 'vdd'
      else
        domain.storage :file, :size => '10G', :dev => 'vdb'
    end
  end
end
