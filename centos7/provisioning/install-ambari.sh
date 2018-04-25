#!/usr/bin/env bash

# Exit if no Ambari repo URL was provided.
[[ -z $AMBARI_REPO_URL ]] && exit

# Setup the repo and install Ambari server.
#
wget -O /etc/yum.repos.d/ambari.repo $AMBARI_REPO_URL
yum install -y ambari-server

# We let Ambari reinstall the JDK. Kerberos will not work
# with self-installed JDK out of the box (JCE policy).
#
ambari-server setup -s

# Allow deselecting SmartSense while installing the cluster.
#
SMARTSENSE_METAINFO_2_1=/var/lib/ambari-server/resources/stacks/HDP/2.1/services/SMARTSENSE/metainfo.xml
SMARTSENSE_METAINFO_3_0=/var/lib/ambari-server/resources/stacks/HDP/3.0/services/SMARTSENSE/metainfo.xml

for metainfo_file in $SMARTSENSE_METAINFO_2_1 $SMARTSENSE_METAINFO_3_0
do
  if [ -f $metainfo_file ]; then
    grep -Fv '<selection>MANDATORY</selection>' $metainfo_file > /tmp/metainfo.xml
    cat /tmp/metainfo.xml > $metainfo_file
    rm -f /tmp/metainfo.xml
  fi
done

ambari-server start
