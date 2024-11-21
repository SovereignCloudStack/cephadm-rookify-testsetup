# README

Setting up some virtual machines to test around with ceph: especially to test cephadm. 

## Which versions

I decided which version of Ubuntu and which version of Ceph to use based on ...

this link:
- [supported ceph versions](https://ubuntu.com/ceph/docs/supported-ceph-versions)

this table might be practical for openstack stuff:
- [Ceph and the UCA](https://wiki.ubuntu.com/OpenStack/CloudArchive#Ceph_and_the_UCA)

## Vagrant

Using vagrant because it allows for relatively easy "Infrastructure As Code"-setup, for which the hypervisors (the providers) can be changed relatively easy.

It also includes plugins which allow for easy setup of provisioners, like ansible.



