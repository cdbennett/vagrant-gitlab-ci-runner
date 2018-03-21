# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/stretch64"

  # Disable the default synced folder since it will contain the .vdi
  # file for the data disk, and we don't want to sync that!
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Sync the 'guest' directory.
  # (No files to sync yet, not added.)
  #config.vm.synced_folder "guest", "/vagrant", create: true

  # In order to support Docker build jobs that need gigabytes of space
  # such as Buildroot, add another, larger disk and mount it under
  # /data and link /var/lib/docker to it.
  # The debian/stretch64 image has a disk capacity of only about 5 GB.
  projectdir = File.dirname(File.expand_path(__FILE__))
  datadisk = File.join(projectdir, "data.vdi")
  if ARGV[0] == "up" && !File.exist?(datadisk)
      config.vm.provider :virtualbox do |vb|
          vb.customize [
              'createhd',
              '--filename', datadisk,
              '--format', 'VDI',
              '--size', 100 * 1024  # 100 GiB
          ]
          vb.customize [
              'storageattach', :id,
              '--storagectl', 'SATA Controller',
              '--port', 1, '--device', 0,
              '--type', 'hdd', '--medium',
              datadisk
          ]
      end

      # Use a provisioning script to format and mount the disk.
      config.vm.provision "shell", path: "add-disk.sh"

      # Note: when 'vagrant destroy' is invoked, Vagrant will
      # delete the datadisk.
  end

  config.vm.provision "shell", path: "provision.sh", env: {
      "GITLAB_URL" => ENV["GITLAB_URL"],
      "GITLAB_RUNNER_TOKEN" => ENV["GITLAB_RUNNER_TOKEN"],
      "GITLAB_RUNNER_NAME" => ENV["GITLAB_RUNNER_NAME"],
    }

  config.vm.provider :virtualbox do |vb|
    # Add more RAM.  The default is only 500 MB.
    vb.memory = "1600"

    # Fix VirtualBox networking failure due to NAT DNS.
    # https://serverfault.com/questions/453185/vagrant-virtualbox-dns-10-0-2-3-not-working
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end
