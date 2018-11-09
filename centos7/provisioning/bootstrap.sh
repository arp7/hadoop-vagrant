#!/usr/bin/env bash


# Bootstrap a Centos 7 VM for installing Apache Hadoop.
# Borrows code from https://github.com/u39kun/ambari-vagrant.
#

set -euo pipefail

# Add hosts file entries so the VMs can resolve each others' hostnames.
#
cp /vagrant/dns-files/hosts /etc/hosts
cp /vagrant/dns-files/resolv.conf /etc/resolv.conf

echo "http_caching=packages" >> /etc/yum.conf
yum install -y ntp
service ntpd start

# Stopping and disabling the firewall
#
systemctl stop firewalld
systemctl disable firewalld

# Add some swap space.
#
if [[ ! -f /swapfile ]]; then
    echo "Setting up swapfile..."
    sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab
fi

# Install the JDK on each machine.
#
echo "Installing the JDK..."
for i in ${JDK_INSTALLER_FILES}; do
    i="/vagrant/${i}"       # Qualify the path.
    [[ ! -f "${i}" ]] && echo "Invalid JDK file ${i}" && exit 1

    if echo "${i}" | grep -qi '\.rpm$'; then
        # RPM install. Simple case.
        #
        echo "Installing RPM file ${i}..."
        yum install -y "${i}"
        ln -sf /usr/lib/jvm/java /usr/java/latest
    elif echo ${i} | grep -qEi '(\.tar\.gz|\.tgz|\.tar)$'; then
        # Tarball install. Following instructions from
        # https://www.server-world.info/en/note?os=CentOS_7&p=jdk11&f=2
        #
        echo "Installing Tarball file ${i}..."
        mkdir -p /usr/java/vagrant_installed/
        # tar auto-recognizes archive files, so we skip the 'z' option.
        # This handles both .tar.gz and .tar with a single command.
        tar xf "${i}" --directory /usr/java/vagrant_installed/ --strip-components=1
        ln -sf /usr/java/vagrant_installed/ /usr/java/latest
        echo 'export JAVA_HOME=/usr/java/latest; export PATH=${PATH}:${JAVA_HOME}/bin' > /etc/profile.d/jdk.sh
    else
        echo "Unrecognized installer type ${i}. Installer should be an RPM or Tarball file."
        exit 1
    fi
done

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

