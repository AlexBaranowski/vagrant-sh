#!/usr/bin/env bash
FUNCBASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

prep_vdir() {
    echo "Preparing $VDIR/vagrant directory"
    mkdir -p $VDIR
    echo "VDIR: $VDIR"
    cp -va $FUNCBASE/vagrant/* $VDIR/
    if [ -d $BASE/vagrant/ ];then
        cp -va $BASE/vagrant/* $VDIR/
    fi
}

copy_to_vdir() {
    if [ -d $1 ];then
        DIR=$( basename $1 )
        echo "Copying $1 to $VDIR/vagrant/$DIR"
        mkdir $VDIR/$DIR
        cp -a $1/* $VDIR/$DIR
    else
        cp $1 $VDIR/
    fi
}

clean_vdir() {
    echo "Cleaning up VDIR: ${VDIR}"
    if [ -d $VDIR ];then
        if [ "${VAGRANT_KEEP:-n}" = "y" ];then
            echo "Warning - VAGRANT_KEEP enabled, will not remove $VDIR - just halting vm"
            cd $VDIR/ && vagrant halt -f;cd
        else
            cd $VDIR/ && vagrant destroy -f;cd;rm -fr $VDIR
        fi
    fi
}


run_vagrant() {
    echo "Preparing Vagrantfile in $VDIR"
    sed -e "s^@@VAGRANT_BOX_NAME@@^$VAGRANT_BOX_NAME^" \
	$VDIR/Vagrantfile.template > $VDIR/Vagrantfile

    cd $VDIR/
    vagrant destroy -f || true
    vagrant box update
    vagrant up --provider=libvirt
    return $?
}


vagrant_cmd() {
    cd $VDIR/;vagrant ssh -c "$1"
    return $?
}
