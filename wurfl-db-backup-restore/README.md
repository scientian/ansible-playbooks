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

### Running Backup

The backup playbook will ask for the mysql password to be used on the remote host.

In development:

```
export ANSIBLEKEY=~/.ssh/id_rsa_wurfl
ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles ansible-playbook -i inventories/devel backup.yml --private-key=$ANSIBLEKEY
```

From the deploybox (to staging):

1. Login to the deploybox via `ssh`
2. `sudo su deploy` (when you do this you'll find this project updated in the working directory)
3. `ansible-playbook -i inventories/staging backup.yml`

### Running Restore

**WARNING** running restore replaces the current data at the remote server with the one in `data` 

The restore playbook will ask for two parameters:

1. the mysql password to be used on the remote host
2. the name of the backup archive file to use. This archive file will be uploaded to the server from the playbook data directory.

To pass the name of the backup without prompt you have to pass an extra var on the command line like:

```
-e "backup_name='20151217103457'" 
```

N.B. in the example above the backup file would be called `20151217103457.tgz`

In development:

```
export ANSIBLEKEY=~/.ssh/id_rsa_wurfl
ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles ansible-playbook -i inventories/devel restore.yml -e "backup_name='20151217103457'" --private-key=$ANSIBLEKEY
```

From the deploybox (to staging):

1. Login to the deploybox via `ssh`
2. `sudo su deploy` (when you do this you'll find this project updated in the working directory)
3. `ansible-playbook -i inventories/staging restore.yml -e "backup_name='20151217103457'"`

