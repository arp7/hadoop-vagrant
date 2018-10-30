#!/usr/bin/env bash

# Bootstrap a Centos 7 VM for installing Apache Hadoop.
# Borrows code from https://github.com/u39kun/ambari-vagrant.
#

# Ensure the VMs can resolve each others hostnames.
#
cp /vagrant/dns-files/hosts /etc/hosts
cp /vagrant/dns-files/resolv.conf /etc/resolv.conf

echo "http_caching=packages" >> /etc/yum.conf
yum install -y ntp
service ntpd start
service iptables stop

# Again, stopping iptables
#
/etc/init.d/iptables stop

# Add some swap space.
#
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab

echo "Intalling the JDK"
yum install -y /vagrant/${OPENJDK_JDK_RPM} /vagrant/${OPENJDK_JRE_RPM}

# Workaround for missing network. https://github.com/mitchellh/vagrant/issues/8096
#
service network restart

# Create a couple of directories for Apache Hadoop.
#
mkdir -p /data/disk1 /data/disk2

# Install the Kerberos client on all machines
#
yum install -y krb5-libs krb5-auth-dialog rng-tools krb5-workstation

# Allow password-less ssh to root for Apache Hadoop/Ambari installs.
#
mkdir -p ~/.ssh && chmod 600 ~/.ssh
cp /vagrant/ssh-files/* ~/.ssh
chown -R root ~/.ssh 

