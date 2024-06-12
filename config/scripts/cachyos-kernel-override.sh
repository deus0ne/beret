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
curl -Lo /etc/yum.repos.d/_copr_bieszczaders-kernel-cachyos-lto.repo https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-fedora-lto-$(rpm -E %fedora).repo && \
rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos-lto  

echo 'Exclude official kernel from updates'
sed -i '/^\[updates\]/a\exclude\=kernel\*' /etc/yum.repos.d/fedora-updates.repo

echo 'Install uksmd'
curl -Lo /etc/yum.repos.d/_copr_bieszczaders-kernel-cachyos-addons.repo https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo && \
rpm-ostree install libcap-ng-devel procps-ng-devel uksmd
systemctl enable uksmd.service
