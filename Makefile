
COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_BLUE=\033[0;34m
COLOUR_END=\033[0m

.DEFAULT_GOAL:=help

## checking if docker, or podman should be used. Podman is preferred.
ifeq ($(shell command -v podman 2> /dev/null),)
	CONTAINERCMD=docker
else
	CONTAINERCMD=podman
endif

## set or get provider
ifeq (${origin PROVIDER},)
	PROVIDER=virtualbox
endif

.PHONY: help
help: ## Display this help message
	@echo -e '${COLOUR_RED}Usage: make <command>${COLOUR_END}'
	@cat $(MAKEFILE_LIST) | grep '^[a-zA-Z]'  | \
	    awk -F ':.*?## ' 'NF==2 {printf "  %-26s%s\n\n", $$1, "${COLOUR_GREEN}"$$2"${COLOUR_END}"}'
	@echo -e '${COLOUR_BLUE}Rookify specific commands${COLOUR_END}'
	@cat $(MAKEFILE_LIST) | grep '^[a-zA-Z]'  | \
	    awk -F ':.*?##rook# ' 'NF==2 {printf "  %-26s%s\n\n", $$1, "${COLOUR_GREEN}"$$2"${COLOUR_END}"}'

.PHONY: setup
setup: ## Setup the vms based on environment variables PROVIDER and USE_APT_FOR_CEPHADM (see envrc.dist)
	vagrant up --provider="${PROVIDER}"

.PHONY: provision
provision: ## Use vagrants ansible plugin to provision the machines based on USE_APT_FOR_CEPHADM (see envrc.dist)
	vagrant provision 

.PHONY: test-ansible-debug
test-ansible-debug: ## Run ansible directly without vagrant to test
	ansible-playbook provisioning/test/debug.yaml -i ./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

.PHONY: increase-disk-space
increase-disk-space: ## TODO: script to increase diskspace on host
# see here: https://www.rodolfocarvalho.net/blog/resize-disk-vagrant-libvirt/
	vagrant halt
	qemu-img resize ~/path/to/image +10G
	vagrant up && vagrant ssh bash -c 'echo ", +" | sudo sfdisk -N 1 /dev/vda --no-reread'
	vagrant ssh bash -c 'sudo partprobe'
	vagrant ssh bash -c 'sudo resize2fs /dev/vda1'

.PHONY: login-master
login-master: ## login to master per ssh
	vagrant ssh cephadm_master

.PHONY: destroy
destroy: ## destroy vagrant setup
	vagrant destroy -f

.PHONY: rebuild
rebuild: ## destroy vagrant setup and recreate it
	vagrant destroy -f && vagrant up

#
# Rookify Specific Commands
#
delete: 
	@if [ -d rookify ]; then \
		rm -rf rookify/.ceph/ rookify/.k8s/; \
	fi

.PHONY: get-rookify
get-rookify: ##rook# install rookify as a git submodule
	git clone git@github.com:SovereignCloudStack/rookify.git

.PHONY: get-configs
get-configs: delete ##rook# Get configs of vms for rookify
	/usr/bin/vagrant ssh-config > ssh_config.conf
	vagrant ssh cephadm_master -c "sudo kubectl config view --raw > /home/vagrant/.kubeconfig && sudo chown -R vagrant:vagrant /home/vagrant/.kubeconfig"
	mkdir -p rookify/.k8s/
	scp -F ssh_config.conf -r cephadm_master:/home/vagrant/.kubeconfig rookify/.k8s/config
	vagrant ssh cephadm_master -c "sudo cp -r /etc/ceph /tmp/ceph && sudo chown -R vagrant:vagrant /tmp/ceph"
	scp -F ssh_config.conf -r cephadm_master:/tmp/ceph rookify/.ceph


