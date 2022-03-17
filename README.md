# vagrant-sh

Shell library that helps to manage vagrant machines, environment etc. It currently supports and was tested on the following providers:

- VirtualBox
- Libvirt

It also adds simple wrappers to the following plugins:

- vagrant-scp

## But why?

When it comes to the development process, the vagrant CLI is lovely. But during
my work, I had many problems with Vagrant in CI/CD processes, especially with
different provides, plugins and system versions. Maintaining a bunch of vagrant
shell libraries/scripts became tedious, so I decided to make one lib to make
using vagrant easier.

## Example

```bash
#!/usr/bin/env bash

# Load library
. vagrant-sh/vagrant-lib.sh

VAGRANT_TEMPLATE="./vagrant-sh/templates/1cpu2gb.erb"
BOX_NAME="eurolinux-vagrant/centos-8"
# BOX_VERSION is optional
BOX_VERSION="8.3.2"
set -euo pipefail

# determine provider
preflight_check
vagrant_init_from_template
vagrant_up
vagrant_run_command 'echo I love rock and roll; whoami'
vagrant_run_command_as_root 'echo I love roll and rock; whoami'
vagrant_copy_file_from_machine /etc/os-release
mv os-release vagrant-machine-os-release
vagrant_destroy # destroy vm
vagrant_remove_box # remove box
```

## Nested Virtualization and host-passthrough CPU

It's recommended to use host-passthrough, when using libvirt/kvm, for
Enterprise Linux version 9 like CentOS Stream 9, Red Hat Enterprise Linux 9,
EuroLinux 9 and others RHEL like distros. RHEL 9 raised x86-64
microarchitecture feature levels. It might be impossible to use and upgrade
KVM backed Vagrant box/vm without theses CPU features.

You can read about it:

- [Developers Red Hat Blog Post](https://developers.redhat.com/blog/2021/01/05/building-red-hat-enterprise-linux-9-for-the-x86-64-v2-microarchitecture-level)
- [Phoronix Article](https://www.phoronix.com/scan.php?page=news_item&px=RHEL-9-x86-64-v2-Plans)


For convinience there are templates with propper configuration. Simply use templates
with `-nested.erg` suffix.
```bash
VAGRANT_TEMPLATE="./vagrant-sh/templates/1cpu2gb-rsync-nested.erb"
```

## How to contribute:

> Add issue/idea:

- Bug:
    - Add steps to reproduce
    - If possible include your script

- Idea/feature:
    - Make issue with feature/function that you believe would be beneficial for
      this project.
    - Write it as clean as possible

> Add your code:

- Write your code
- Run shellcheck on vagrant-lib
- I will run the QA process
- Make PR


## QA

QA is currently supported only on not VirtualBox machines.

```
vagrant up
vagrant ssh server_virtualbox -c '/vagrant/tests.bats'
```

#### Some QA problems in Q&A

Q: Why libvirt with libvirt is not supported?
A: There is a collision between VM net and libvirt vagrant nested VM network. I
wasn't able to configure vagrant to use different net/bridge.
