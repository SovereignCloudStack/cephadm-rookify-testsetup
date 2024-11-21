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

That being said, it should be noted that the usage of the libvirt-provider plugin might lead to complications. In order to install the right version of the libvirt-plugin refer to the [documentation here](). 

For provisioning the vagrant-ansible plugin was used.

## Setup

Checkout the `Makefile` by simply going to the working directory of the repository and running `make` on the console.

