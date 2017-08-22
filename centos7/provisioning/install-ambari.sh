#!/usr/bin/env bash

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
grep -Fv '<selection>MANDATORY</selection>' /var/lib/ambari-server/resources/stacks/HDP/2.1/services/SMARTSENSE/metainfo.xml > /tmp/metainfo.xml
cat /tmp/metainfo.xml > /var/lib/ambari-server/resources/stacks/HDP/2.1/services/SMARTSENSE/metainfo.xml

ambari-server start

