export VAGRANT_TEMPLATE={configs/Vagrantfile.erb}

clean_up(){
    set +euo pipefail # some can be destroyed
    vagrant destroy -f
    rm Vagrantfile
    vagrant box remove -f "$vagrant_box"
    if [ $PROVIDER == 'libvirt' ]; then
        echo "Libvirt provider require additonal cleaning"
        sudo virsh vol-list --pool default | grep "eurolinux-vagrant" | awk '{print $1}' | sudo xargs virsh vol-delete --pool default
    fi
}

determine_provider(){
    # TODO more providers

    if hash VirtualBox 2> /dev/null; then
        echo "Found VirtualBox set Provider to VirtualBox"
        export PROVIDER=virtualbox
    else
        echo "Provider not found set libvirt!"
        export PROVIDER=libvirt
    fi
}
