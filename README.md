## Introduction
Vagrant scripts to launch VirtualBox VMs for testing [Apache Hadoop](http://hadoop.apache.org/) or [HDP](https://hortonworks.com/products/data-center/hdp/).

## Usage
```
cd centos7
./up.sh <num-vms> [<jdk-installer-file>] [<Ambari-Repo-URL>]
vagrant ssh n001
```

The VM names will be n001, n002 etc.

The JDK installer filename is optional. If absent then a default JDK will be installed (currently OpenJDK8). If present, then it must be an RPM or Tarball file in the current directory.

The Ambari repo URL is optional. If specified, then Ambari Server will be installed on host n001.

*Note:* The VMs are setup for password-less ssh access using the insecure keyfiles found under centos7/ssh-files. Additionally, the vagrant user has password-less ssh enabled using the [Vagrant default insecure keyfiles](https://github.com/hashicorp/vagrant/tree/master/keys). If you care about security then you must replace these insecure keys.

## Customization
Each VM gets 2GB of memory which is enough to start HDFS and YARN daemons. Edit `centos7/Vagrantfile` to change the RAM allocation.
```
config.vm.provider :virtualbox do |vb|
  vb.customize ["modifyvm", :id, "--memory", 2048] # RAM allocated to each VM
  # vb.gui = true
end
```

## Optional Host Setup
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


## Acknowledgements
Based on https://github.com/u39kun/ambari-vagrant.


_Apache®, Apache Hadoop, Hadoop®, and the yellow elephant logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries._
