# WIT: Ansible playbooks

The ansible playbooks provided in this repository will allow to:
- provision the docker infrastructure
- deploy the latest source code

## Requirements
- [ansible](http://www.ansible.com) >= 1.9.2
- a Docker Hub Account with access to the [ScientiaMobile repository](https://hub.docker.com/u/scientiamobile/dashboard/)

*Note*: [SSH agent forwarding](https://developer.github.com/guides/using-ssh-agent-forwarding/) is used to access the ScientiaMobile GitHub Repos.

## Usage

*Note* In the current implementation the playbooks will ask for the following info:

- **SUDO password** *The sudo password for the remote user*
- **[Remote User] Username** *The user used with sudo privileges used for provisiong and deploy*
- **[Docker Hub] Username** *Docker Hub Account's username*
- **[Docker Hub] Password** *Docker Hub Account's password*
- **[Docker Hub] Email** *Docker Hub Account's email*

### wit-origin-cache provisioning and deploy

	ansible-playbook -i staging wit-origin-cache.yml

### wit-backend provisioning and deploy

	ansible-playbook -i staging wit-backend.yml

## Local testing

For local testing two vagrant boxes are configured in the vagrant folder.
To test locally:

	cd vagrant && vagrant up
    ansible-playbook -i local wit-origin-cache.yml
    ansible-playbook -i local wit-backend.yml
