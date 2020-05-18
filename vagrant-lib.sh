#!/usr/bin/env bash

# Copyleft EuroLinux
# Author: Alex Baranowski (alex@euro-linux.com)
# License: MIT

preflight_check(){
    # This function checks if most important vars inplace
    vars_to_check=( PROVIDER BOX_NAME )
    for i in "${vars_to_check[@]}"; do
        [ -n "$i" ] || {
            echo "Sorry $i must be set"     
            exit 1
        }
    done
}

vagrant_update_box(){
    echo TODO
}

vagrant_init(){
    # Strict mode
    set -euo pipefail
    vagrant init "$BOX_NAME" "--provider=$PROVIDER"
    echo TODO
}

vagrant_init_from_template(){
    echo TODO
}

vagrant_up(){
    echo TODO
}

vagrant_destroy(){
    echo TODO
}

vagrant_remove_box(){
    echo TODO
}

vagrant_run_command(){
    echo TODO
}

vagrant_run_as_root(){
    echo TODO
}

vagrant_copy_files_from_machine(){
    echo TODO
}

vagrant_destroy_all_machines(){
    echo TODO
}

vagrant_purge_libvirt_boxes(){
    echo TODO
}

vagrant_remove_all_boxes(){
    echo TODO
}
