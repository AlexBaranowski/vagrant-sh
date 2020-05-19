#!/usr/bin/env bats

setup(){
    # See https://github.com/bats-core/bats-core/pull/282 - we are using older version
    # so load is trash because require .bash suffix in filename. In the future line below
    # could be uncomment
    # load vagrant-lib.sh
    . ${BATS_TEST_DIRNAME}/aaa.sh
}

@test "test_preflight_check" {
    [ 0 -eq 0 ]
}

@test "test_vagrant_update_box" {
    [ 0 -eq 1 ]
}

@test "test_vagrant_init" {
    [ 0 -eq 1 ]
}

@test "test_vagrant_init_from_template" {
    [ 0 -eq 1 ]
}

@test "test_vagrant_up" {
    # Actually this probably shouldn't be tested in normal way
    [ 0 -eq 1 ]
}

@test "test_vagrant_destroy" {
    [ 0 -eq 1 ]
}

@test "test_vagrant_remove_box" {
    [ 0 -eq 1 ]
}

@test "test_vagrant_run_command" {
    [ 0 -eq 1 ]
}

@test "test_vagrant_run_as_root" {
    [ 0 -eq 1 ]
}

@test "test_copy_files_from_machine" {
    [ 0 -eq 1 ]
}

@test "vagrant_destroy_all_machines" {
    [ 0 -eq 1 ]
}

@test "vagrant_destroy_all_machines" {
    [ 0 -eq 1 ]
}
@test "vagrant_remove_all_boxes" {
    [ 0 -eq 1 ]
}
