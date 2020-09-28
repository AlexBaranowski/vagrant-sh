#!/usr/bin/env bash

# Copyleft EuroLinux
# Author: Alex Baranowski (alex@euro-linux.com)
# License: MIT

preflight_check(){
    # This function checks if most important vars inplace
    [ -n "$PROVIDER" ] || determine_provider
    [ -n "$BOX_NAME" ] || {
            echo "Sorry BOX_NAME must be set"     
            return 1
    }
}

determine_provider(){
    # FIXME in the future more providers
    if hash VirtualBox 2> /dev/null; then
        export PROVIDER=virtualbox
    else
        PROVIDER=libvirt
    fi
    export PROVIDER
}

vagrant_update_box(){
    vagrant box update --box "$BOX_NAME" --provider "$PROVIDER"
}

vagrant_init(){
    set -euo pipefail
    vagrant init "$BOX_NAME"
}

vagrant_init_from_template(){
    [ -n "$VAGRANT_TEMPLATE" ] || { 
        echo "TEMPLATE not defined!"
        return 1
    }
    vagrant init "$BOX_NAME" --template "$VAGRANT_TEMPLATE"
}

vagrant_up(){
    vagrant up --provider="$PROVIDER"
}

vagrant_halt(){
    # forcefully shutdown if there is no success in 120 sec
    timeout 120 vagrant halt || vagrant halt -f 
}

vagrant_destroy(){
    set -euo pipefail
    vagrant destroy -f
    rm -f Vagrantfile
}

vagrant_remove_box(){
    vagrant box remove -f "$BOX_NAME"
}

vagrant_run_command(){
    vagrant ssh -c "$*"
}

vagrant_run_command_as_root(){
    vagrant ssh -c "sudo $*"
}

vagrant_copy_file_from_machine(){
    vagrant scp ":$*" .
}

vagrant_purge_libvirt_boxes(){
    # vagrant-libvirt won't remove boxes images from libvirt default pool, so we have to do this manualy
        # VAGRANTSLASH is string that is used to recognize from app.vagrantup.com
    if [ $PROVIDER == 'libvirt' ]; then
        echo "Libvirt provider require additonal cleaning"
        for i in $(sudo virsh vol-list --pool default | grep "VAGRANTSLASH" | awk '{print $1}'); do
        echo "Removing $i libvirt volume"
        sudo virsh vol-delete --pool default "$i"
        done
    fi
}

vagrant_remove_all_boxes(){
    for i in $( vagrant box list | awk '{print $1}' | sort | uniq ); do
        echo "Purging box $i"
        vagrant box remove -f --all "$i"
    done
    vagrant_purge_libvirt_boxes
}
