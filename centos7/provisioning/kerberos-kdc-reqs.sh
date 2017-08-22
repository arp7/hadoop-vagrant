#!/usr/bin/env bash

set -euo pipefail

# This script installs and starts a KDC with the default EXAMPLE.COM realm.
# !!!! The kadmin principal password is highly insecure !!!!

# Install packages and create the database.
#
yum install -y krb5-server krb5-libs krb5-auth-dialog rng-tools
rngd -r /dev/urandom -o /dev/random
/usr/sbin/kdb5_util create -s -r EXAMPLE.COM -P admin

# Update /etc/krb5.conf
#
/vagrant/provisioning/copy-krb5-conf.sh

# Restart services. 
#
systemctl restart krb5kdc
systemctl restart kadmin

