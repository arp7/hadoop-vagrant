#!/usr/bin/env bash

set -euo pipefail

[[ -z "${1-}" ]] && echo "Usage: up.sh <num-vms-to-launch> <Ambari-repo-url>
  Ambari-repo-url is optional. If it is provided, then Ambari Server will be
  installed on the first VM (n001.hdfs.example.com)." && exit


JDK_BUILD=8u131-b11
JDK_RPM_FILE=jdk-$(echo $JDK_BUILD | sed 's/-.*$//')-linux-x64.rpm
JDK_URL_HASH=d54c1d3a095b4ff2b6607d096fa80163
AMBARI_REPO=${2-}

# Ensure the vagrant-vbguest plugin is installed.
# See http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/
#
vagrant plugin install vagrant-vbguest

# Download Oracle JDK 8.
#
if [[ ! -f $JDK_RPM_FILE ]]
then
  echo "Fetching JDK8 RPM."
  wget --continue --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JDK_BUILD}/${JDK_URL_HASH}/${JDK_RPM_FILE}"
fi

for i in $(seq -f '%03.3g' 1 $1);
do
  echo "Launching VM n$i"
  if [[ ! -z $AMBARI_REPO ]]
  then
    echo "Installing Ambari Server from $AMBARI_REPO"
  fi
  AMBARI_REPO_URL=$AMBARI_REPO vagrant up --provider virtualbox n$i
done

