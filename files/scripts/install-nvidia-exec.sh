#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# https://github.com/pedro00dk/nvidia-exec

echo 'installing dependencies'
rpm-ostree install lshw lsof

echo 'downloading nvidia-exec files from github'
curl -Lo /usr/bin/nvx https://raw.githubusercontent.com/pedro00dk/nvidia-exec/main/nvx.py
curl -Lo /usr/lib/systemd/system/nvx.service https://raw.githubusercontent.com/pedro00dk/nvidia-exec/main/nvx.service
curl -Lo /usr/lib/modprobe.d/nvx.conf https://raw.githubusercontent.com/pedro00dk/nvidia-exec/main/nvx-modprobe.conf
curl -Lo /etc/nvx.conf https://raw.githubusercontent.com/pedro00dk/nvidia-exec/main/nvx-options.conf

echo 'setting permissions'
chmod 755 /usr/bin/nvx
chmod 644 /usr/lib/systemd/system/nvx.service
chmod 644 /usr/lib/modprobe.d/nvx.conf
chmod 666 /etc/nvx.conf

echo 'enabling nvx.service'
systemctl enable nvx
