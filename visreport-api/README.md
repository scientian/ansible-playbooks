# Vis Report API: Ansible playbooks

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
    ansible-playbook host-setup.yml --ask-become-pass --inventory-file staging
            
# STAGING

    ansible-playbook deploy.yml --ask-become-pass --inventory-file staging
    ansible-playbook docker-provisioning.yml --ask-become-pass --inventory-file staging 
