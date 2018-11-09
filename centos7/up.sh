#!/usr/bin/env bash

set -euo pipefail

[[ -z "${1-}" ]] && echo "Usage: up.sh <num-vms-to-launch> [<JDK tarball file>] [<Ambari-repo-url>]

  JDK tarball or RPM file is optional. If not provided, then OpenJDK8
  will be installed.

  Ambari-repo-url is optional. If it is provided, then Ambari Server
  will be installed on the first VM (n001.hdfs.example.com)." && exit

AMBARI_REPO=${3-}
[[ -n ${AMBARI_REPO} ]] && echo "Will install Ambari from $AMBARI_REPO"

DEFAULT_JDK_RPMS="java-1.8.0-openjdk-devel-1.8.0.191.b12-0.el7_5.x86_64.rpm"
RPM_BASE_URL=http://mirror.centos.org/centos/7/updates/x86_64/Packages
JDK_INSTALLER_FILES=${2-}

# Ensure the vagrant-vbguest plugin is installed.
# See http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/
#
if ! vagrant plugin list | grep -qi vagrant-vbguest; then
  vagrant plugin install vagrant-vbguest
fi

# No JDK package provided on the command-line. Download the default.
#
if [[ -z "${JDK_INSTALLER_FILES}" ]]; then
    echo "No JDK installer specified, I will use the default"
    for f in ${DEFAULT_JDK_RPMS}; do
        [[ ! -f "${f}" ]] && wget "${RPM_BASE_URL}/${f}"
    done
    JDK_INSTALLER_FILES="${DEFAULT_JDK_RPMS}"
else
    echo "I will install the JDK using ${JDK_INSTALLER_FILES}."
fi

# Start the VMs, setting environment variables to locate JDK RPMs and
# Ambari repo URL.
#
for i in $(seq -f '%03.3g' 1 $1); do
    echo "Launching VM n${i}..."
    JDK_INSTALLER_FILES="${JDK_INSTALLER_FILES}" \
        AMBARI_REPO_URL="${AMBARI_REPO}" \
        vagrant up --provider virtualbox n${i}
done

