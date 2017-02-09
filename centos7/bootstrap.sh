#!/usr/bin/env bash

# Bootstrap a Centos 7 VM for installing Apache Hadoop.
# Borrows code from https://github.com/u39kun/ambari-vagrant.
#

# Ensure the VMs can resolve each others hostnames.
#
cp /vagrant/dns-files/hosts /etc/hosts
cp /vagrant/dns-files/resolv.conf /etc/resolv.conf

# Enable password-less ssh for root between the VMs.
#
mkdir -p /root/.ssh
cp /vagrant/ssh-files/* /root/.ssh/
chmod 600 /root/.ssh
chmod 600 /root/.ssh/id_rsa*
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

yum install ntp -y
service ntpd start
service iptables stop

#Again, stopping iptables
/etc/init.d/iptables stop

# Increasing swap space
#
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab

# Workaround for missing network https://github.com/mitchellh/vagrant/issues/8096
#
sudo service network restart

# Install Oracle JDK 8.
#
yum -y install openssl openssl-devel
yum install -y /vagrant/jdk-8u121-linux-x64.rpm

# Create a couple of directories for Apache Hadoop.
#
mkdir -p /data/disk1 /data/disk2

