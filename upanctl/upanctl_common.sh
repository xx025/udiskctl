#!/bin/bash
# Common function: Get USB Vendor:Product by device name

get_usb_id() {
    local dev="$1"
    local idVendor idProduct
    idVendor=$(udevadm info --query=property --name="/dev/$dev" | awk -F= '/ID_VENDOR_ID/{print $2}')
    idProduct=$(udevadm info --query=property --name="/dev/$dev" | awk -F= '/ID_MODEL_ID/{print $2}')
    if [[ -n "$idVendor" && -n "$idProduct" ]]; then
        echo "${idVendor}:${idProduct}"
    else
        echo ""
    fi
}
