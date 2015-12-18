# Provisioning and deployment of the wurfldb application

The following process can take you from a bare bones machine to a fully working copy of the production environment.

## 1. connect to deploy machine:

Use your own user, then you have to become deploy :

`sudo su - deploy`

this pulls the latest changes from the `ansible-playbooks` git repository and changed the current directory to that.

## 2. unlock git crypted files

You need to unlock the repository using the key present in the .ssh dir for the deploy user.

`git crypt unlock ~/.ssh/wurfl-git-crypt`

**NB This needs to be done only once, and has been already done**

## 3. install the required ansible roles

from the deploy user:

`sudo ./install_ansible_roles`

this installs the roles in `/ansible/roles`

## 4. provision the server

This operation will:

1. install the required software packages and libraries on the destination server
2. configure the basic directory structure for the application
3. setup the apache, mysql, redis services as required by the application

You need to let ansible-playbook know where the roles have been installed:

`export ANSIBLE_ROLES_PATH=/ansible/roles`

then to prepare the staging machine:

`cd ~/ansible-playbooks/wurfl-db/provisioning`

and:

`ansible-playbook -i inventories/staging site.yml --ask-become-pass -u deploy -e "mysql_current_root_password=''"`

If you need to do it on a different machine change / update the inventory

The playbook will require the password for the `deploy` user on the remote machine.

**NB** if there are errors after the setup of mysql and you need to re-run the playbook, or if you need to run it later to update the configuration you'll need to remove the `-e "mysql_current_root_password=''"` part.

## 5. download a backup from a running machine

To download a backup from a running machine, for instance from the production environment, you'll need to run the backup playbook that is in the wurfl-db-backup-restore directory in the ansible-playbooks repository:

`cd ~/ansible-playbooks/wurfl-db/backup-restore`

and:

`ansible-playbook -i inventories/production backup.yml`

You will have to provide the right mysql database password for the wurfldb user (look it up in the `production/secret.yml` file.)

at the end you'll find the backup archive in the `./data/` directory under `~/ansible-playbooks/wurfl-db/backup-restore`:

`ls -altr ~/ansible-playbooks/wurfl-db/backup-restore/data`

take note of the name of the latest archive (it'll be the one you have just downloaded).

**NB** you can run the backup task every time you want to save a backup of an installed wurfldb instance (it saves the database dump and the uploaded files/exported wurfl xml.)

## 6. restore the database on the new machine

To restore the application database and file archive you have obtained from the remote server, you'll need to run the restore playbook.

`cd ~/ansible-playbooks/wurfl-db/backup-restore`

and:

`ansible-playbook -i inventories/staging restore.yml -e "backup_name='backup_file_name'"`

where instead of backup_file_name you put the filename of the backup archive (without the .tgz extension.)

You will have to provide the right mysql database password for the wurfldb user (look it up in the `production/secret.yml` file.)

## 7. deploy the application

After you have done the previous steps you'll have a server with the software and the data required to run the wurfldb application. You'll then have to deploy the application itself:

`cd ~/ansible-playbooks/wurfl-db/deploy`

and:

`ansible-playbook -i inventories/staging deploy.yml -e "branch='master'"`

To deploy a different branch you can replace the variable value passed in the command line, or avoid passing the branch variable on the command line. In this case you'll be asked which branch you want to deploy.

You'll need to run the deploy playbook every time you need to update the code remote server.
