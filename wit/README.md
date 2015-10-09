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

### Run the host-setup.yml playbook against the specified host or group
    ansible-playbook wit-host-setup.yml \
      --inventory-file staging \
      --limit wit-backend

# PRODUCTION

## FRONTEND

    ansible-playbook wit-frontend-deploy.yml --inventory-file production --limit wit-frontend
    ansible-playbook wit-frontend-production-docker.yml --ask-become-pass --inventory-file production --limit wit-frontend 

## BACKEND

    ansible-playbook wit-backend-deploy.yml --ask-become-pass --inventory-file production --limit wit-backend
    ansible-playbook wit-backend-docker.yml --ask-become-pass --inventory-file production --limit wit-backend

## ORIGIN CACHE

    ansible-playbook wit-origin-cache-deploy.yml --ask-become-pass --inventory-file production --limit wit-origin-cache
    ansible-playbook wit-origin-cache-docker.yml --ask-become-pass --inventory-file production --limit wit-origin-cache
      
      
# STAGING

## FRONTEND

    ansible-playbook wit-frontend-deploy.yml --inventory-file staging --limit wit-frontend
    ansible-playbook wit-frontend-staging-docker.yml --ask-become-pass --inventory-file staging --limit wit-frontend 

## BACKEND

    ansible-playbook wit-backend-deploy.yml --ask-become-pass --inventory-file staging --limit wit-backend
    ansible-playbook wit-backend-docker.yml --ask-become-pass --inventory-file staging --limit wit-backend

## ORIGIN CACHE

    ansible-playbook wit-origin-cache-deploy.yml --ask-become-pass --inventory-file staging --limit wit-origin-cache
    ansible-playbook wit-origin-cache-docker.yml --ask-become-pass --inventory-file staging --limit wit-origin-cache

