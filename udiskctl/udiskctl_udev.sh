#!/bin/bash
PATH=/usr/sbin:/usr/bin:/sbin:/bin

# Import common functions
source /usr/local/bin/udiskctl_common.sh

DEV=$1
ENABLE_FILE="/etc/udiskctl/enable"
WHITELIST="/etc/udiskctl/whitelist"

logger "udiskctl: Detected USB drive $DEV"

# 1️⃣ Global allow
if [ -f "$ENABLE_FILE" ]; then
    logger "udiskctl: Global USB storage enabled, allowing $DEV"
    exit 0
fi

# 2️⃣ Get Vendor/Product
entry=$(get_usb_id "$DEV")
VENDOR=${entry%%:*}
PRODUCT=${entry##*:}
logger "udiskctl: USB drive attributes VENDOR=$VENDOR PRODUCT=$PRODUCT"

# 3️⃣ Whitelist check
if grep -q "^${VENDOR}:${PRODUCT}$" "$WHITELIST" 2>/dev/null; then
    logger "udiskctl: Whitelisted USB drive $DEV, mount allowed"
    exit 0
fi

# 4️⃣ Not whitelisted → Unmount and remove from USB bus
logger "udiskctl: Non-whitelisted USB drive $DEV, starting unmount and removal"

# Unmount all partitions
for part in /dev/$(basename $DEV)?; do
    if [ -b "$part" ]; then
        umount -l "$part" 2>/dev/null && \
        logger "udiskctl: Unmounted partition $part successfully" || \
        logger "udiskctl: Partition $part not mounted or unmount failed"
    fi
done

# Get USB bus device number
USB_DEV=$(udevadm info -q path -n "$DEV" | grep -o 'usb[0-9]\+/[0-9\-]\+' | tail -1 | cut -d/ -f2)
logger "udiskctl: USB bus device number USB_DEV=$USB_DEV"

# Remove from USB bus completely
if [ -n "$USB_DEV" ] && [ -d "/sys/bus/usb/devices/$USB_DEV" ]; then
    echo 1 > /sys/bus/usb/devices/$USB_DEV/remove
    logger "udiskctl: Non-whitelisted USB drive $DEV has been removed from USB bus"
else
    logger "udiskctl: Cannot find USB bus path, unable to remove $DEV"
fi

logger "udiskctl: $DEV processing completed"
exit 0
