# Set up Hadoop cluster with Ansible

This repository aims to setup a hadoop cluster of nodes with an Ansible playbook.

## How to run this repository

Log in as super user on Linux

```
sudo su
```

Install Ansible following [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) accordingly to your operating system

Define nodes IP addresses and hostnames on hosts file as IPADDRESS HOSTNAME line by line, for instance 

```
8.8.8.8 master
```

Run this script for creating Ansible inventory

```
bash put_hosts.sh
```

Before run the playbook, make sure the hadoop instalation folder is on master's node /root directory

1. Go to [Hadoop Releases](https://hadoop.apache.org/releases.html)
2. Trigger a wget command on one of those **Binary download** links
3. Extract the zip on /root

Run the playbook

```
ansible-playbook playbook.yml
```

## Tips

- Create virtual machines for setting up this enviroment
- Attach master and slaves nodes to the same network

## Future

- Docker Support
- Ansible playbook tasks for setting up Hadoop XML files on etc/hadoop, based on templates given by the user

## Troubleshooting

### SSH

Master node has to be able to connect via ssh on slaves as **root** without inputing the password. Therefore, besides the step of copying master's SSH Key into slaves with ssh-copy-id, please go to /etc/ssh/ssh_config and set this property

```
PermitRootLogin yes
```

### Resolve hostname by the correct IP

> It may seem foolish, but I myself spent two days trying to realize why my nodes were on subnet A and Hadoop was attaching my node master on subnet B

If you are going to setup the /hadoop/etc/workers file with names instead of IP addresses, please make sure this name is exclusively attach to this IP. For instance, given the scenario

```
127.0.1.1       master
192.168.0.107   master
192.168.0.105   node0
192.168.0.102   node1
```

Hadoop will resolve master on 127.0.1.1, and not on 192.168.0.107. Therefore, a quick solution would be comment the first line, if your nodes are attached to the subnet 192.168.0.x

### Internet Connection

Ansible will try to install packages, so make sure your nodes have internet connection. If you're running virtual machines, attach their network card on Bridge Mode
