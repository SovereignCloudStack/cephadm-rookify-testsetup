
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

.PHONY: help
help: ## Display this help message
	@echo -e '${COLOUR_RED}Usage: make <command>${COLOUR_END}'
	@cat $(MAKEFILE_LIST) | grep '^[a-zA-Z]'  | \
	    awk -F ':.*?## ' 'NF==2 {printf "  %-26s%s\n\n", $$1, "${COLOUR_GREEN}"$$2"${COLOUR_END}"}'a

.PHONY: setup
setup: ## Setup the VMs and Install Ceph and Rook using `vagrant up`
	vagrant up
	
.PHONY: stop
setup: ## Stop (halt) the setup using `vagrant halt`
	vagrant halt

.PHONY: destroy
destroy: ## Destroy the setup using `vagrant destroy`: this will remove all VMs and their disks without question (force)
	vagrant destroy -f

.PHONY: rebuild
rebuild: ## destroy vagrant setup and recreate it
	vagrant destroy -f && vagrant up

.PHONY: get-rookify
get-rookify: ## install rookify as a git submodule
	git clone git@github.com:SovereignCloudStack/rookify.git

.PHONY: get-configs
get-configs: ## Get configs of vms for rookify
	/usr/bin/vagrant ssh-config > ssh_config.conf
	vagrant ssh cephadm_master -c "sudo kubectl config view --raw > /home/vagrant/.kubeconfig && sudo chown -R vagrant:vagrant /home/vagrant/.kubeconfig"
	mkdir -p rookify/.k8s/
	scp -F ssh_config.conf -r cephadm_master:/home/vagrant/.kubeconfig rookify/.k8s/config
	vagrant ssh cephadm_master -c "sudo cp -r /etc/ceph /tmp/ceph && sudo chown -R vagrant:vagrant /tmp/ceph"
	scp -F ssh_config.conf -r cephadm_master:/tmp/ceph rookify/.ceph

.PHONY: login-master
login-master: ## login to master per ssh
	vagrant ssh cephadm_master

