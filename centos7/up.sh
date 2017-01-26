#!/usr/bin/env bash

set -euo pipefail

[[ -z "${1-}" ]] && echo "Usage: up.sh <num-vms-to-launch>" && exit

# Download Oracle JDK 8.
#
if [[ ! -f jdk-8u112-linux-x64.rpm ]]
then
  wget --continue --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm"
fi

for i in $(seq -f '%03.3g' 1 $1);
do
  echo "Launching VM n$i"
  vagrant up --provider virtualbox n$i
done

