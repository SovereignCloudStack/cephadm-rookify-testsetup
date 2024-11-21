# README

This a testing setup using vagrant (currently with the libvirt plugin) to install a small local Ceph and Rook cluster.
The Ceph cluster is deployed with `cephadm`, Rook is deployed with `helm` and running on `k3s`. 

This setup is for testing purposes only, i.e. it is a relatively simple deployment to test `rookify` on. Any wishes to expand the testsetup are welcome.

## OS instances for VMs

The VMs are currently running on the [vagrant-box for the ubuntu 22.04 cloudimage](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-22.04).

The decision for the versions of Ubuntu instances used is based on the following links:

- [supported ceph versions](https://ubuntu.com/ceph/docs/supported-ceph-versions)
- [Ceph and the UCA](https://wiki.ubuntu.com/OpenStack/CloudArchive#Ceph_and_the_UCA)

## Vagrant

The decision to use Vagrant was taken, because it allows for relatively easy "Infrastructure As Code"-setup, for which the hypervisors (the providers) can be changed relatively easy.

### Virtualbox

Vagrant is running on virtualbox per default. The current [Vagrantfile](./Vagrantfile) is not written for this hypervisors but should be relatively easy to adapt to it. See vagrants [documentation](https://developer.hashicorp.com/vagrant/docs/vagrantfile) for more information.

### Libvirt Plugin

That being said, it should be noted that the usage of the libvirt-provider plugin might lead to complications. In order to install the right version of the libvirt-plugin refer to the [documentation here](https://vagrant-libvirt.github.io/vagrant-libvirt/). If solution in the documentation do not work, you might consider using a lower version of vagrant (e.g. as of 21-11-2024 version 2.4.1 is working well).

### Ansible Plugin

For provisioning the vagrant-ansible plugin was used.

## Setup

Checkout the [Makefile](./Makefile) by simply going to the working directory of the repository and running `make` on the console:

```bash
make
```

This will render a list of macros that can be used to help you manage the test-setup. To run the setup with the libvirt provider simply run:

```bash
make setup
```

This will use the livirt-provider to run the testsetup. If you adapted the `Vagrantfile` to use virtualbox or any other provider, be sure the install the needed provider plugins (if neeeded) and then simply run `vagrant up`.

### Ceph version

The ceph version can be specified in [vars.yaml](./provisioning/vars.yaml.dist).

### Ceph services

The Ceph services to be deployed are defined in [ceph-hosts.j2](./provisioning/templates/ceph-hosts.j2).

## Rookify - Testing

**First** you need to get the latest code of Rookify:

```bash
make get-rookify
```

This will download the repository for you.

**Second** Configure Rookify: Please take a look at the [README.md]() in the repository or the [documentation of SCS]().
To get the needed IP's of the VMs run: 

```bash 
make get-config 
```

This will copy `.kube` and `/etc/ceph` to `rookify/.k8s` and `rookify/.ceph` respectively. Please adapt `rookify/.k8s/config` by changing `127.0.0.1` for the master node to the IP of the VM.

**Third**: Install rookify and run it in `dry-run` mode. From within the rookify repository run `make build-local-rookify`, then run it in dry-run by executing `.venv/bin/rookify -d` from within the working directory of the Rookify Repository.
Check if Rookifies configs and check its status by running `.venv/bin/rookify -s`.

**Fourth**: Execute rookify with `.ven/bin/rookify -m` and see if it works! Depending on you hardware this might take some time.

