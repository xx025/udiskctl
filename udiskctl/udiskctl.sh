#!/bin/bash
# udiskctl command: Manage global switch and allowlist for USB drives

VERSION="1.0.1"

source /usr/local/bin/udiskctl_common.sh

ENABLE_FILE="/etc/udiskctl/enable"
WHITELIST="/etc/udiskctl/whitelist"

case "$1" in
    ok)
        touch "$ENABLE_FILE"
        echo "USB storage globally enabled"
        ;;
    unok)
        rm -f "$ENABLE_FILE"
        echo "USB storage globally disabled"
        ;;
    add)
        # Get currently inserted USB devices
        # If currently in global disable state, prompt user to enable global USB storage first before adding to allowlist
        if [ ! -f "$ENABLE_FILE" ]; then
            echo "⚠️ USB storage is currently globally disabled. Please run 'udiskctl ok' to enable global USB storage before adding to allowlist."
            exit 1
        fi
        for dev in $(lsblk -ndo NAME,TRAN | awk '$2=="usb"{print $1}'); do
            entry=$(get_usb_id "$dev")
            if [[ -n "$entry" ]]; then
                if ! grep -q "^$entry$" "$WHITELIST"; then
                    echo "$entry" >> "$WHITELIST"
                    echo "Allowed USB drive $dev ($entry)"
                else
                    echo "USB drive $dev ($entry) is already in allowlist"
                fi
            else
                echo "⚠️ Unable to get Vendor/Product for /dev/$dev"
            fi
        done
        ;;
    clean)
        > "$WHITELIST"
        echo "All allowed USB drives have been cleared"
        ;;
    *)
        echo "udiskctl version $VERSION"
        echo "Current allowlist (Vendor:Product):"
        if [ -s "$WHITELIST" ]; then
            cat "$WHITELIST"
        else
            echo "(No devices in allowlist)"
        fi
        if [ -f "$ENABLE_FILE" ]; then
            echo "USB storage is globally enabled"
        else
            echo "USB storage is globally disabled"
        fi
        echo "Usage: udiskctl {ok|unok|add|clean}"
        ;;
esac
