## Introduction
Vagrantfile and bootstrap script to spin up to 10 VirtualBox VMs with JDK 8 installed for testing Apache Hadoop.

## Usage
```
cd centos7
./up.sh <num-vms>
vagrant ssh n001
```

The VM names will be n001, n002 etc.

You may find it useful to add the following entries to the hosts file on the host machine so the VMs are resolvable.

```
# Vagrant-based VMs for testing Apache Hadoop.
#
192.168.7.201    n001.hdfs.example.com n001
192.168.7.202    n002.hdfs.example.com n002
192.168.7.203    n003.hdfs.example.com n003
192.168.7.204    n004.hdfs.example.com n004
192.168.7.205    n005.hdfs.example.com n005
192.168.7.206    n006.hdfs.example.com n006
192.168.7.207    n007.hdfs.example.com n007
192.168.7.208    n008.hdfs.example.com n008
192.168.7.209    n009.hdfs.example.com n009
192.168.7.210    n010.hdfs.example.com n010
```

Additionally you can run the following command to enable password-less ssh access from the host to the guests.
```
cp centos7/ssh-files/id_rsa* ~/.ssh/
chmod 600 ~/.ssh/id_rsa*
```

## Customization
Each VM gets 2GB of memory which is enough to start HDFS and YARN daemons. Edit `centos7/Vagrantfile` to change the RAM allocation.
```
config.vm.provider :virtualbox do |vb|
  vb.customize ["modifyvm", :id, "--memory", 2048] # RAM allocated to each VM
  # vb.gui = true
end
```

## Acknowledgements
Based on https://github.com/u39kun/ambari-vagrant.


_Apache®, Apache Hadoop, Hadoop®, and the yellow elephant logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries._
