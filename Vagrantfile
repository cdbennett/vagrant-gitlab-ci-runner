# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/stretch64"

  # Install Ansible as the first step
  config.vm.provision "shell", path: "provision.sh", env: {
      "GITLAB_URL" => ENV["GITLAB_URL"],
      "GITLAB_RUNNER_TOKEN" => ENV["GITLAB_RUNNER_TOKEN"],
      "GITLAB_RUNNER_NAME" => ENV["GITLAB_RUNNER_NAME"],
    }

  # Fix VirtualBox networking failure due to NAT DNS.
  # https://serverfault.com/questions/453185/vagrant-virtualbox-dns-10-0-2-3-not-working
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end
