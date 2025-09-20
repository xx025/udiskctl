#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "Installing upanctl to /usr/local/bin/ ..."
echo "install upanctl.sh "
install -m 755 upanctl/upanctl.sh /usr/local/bin/upanctl
echo "install upanctl_udev.sh "
install -m 755 upanctl/upanctl_udev.sh /usr/local/bin/upanctl_udev.sh
echo "install upanctl_common.sh "
install -m 755 upanctl/upanctl_common.sh /usr/local/bin/upanctl_common.sh
echo "upanctl install to /usr/local/bin/ complete."