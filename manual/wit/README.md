# WIT: Ansible playbooks

The ansible playbooks provided in this repository will allow to:
- provision the docker infrastructure
- deploy the latest source code

## Requirements
- [ansible](http://www.ansible.com) >= 1.9.3
- a Docker Hub Account with access to the [ScientiaMobile repository](https://hub.docker.com/u/scientiamobile/dashboard/)

*Note*: [SSH agent forwarding](https://developer.github.com/guides/using-ssh-agent-forwarding/) is used to access the ScientiaMobile GitHub Repos.

## Usage

*Note* In the current implementation the playbooks will ask for the following info:

- **SUDO password** *The sudo password for the remote user*

# Run the host-setup.yml playbook against the specified host or group
ansible-playbook \
  host-setup.yml \
  --inventory-file staging \
  --limit <host-or-group-name>
  --ask-vault-pass

# Deploy wit-backend code in the staging environment
ansible-playbook \
  deploy.yml \
  --inventory-file staging \
  --limit wit-backend

# Deploy wit-origin-cache code in the staging environment
ansible-playbook \
  deploy.yml \
  --inventory-file staging \
  --limit wit-origin-cache

# Docker provision for wit-backend (uses encrypted vars defined in wit-vars.yml)
ansible-playbook \
  wit-backend-docker.yml \
  --inventory-file staging \
  --limit wit-backend \
  --ask-vault-pass

# Docker provision for wit-origin-cache (uses encrypted vars defined in wit-vars.yml)
ansible-playbook \
  wit-origin-cache-docker.yml \
  --inventory-file staging \
  --limit wit-origin-cache \
  --ask-vault-pass
