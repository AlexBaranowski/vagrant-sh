# vagrant-sh

```
WORK IN PROGRESS MOST OF THE INFORMATION BELOW ARE NOT TRUE YET
```

Shell library that helps to manage vagrant machines, environment etc. It currently supports and was tested on following provider:
 - VirtualBox
 - Libvirt 

It also add simple wrappers to following plugins:

- vagrant-scp plugin

## But why?

We it comes to developer process, the vagrant cli is wonderfull. It's worki
But during my work at EuroLinux I had a lot of problem with Vagrant in CI/CD
process, especially with different provides, plugins and system versions. Maintaning 
bunch of "vagrant" shell libraries became tedious so I decided to make one lib to make
using vagrant easier.

## How to contribute:

Add your code:

- Add your code
- Run shellcheck (this should be automated [travis CI/CD in the future)
- Run tests.bats
- Make PR

Add issue:

- Please give me steps how to reproduce your problem

Feature Requests:

- Make issiue with feature/function that you belive would be beneficial for this 
  projects and I will consider it :P.

## Does it work?

Because we run mosty EuroLinux (clone of RHEL) in version 7 and 8 this library was only tried on Enterprise Linux systems. But because it's shell based it should be portable.
