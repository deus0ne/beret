#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo 'fsync kernel override'
rpm-ostree cliwrap install-to-root / && \
curl -Lo /etc/yum.repos.d/_copr_sentry-kernel-fsync.repo https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-$(rpm -E %fedora)/sentry-kernel-fsync-fedora-$(rpm -E %fedora).repo && \
rpm-ostree override replace \
  --experimental \
  --from repo=copr:copr.fedorainfracloud.org:sentry:kernel-fsync \
      kernel \
      kernel-core \
      kernel-modules \
      kernel-modules-core \
      kernel-modules-extra \
      kernel-uki-virt \
      kernel-headers \
      kernel-devel \

echo 'Exclude official kernel from updates'
sed -i '/^\[updates\]/a\exclude\=kernel\*' /etc/yum.repos.d/fedora-updates.repo
