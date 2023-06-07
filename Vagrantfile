# -*- mode: ruby -*-
# vi: set ft=ruby :
# To enable zsh, please set ENABLE_ZSH env var to "true" before launching vagrant up 
#   + On windows => $env:ENABLE_ZSH="true"
#   + On Linux  => export ENABLE_ZSH="true"

Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"

  config.vm.define "haproxy" do |haproxy|
  config.vm.box_download_insecure
  config.ssh.insert_key = false
  config.ssh.username = "root"
  config.ssh.password = "vagrant"
    haproxy.vm.network "private_network", ip: "192.168.20.10"
    haproxy.vm.hostname = "haproxy"
    haproxy.vm.provider "virtualbox" do |v|
      v.name = "HAproxy"
      v.memory = 2024
      v.cpus = 1
    end
    haproxy.vm.provision "shell", path: "install_haproxy.sh"
  end

  config.vm.define "server1" do |server1|
  config.vm.box_download_insecure
  config.ssh.insert_key = false
  config.ssh.username = "root"
  config.ssh.password = "vagrant"
    server1.vm.network "private_network", ip: "192.168.20.11"
    server1.vm.hostname = "server1"
    server1.vm.provider "virtualbox" do |v|
      v.name = "Server1"
      v.memory = 2024
      v.cpus = 1
    end
    server1.vm.provision "shell", path: "install_odoo.sh"
  end

  config.vm.define "server2" do |server2|
  config.vm.box_download_insecure
  config.ssh.insert_key = false
  config.ssh.username = "root"
  config.ssh.password = "vagrant"
    server2.vm.network "private_network", ip: "192.168.20.12"
    server2.vm.hostname = "server2"
    server2.vm.provider "virtualbox" do |v|
      v.name = "Server2"
      v.memory = 2024
      v.cpus = 1
    end
    server2.vm.provision "shell", path: "install_odoo.sh"
  end
end