# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

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
