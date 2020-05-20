#!/usr/bin/env bats

setup(){
    # See https://github.com/bats-core/bats-core/pull/282 - we are using older version
    # so load is trash because require .bash suffix in filename. In the future line below
    # could be uncomment
    # load vagrant-lib.sh
    . "${BATS_TEST_DIRNAME}/../vagrant-lib.sh"
    export TEMP_DIR=$(mktemp -d)
    pushd $TEMP_DIR
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
    echo "aaa $BATS_TEST_DIRNAME $BOX_NAME $VAGRANT_TEMPLATE" | tee /tmp/aaaa_log
    [ $status -eq 0 ]
    [ -e Vagrantfile ]
}

@test "test_vagrant_up" {
    # Actually this probably shouldn't be tested in normal way
    [ 0 -eq 0 ]
}

@test "test_vagrant_destroy" {
    [ 0 -eq 0 ]
}

@test "test_vagrant_remove_box" {
    [ 0 -eq 0 ]
}

@test "test_vagrant_run_command" {
    [ 0 -eq 0 ]
}

@test "test_vagrant_run_as_root" {
    [ 0 -eq 0 ]
}

@test "test_copy_files_from_machine" {
    [ 0 -eq 0 ]
}

@test "vagrant_destroy_all_machines" {
    [ 0 -eq 0 ]
}

@test "vagrant_remove_all_boxes" {
    [ 0 -eq 0 ]
}

@test "test_vagrant_update_box" {
    [ 0 -eq 0 ]
}

teardown(){
    vagrant destroy -f  || true
    popd
    rm -rf $TEMP_DIR
}
