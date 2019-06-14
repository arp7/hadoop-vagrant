#!/usr/bin/env bash

set -euo pipefail

[[ -z "${1-}" ]] && echo "Usage: up.sh <num-vms-to-launch> [<JDK tarball file>] [<Ambari-repo-url>]

  JDK tarball or RPM file is optional. If not provided, then OpenJDK8
  will be installed.

  Ambari-repo-url is optional. If it is provided, then Ambari Server
  will be installed on the first VM (n001.hdfs.example.com)." && exit

AMBARI_REPO=${3-}
[[ -n ${AMBARI_REPO} ]] && echo "Will install Ambari from $AMBARI_REPO"

JDK_INSTALLER_FILES=${2-}

# Ensure the vagrant-vbguest plugin is installed.
# See http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/
#
if ! vagrant plugin list | grep -qi vagrant-vbguest; then
  vagrant plugin install vagrant-vbguest
fi

# Look for JDK RPM.
#
shopt -s nullglob
DEFAULT_OPEN_JDK_RPMS=$(echo *openjdk*.rpm)
DEFAULT_OPEN_JDK_TARBALL=$(echo *openjdk*.tar*)

if [[ -z "${JDK_INSTALLER_FILES}" ]]; then
  echo "No JDK installer specified, I will look for OpenJDK RPM..."
  JDK_INSTALLER_FILES="${DEFAULT_OPEN_JDK_RPMS}"
  if [[ -z ${JDK_INSTALLER_FILES} ]]; then
    echo "No OpenJDK RPM found, looking for tarballs..."
    JDK_INSTALLER_FILES="${DEFAULT_OPEN_JDK_TARBALL}"
    if [[ -z ${JDK_INSTALLER_FILES} ]]; then
      echo "No OpenJDK RPM or tarball found in install directory. Giving up."
      exit 2
    fi
  fi
fi

echo "I will install the JDK using ${JDK_INSTALLER_FILES}."

# Start the VMs, setting environment variables to locate JDK RPMs and
# Ambari repo URL.
#
for i in $(seq -f '%03.3g' 1 "$1"); do
    echo "Launching VM n${i}..."
    JDK_INSTALLER_FILES="${JDK_INSTALLER_FILES}" \
        AMBARI_REPO_URL="${AMBARI_REPO}" \
        vagrant up --provider virtualbox "n${i}"
done

