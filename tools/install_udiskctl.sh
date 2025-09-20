#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "Installing udiskctl to /usr/local/bin/ ..."

mkdir -p /etc/udiskctl
touch /etc/udiskctl/whitelist
touch /etc/udiskctl/enable
echo "Control file and whitelist created."

# 2️⃣ Create udev rule
cat <<EOF >/etc/udev/rules.d/99-udiskctl.rules
ACTION=="add", KERNEL=="sd?", SUBSYSTEMS=="usb", RUN+="/usr/local/bin/udiskctl_udev.sh %k"
EOF
echo "udev rule created."


echo "Installing upanctl scripts..."
echo "install udiskctl.sh "
install -m 755 udiskctl/udiskctl.sh /usr/local/bin/udiskctl
echo "install udiskctl_udev.sh "
install -m 755 udiskctl/udiskctl_udev.sh /usr/local/bin/udiskctl_udev.sh
echo "install udiskctl_common.sh "
install -m 755 udiskctl/udiskctl_common.sh /usr/local/bin/udiskctl_common.sh
echo "udiskctl install to /usr/local/bin/ complete."