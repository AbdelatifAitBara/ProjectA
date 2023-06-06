# -*- mode: ruby -*-
# vi: set ft=ruby :
# To enable zsh, please set ENABLE_ZSH env var to "true" before launching vagrant up 
#   + On windows => $env:ENABLE_ZSH="true"
#   + On Linux  => export ENABLE_ZSH="true"

Vagrant.configure("2") do |config|
  config.vm.define "myhaproxy" do |myhaproxy|
  config.vm.box_download_insecure
  config.ssh.insert_key = false
  config.ssh.username = "root"
  config.ssh.password = "vagrant"
    myhaproxy.vm.box = "geerlingguy/centos7"
    myhaproxy.vm.network :private_network, ip: "192.168.20.10"
    myhaproxy.vm.hostname = "myhaproxy"
    myhaproxy.vm.provider "virtualbox" do |v|
      v.name = "myhaproxy"
      v.memory = 2048
      v.cpus = 1
    end
    myhaproxy.vm.provision :shell do |shell|
      shell.path = "install-odoo.sh"
      shell.args = ["master", "192.168.20.10"]
    end
  end

  apps=2
  ram_app=2048
  cpu_app=2
  (1..apps).each do |i|
    config.vm.define "app#{i}" do |app|
    config.vm.box_download_insecure=true 
    config.ssh.insert_key = false
    config.ssh.username = "root"
    config.ssh.password = "vagrant"
      app.vm.box = "geerlingguy/centos7"
      app.vm.network :private_network, ip: "192.168.20.1#{i}"
      app.vm.hostname = "app#{i}"
      app.vm.provider "virtualbox" do |v|
        v.name = "app#{i}"
        v.memory = ram_app
        v.cpus = cpu_app
      end
    #app.vm.provision :shell do |shell|
      #shell.path = "install_pg.sh"
      #shell.args = ["master", "192.168.20.11"]
    #end
    end
  end
end
