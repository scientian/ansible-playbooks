# WURFLDb - Deploying

## Decrypting private data

This repo uses `git-crypt` to store private data securely. To work on the repository you need to have the shared key in your computer and unlock the files with this command:

```
git-crypt unlock /path/to/key/file
```

## Server provisioning


### Ansible prerequisites

This setup uses [Ansible](https://github.com/ansible/ansible) to provision the server, the suggested way to install it is to use virtualenv and pypi:

1. install virtualenv: ```pip install virtualenv```
2. install virtualenvwrapper: [https://virtualenvwrapper.readthedocs.org/en/latest/](https://virtualenvwrapper.readthedocs.org/en/latest/)
3. create the virtual environment: ```mkvirtualenv wurfl```
4. activate the virtual environment: ```workon wurfl```
5. install the python packages: ```pip install -r requirements.txt```
6. install the required ansible roles: ```./install_ansible_roles```

### Development

Preparing the server to host the application Server provisioning is done by the playbooks in the [wurfl-db-provisioning project](../wurfl-db-provisioning), see the informations [there](../wurfl-db-provisioning) to setup a development vm via vagrant and test this playbook.

The development VM is configured as 192.168.33.30 with a DNS name of db-scientiamobile.vagrant.dev

### Running ansible playbooks

export the ansible roles path:

```
export ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles
```

In development:

```
export ANSIBLEKEY=~/.ssh/id_rsa_wurfl
ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles ansible-playbook -i inventories/devel deploy.yml --private-key=$ANSIBLEKEY
```

#### Deploying a branch

The playbook asks for the branch to deploy when running, to deploy a specific branch without prompt pass it as an extra var on the command line like:

```
-e "branch='master'"
```

#### From the deploybox

To staging:

1. Login to the deploybox via `ssh`
2. `sudo su deploy` (when you do this you'll find this project updated in the working directory)
3. `ansible-playbook -i inventories/staging deploy.yml -e "branch='master'" `

To production:

1. Login to the deploybox via `ssh`
2. `sudo su deploy` (when you do this you'll find this project updated in the working directory)
3. `ansible-playbook -i inventories/production deploy.yml -e "branch='master'" `
