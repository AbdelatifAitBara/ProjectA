Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.box_download_insecure=true 
  config.ssh.insert_key = false
  config.ssh.username = "root"
  config.ssh.password = "vagrant"
  ram_app=2048
  cpu_app=2
  config.vm.define "app2" do |app2|
    app2.vm.network "private_network", ip: "192.168.20.12"
    app2.vm.hostname = "app2"
    app2.vm.provider "virtualbox" do |v|
      v.memory = ram_app
      v.cpus = cpu_app
      v.name = "app2"
    end
    app2.vm.provision :shell do |shell|
      shell.path = "install_odoo.sh"
      shell.args = ["app2", "192.168.20.12"]
    end
  end
  config.vm.define "app1" do |app1|
    app1.vm.network "private_network", ip: "192.168.20.11"
    app1.vm.hostname = "app1"
    app1.vm.provider "virtualbox" do |v|
      v.memory = ram_app
      v.cpus = cpu_app
      v.name = "app1"
      v.customize ['createhd', '--filename', 'app1-disk1.vmdk', '--size', "4124"]
      v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', "1", '--device', "0", '--type', 'hdd', '--medium', 'app1-disk1.vmdk']
      v.customize ['createhd', '--filename', 'app1-disk2.vmdk', '--size', "5124"]
      v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', "1", '--device', "1", '--type', 'hdd', '--medium', 'app1-disk2.vmdk']
    end
    app1.vm.provision :shell do |shell|
      shell.path = "install_odoo.sh"
      shell.args = ["app1", "192.168.20.11"]
    end
  end
  config.vm.define "haproxy" do |haproxy|
      haproxy.vm.network "private_network", ip: "192.168.20.10"
      haproxy.vm.hostname = "haproxy"
      haproxy.vm.provider "virtualbox" do |v|
        v.name = "HAproxy"
        v.memory = ram_app
        v.cpus = cpu_app
      end
      haproxy.vm.provision "shell", path: "install_haproxy.sh"
    end
end