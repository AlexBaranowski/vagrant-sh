# vagrant-sh

```
WORK IN PROGRESS MOST OF THE INFORMATION BELOW IS NOT TRUE YET
```

Shell library that helps to manage vagrant machines, environment etc. It
currently supports and was tested on the following provider:

- VirtualBox
- Libvirt 

It also adds simple wrappers to the following plugins:

- vagrant-scp plugin

## But why?

When it comes to the development process, the vagrant CLI is wonderful. But
during my work, I had many problems with Vagrant in CI/CD processes, especially
with different provides, plugins and system versions. Maintaining a bunch of
vagrant shell libraries/scripts became tedious, so I decided to make one lib to
make using vagrant easier.

## How to contribute:

Add your code:

- Write your code
- Run shellcheck (this should be automated [travis CI/CD in the future)
- Run "vagrant up". Provisioners should test your code [see QA](##QA)
- Make PR

Add issue:

- Please give me steps on how to reproduce your problem

Feature Requests:

- Make issue with feature/function that you believe would be beneficial for
  this project.


## QA

QA is run on 1 VirtualBox machine. I wasn't able to setup vagrant so it uses
different virsh net just for one machine :(. There is collision between VM net and
libvirt vagrant nested VM net.

```
vagrant up
vagrant ssh server_virtualbox -c '/vagrant/tests.bats'
```

