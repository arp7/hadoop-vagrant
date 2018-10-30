#!/usr/bin/env bash

set -euo pipefail

[[ -z "${1-}" ]] && echo "Usage: up.sh <num-vms-to-launch> <Ambari-repo-url>
  Ambari-repo-url is optional. If it is provided, then Ambari Server will be
  installed on the first VM (n001.hdfs.example.com)." && exit

AMBARI_REPO=${2-}
[[ -n ${AMBARI_REPO} ]] && echo "Installing Ambari Server from $AMBARI_REPO"

# Download OpenJDK RPMs if necessary.
#
OPENJDK_JDK_RPM=java-1.8.0-openjdk-devel-1.8.0.191.b12-0.el7_5.x86_64.rpm
OPENJDK_JRE_RPM=java-1.8.0-openjdk-1.8.0.191.b12-0.el7_5.x86_64.rpm
RPM_BASE_URL=http://mirror.centos.org/centos/7/updates/x86_64/Packages

if [ ! -f $OPENJDK_JDK_RPM ]; then
  wget ${RPM_BASE_URL}/${OPENJDK_JDK_RPM}
fi

if [ ! -f ${OPENJDK_JRE_RPM} ]; then
  wget ${RPM_BASE_URL}/${OPENJDK_JRE_RPM}
fi

# Ensure the vagrant-vbguest plugin is installed.
# See http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/
#
vagrant plugin install vagrant-vbguest

# Start the VMs, setting environment variables to locate JDK RPMs and
# Ambari repo URL.
#
for i in $(seq -f '%03.3g' 1 $1);
do
  echo "Launching VM n${i}"
  AMBARI_REPO_URL="${AMBARI_REPO}" \
      OPENJDK_JDK_RPM="${OPENJDK_JDK_RPM}" \
      OPENJDK_JRE_RPM="${OPENJDK_JRE_RPM}" \
      vagrant up --provider virtualbox n${i}
done

