# WURFLDb - Provisioning

## Decrypting private data

This repo uses `git-crypt` to store private data securely. To work on the repository you need to have the shared key in your computer and unlock the files with this command:

```
git-crypt unlock /path/to/key/file
```

## Provisioning

Server provisioning is what needs to happen to prepare a server to have the application installed.

The only prerequisite **on the server** to run the provisioning is to have SSH access to the server, so eventually the SSH Key should already be setup.

### Ansible prerequisites

This setup uses [Ansible](https://github.com/ansible/ansible) to provision the server, the suggested way to install it is to use virtualenv and pypi:

1. install virtualenv: ```pip install virtualenv```
2. install virtualenvwrapper: [https://virtualenvwrapper.readthedocs.org/en/latest/](https://virtualenvwrapper.readthedocs.org/en/latest/)
3. create the virtual environment: ```mkvirtualenv wurfl```
4. activate the virtual environment: ```workon wurfl```
5. install the python packages: ```pip install -r requirements.txt```
6. install the required ansible roles: ```./install_ansible_roles```

### Development

**Install Vagrant**

See [https://www.vagrantup.com](https://www.vagrantup.com)

**Make it easy to sync your hosts file with your VMs**

This vagrant plugin can automatically add and remove hosts every time you add or destroy VMs. 

```
vagrant plugin install vagrant-hostsupdater
```

Now every time you boot or destroy a VM your /etc/hosts will have the hostname added/removed automatically. You will notice it asking you for your sudo password every time it tries to do that.

**Configure your ssh client**

All the machines will have a certain IP range, and we make them to be accessible directly as root. So this ~/.ssh/config makes it much more convenient.

```
# For vagrant virtual machines
Host 192.168.33.* *.vagrant.dev
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
  User root
  LogLevel ERROR
```  

##### Run vagrant machine

```
cd vagrant
vagrant up
```

The VM is configured as 192.168.33.30 with a DNS name of db-scientiamobile.vagrant.dev

### Staging


### Running ansible playbooks

export the ansible roles path:


```
export ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles 
```

The first time you run this on a clean machine you'll need to add the current variable to the command:

```
-e "mysql_current_root_password=''" 
```

This is required since the mysql default installation doesn't have a root password and we'll need to specify this to be able to setup the correct root password (from the secret.yml file).

In development:

```
export ANSIBLEKEY=~/.ssh/id_rsa_wurfl
ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles ansible-playbook -i inventories/devel site.yml --ask-become-pass -u lucam --private-key=$ANSIBLEKEY
```

In staging with a specific user:

```
export ANSIBLEKEY=~/.ssh/id_rsa_wurfl
ANSIBLE_ROLES_PATH=$VIRTUAL_ENV/ansible/roles ansible-playbook -i inventories/staging site.yml --ask-become-pass -u lucam --private-key=$ANSIBLEKEY
```

#### From the deploybox

To staging:

1. Login to the deploybox via `ssh`
2. `sudo su deploy` (when you do this you'll find this project updated in the working directory)
3. `ansible-playbook -i inventories/staging site.yml --ask-become-pass -u deploy`


#### Customize ansible runs

To customize the way ansible runs you can add a file ```group_vars/all/local.yml``` with your personal configuration (e.g. set there the key you want to upload for the deploy user keys)

Here is an example of the file:

```
app_secret_key_base: edc92fa0603aaa483b56092a59fac7d9847cbaec441c7cb3e21f9d75792cd6979d6dd4e9282b0067a66c0e60027833ce0a294b35d78c5732b281e7fdaa89f359
```

## Loading data

You can use the [wurfl-db-backup-restore](../wurfl-db-backup-restore) playbook to save the data from a server (e.g. production or staging) and upload it to a new server

