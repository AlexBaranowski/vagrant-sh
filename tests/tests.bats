#!/usr/bin/env bats

setup(){
    # See https://github.com/bats-core/bats-core/pull/282 - we are using older version
    # so load is trash because require .bash suffix in filename. In the future line below
    # could be uncomment
    # load vagrant-lib.sh
    . "${BATS_TEST_DIRNAME}/../vagrant-lib.sh"
    export TEMP_DIR=$(mktemp -d)
    pushd $TEMP_DIR
    # This is fix for problem with exported variables
    if hash VirtualBox 2> /dev/null; then
        echo 'PROVIDER=virtualbox' > provider_config.sh
    else
        echo 'PROVIDER=libvirt' > provider_config.sh 
    fi
    . provider_config.sh
}

# CAUTION THIS TESTS MUST BE RUN BEFORE LOADING TEST VARS
@test "test_preflight_check_fail" {
    run preflight_check
    [ "$status" -eq 1 ]
    [ "${lines[0]}" == "Sorry BOX_NAME must be set" ]
}

@test "test_preflight_check_ok" {
# HERE TODO Vagrant::Util::TemplateRenderer::BOX_NAME like it's not defined - check in other projects
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ "$status" -eq 0 ]
}

@test "vagrant_init_without_boxname" {
    run vagrant_init 
    [ $status -eq 1 ]
    [ ! -e Vagrantfile ]
}


@test "test_vagrant_init" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
}

@test "test_vagrant_init_from_template_without_vars" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run vagrant_init_from_template
    [ $status -eq 1 ]
    [ "${lines[0]}" == "TEMPLATE not defined!" ]
    [ ! -e Vagrantfile ]
}
@test "test_vagrant_init_from_template" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    . "${BATS_TEST_DIRNAME}/test_vars_template"
    run vagrant_init_from_template
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    # Some regex to check if it's OK
    run grep 'config.vm.box.*=.*eurolinux-vagrant/centos-8.*' Vagrantfile
    [ $status -eq 0 ]
    run grep 'vb.memory.*=.*"1024"' Vagrantfile
    [ $status -eq 0 ]
}

@test "test_vagrant_up" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    vagrant_up
    [ $status -eq 0 ]
    run vagrant global-status
    [ $status -eq 0 ] # it doesn't matter if there is working VM it's nearly always 0
    echo $output | grep $PROVIDER -q # We use provider to determine if there is working machine

}

@test "test_vagrant_destroy" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    vagrant_up
    [ $status -eq 0 ]
    run vagrant global-status
    [ $status -eq 0 ] # it doesn't matter if there is working VM it's nearly always 0
    echo $output | grep $PROVIDER -q # use provider to determine if there is working machine
    run vagrant_destroy 
    echo $output | grep $PROVIDER -v 
}

@test "test_vagrant_remove_box" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    # Actually this probably shouldn't be tested in normal way
    echo "$TEMP_DIR $PROVIDER" | tee /tmp/aaaa_log
    vagrant_up
    [ $status -eq 0 ]
    run vagrant global-status
    [ $status -eq 0 ] # it doesn't matter if there is working VM it's nearly always 0
    echo $output | grep $PROVIDER -q # use provider to determine if there is working machine
    run vagrant_destroy 
    [ ! -e Vagrantfile ]
    echo $output | grep $PROVIDER -v 
    run vagrant box list
    [ $status -eq 0 ]
    line_num=$(echo $output | wc -l)
    [ 1 -eq "$line_num" ]
    [ "$output" != 'There are no installed boxes! Use `vagrant box add` to add some.' ]
    
    run vagrant_remove_box
    [ $status -eq 0 ]
    run vagrant box list
    [ $status -eq 0 ]
    line_num=$(echo $output | wc -l)
    [ 1 -eq "$line_num" ]
    echo $output | tee /tmp/aaaaaa.log # FIXME remove
    [ "$output" = 'There are no installed boxes! Use `vagrant box add` to add some.' ]
}

@test "test_vagrant_run_command" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    run vagrant_up
    [ $status -eq 0 ]
    run vagrant_run_command 'whoami' 
    [ $status -eq 0 ]
    echo "$output" | grep '^vagrant'
}

@test "test_vagrant_run_command_as_root" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    run vagrant_up
    [ $status -eq 0 ]
    run vagrant_run_command_as_root 'whoami' 
    [ $status -eq 0 ]
    echo "$output" | grep '^root'
}

@test "test_copy_files_from_machine" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    run vagrant_up
    [ $status -eq 0 ]
    run vagrant_copy_file_from_machine /etc/os-release
    [ $status -eq 0 ]
    grep -i 'centos' ./os-release
}

@test "test_copy_files_to_machine" {
    . "${BATS_TEST_DIRNAME}/test_vars"
    run preflight_check
    [ $status -eq 0 ]
    run vagrant_init 
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
    run vagrant_up
    [ $status -eq 0 ]
    run vagrant_copy_to_machine /etc/os-release /etc/redhat-release
    [ $status -eq 0 ]
     
}

@test "vagrant_remove_all_boxes" {
    run vagrant_remove_all_boxes
    . "${BATS_TEST_DIRNAME}/test_vars"
    box_el="eurolinux-vagrant/eurolinux-7"
    box_cl="eurolinux-vagrant/centos-7"
    # Add 4 boxes 3 with same name&&provider and different
    run vagrant box add --provider "$PROVIDER" "$box_el" --box-version 7.7.1
    run vagrant box add --provider "$PROVIDER" "$box_el" --box-version 7.7.2
    # 7.7.3 wasn't published
    run vagrant box add --provider "$PROVIDER" "$box_el" --box-version 7.7.4
    # 7.7.3 has only libvirt
    run vagrant box add --provider "$PROVIDER" "$box_cl" --box-version 7.7.7
    run vagrant box list
    [ $status -eq 0 ]
    echo $output | grep $PROVIDER | grep -q '7.7.1'
    echo $output | grep $PROVIDER | grep -q '7.7.2'
    echo $output | grep $PROVIDER | grep -q '7.7.4'
    echo $output | grep $PROVIDER | grep -q '7.7.7'
    run vagrant_remove_all_boxes
    [ $status -eq 0 ]
    run vagrant box list
    line_num=$(echo $output | wc -l)
    [ 1 -eq "$line_num" ]
    [ "$output" = 'There are no installed boxes! Use `vagrant box add` to add some.' ]
}

@test "test_vagrant_update_box" {
    run vagrant_remove_all_boxes
    . "${BATS_TEST_DIRNAME}/test_vars"
    box_centos_8="eurolinux-vagrant/centos-8"
    run vagrant box add --provider "$PROVIDER" "$box_centos_8" --box-version 8.1.1
    run vagrant box list
    line_num=$(echo $output | wc -l)
    [ 1 -eq "$line_num" ]
    echo $output | grep '8.1.1' -q
    vagrant_update_box
    echo $output | grep '8.1.1' -q
    # This tests don't check if box is really updated because the version will change
}

teardown(){
    vagrant destroy -f  || true
    popd
    rm -rf $TEMP_DIR
}
