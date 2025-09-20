#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "Installing udiskctl to /usr/local/bin/ ..."
echo "install udiskctl.sh "
install -m 755 udiskctl/udiskctl.sh /usr/local/bin/udiskctl
echo "install udiskctl_udev.sh "
install -m 755 udiskctl/udiskctl_udev.sh /usr/local/bin/udiskctl_udev.sh
echo "install udiskctl_common.sh "
install -m 755 udiskctl/udiskctl_common.sh /usr/local/bin/udiskctl_common.sh
echo "udiskctl install to /usr/local/bin/ complete."