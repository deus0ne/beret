#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
echo 'Enable SElinux policy'
setsebool -P domain_kernel_load_modules on

echo 'CachyOS kernel override'
rpm-ostree cliwrap install-to-root / && \
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos-lto    

echo 'Install uksmd'
rpm-ostree install libcap-ng-devel procps-ng-devel uksmd
systemctl enable uksmd.service
