# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.define "server_libvirt" do |server_libvirt|
    server_libvirt.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook-libvirt.yml"
      ansible.become = true
    end
    server_libvirt.vm.network :private_network,
      :type => "dhcp",
      :libvirt__network_address => '10.20.30.0'
    server_libvirt.vm.box ="eurolinux-vagrant/centos-8"
    server_libvirt.vm.synced_folder ".", "/vagrant", type: "rsync"
    server_libvirt.vm.provider "libvirt" do |lv|
      lv.memory = "2048"
      lv.cpus = 2
    end
    server_libvirt.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end

  config.vm.define "server_virtualbox" do |server_virtualbox|
    server_virtualbox.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook-virtualbox.yml"
      ansible.become = true
    end
    server_virtualbox.vm.box ="eurolinux-vagrant/centos-8"
    server_virtualbox.vm.synced_folder ".", "/vagrant", type: "rsync"
    server_virtualbox.vm.provider "libvirt" do |lv|
      lv.memory = "2048"
      lv.cpus = 2
    end
    server_virtualbox.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end

end
