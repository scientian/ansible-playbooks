Host Setup
=========

An ansible role to setup a new docker host on Ubuntu.
The following tasks are performed:

- docker installation and configuration
- composer installation
- application directory setup (/u/apps)

Requirements
------------

None

Role Variables
--------------

None

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: host_setup }