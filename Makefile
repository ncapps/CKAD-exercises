# https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

# https://docs.docker.com/docker-for-mac/networking/
# host.docker.internal resolves to the internal IP address used by the host
create:
> k3d cluster create --kubeconfig-update-default --kubeconfig-switch-context
> sed -i 's/0.0.0.0/host.docker.internal/g' $(HOME)/.kube/config
.PHONY: create

clean:
> k3d cluster delete k3s-default
.PHONY: delete
