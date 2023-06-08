# -*- mode: ruby -*-
# vi: set ft=ruby :
# To enable zsh, please set ENABLE_ZSH env var to "true" before launching vagrant up 
#   + On windows => $env:ENABLE_ZSH="true"
#   + On Linux  => export ENABLE_ZSH="true"

Vagrant.configure("2") do |config|
    apps=2..1
    ram_app=2048
    cpu_app=2
    (apps.first).downto(apps.last).each do |i|
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
        app.vm.provision :shell do |shell|
          shell.path = "install_odoo.sh"
          shell.args = ["app#{i}", "192.168.20.1#{i}"]
        end
      end
    end
  config.vm.define "haproxy" do |haproxy|
  config.vm.box_download_insecure
  config.ssh.insert_key = false
  config.ssh.username = "root"
  config.ssh.password = "vagrant"
    haproxy.vm.network "private_network", ip: "192.168.20.10"
    haproxy.vm.hostname = "haproxy"
    haproxy.vm.provider "virtualbox" do |v|
      v.name = "HAproxy"
      v.memory = 2048
      v.cpus = 1
    end
    haproxy.vm.provision "shell", path: "install_haproxy.sh"
  end
end