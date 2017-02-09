#!/usr/bin/env bash

set -euo pipefail

[[ -z "${1-}" ]] && echo "Usage: up.sh <num-vms-to-launch>" && exit

# Download Oracle JDK 8.
#
if [[ ! -f jdk-8u121-linux-x64.rpm ]]
then
  wget --continue --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm"
fi

for i in $(seq -f '%03.3g' 1 $1);
do
  echo "Launching VM n$i"
  vagrant up --provider virtualbox n$i
done

