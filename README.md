# README

This a testing setup using Vagrant (with support for hypervisors Libvirt and Virtualbox) to install a small local Ceph and Rook cluster.
The Ceph cluster is deployed with `cephadm`, Rook is deployed with `helm` and running on `k3s`. 

This setup is for testing purposes only, i.e. it is a relatively simple deployment to test `rookify` on, don't expect too much of it ;=). Any wishes to expand the testsetup are welcome.

## Prerequisites

- Free disk-space: about 200GB (depending on which diskscenario you use, see environment variable `DISK_SCENARIO`)
- RAM: about 32GB
- Hypervisor: Libvirt or Virtualbox
- Vagrant should be installed
- needed Vagrant plugins should be installed (like the Libvirt plugin)
- Ansible


## OS instances for VMs

The VMs are currently running on the [vagrant-box for the ubuntu 22.04 cloudimage](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-22.04).

The decision for the versions of Ubuntu instances used is based on the following links:

- [supported ceph versions](https://ubuntu.com/ceph/docs/supported-ceph-versions)
- [Ceph and the UCA](https://wiki.ubuntu.com/OpenStack/CloudArchive#Ceph_and_the_UCA)

## Vagrant

The decision to use Vagrant was taken, because it allows for relatively easy "Infrastructure As Code"-setup, for which the hypervisors (the providers) can be changed relatively easy.

### Virtualbox

Vagrant is running on Virtualbox per default. The current [Vagrantfile](./Vagrantfile) can be configured to use `virtualbox` as a provisioner. You can set this in the environment file `envrc.dist`. For more settings see vagrants [documentation](https://developer.hashicorp.com/vagrant/docs/vagrantfile).

### Libvirt Plugin

The usage of the `libvirt-provider` plugin is supported and used per default. Its installation might lead to complications though: In order to install the right version of the libvirt-plugin refer to the [documentation here](https://vagrant-libvirt.github.io/vagrant-libvirt/). If the solution in the documentation do not work, you might consider using a lower version of vagrant (e.g. as of 21-11-2024 version 2.4.1 is working well on my fedora host).

### Ansible Plugin

For provisioning the `vagrant-ansible` plugin is used.

## Setup

Checkout the [Makefile](./Makefile) by simply going to the working directory of the repository and running `make` on the console:

```bash
make
```

This will render a list of macros that can be used to help you manage the test-setup. Be sure to configure the setup to your need by adapting the environment vars, see `envrc.dist`. To run the setup simply run:

```bash
make setup
```

This will use the libvirt-provider per default to run the test-setup. You can adapt `envrc.dist` to use `virtualbox`. If you adapted the `Vagrantfile` to use an other provider, be sure the install the needed provider plugins (if needed) and then simply run `vagrant up`.

### Ceph version

The ceph version can be specified in [vars.yaml](./provisioning/vars.yaml.dist).

### Ceph services

The Ceph services to be deployed are defined in [ceph-hosts.j2](./provisioning/templates/ceph-hosts.j2).

### Environment Variables

Environment variables are set in `envrc.dist` using `direnv`: copy `envrc.dist` to `.envrc` and run `direnv allow`.
If you do not want to use `direnv` you can set and unset the environment variables manually:

```
# Unset ssh auth socket to prevent ssh agents to mess with this setup
unset $SSH_AUTH_SOCK

# Set provider to use
export PROVIDER="virtualbox"

# set usage of apt or manual installation of cephadm
export USE_APT_FOR_CEPHADM=1

# Set needed "test scenario" here, or set the environment variable yourself
export DISK_SCENARIO="scenario1
```

## Radosgateways and Buckets

See the last entry of `provisioning/templates/ceph-hosts.j2`. 

I added a lot of comments below which can help you to setup and tweak radosgateway to your needs. This has not been automated yet, as it can be very versatile.

You can also test the Swiftapi. For this I added a little script in `scripts/swift_client.py`. 

## Rookify - Testing

**First** you need to get the latest code of Rookify:

```bash
make get-rookify
```

This will download the repository for you.

**Second** Configure Rookify: Please take a look at the README.md in the repository or the documentation of SCS.

To get the needed IP's of the VMs run: 

```bash 
make get-config 
```

This will copy `.kube` and `/etc/ceph` to `rookify/.k8s` and `rookify/.ceph` respectively. Please adapt `rookify/.k8s/config` by changing `127.0.0.1` for the master node to the IP of the VM.

**Third**: Install Rookify and run it in `dry-run` mode. From within the Rookify repository run `make build-local-rookify`, then run it in dry-run by executing `.venv/bin/rookify -d` from within the working directory of the Rookify Repository.
Check Rookify's configs and check the pickle files status by running `.venv/bin/rookify -s`.

**Fourth**: Execute Rookify with `.ven/bin/rookify -m` and see if it works! Depending on you hardware this might take some time.



