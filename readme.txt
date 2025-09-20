udiskctl is a USB storage management tool for Linux systems, designed to help users securely and conveniently control the access and usage of USB storage devices.

Main Features:
    - One-click enable/disable of all USB storage devices
    - Add specific USB drives to a whitelist, allowing only authorized devices
    - Automatically detect and block unauthorized USB drives, with support for auto-unmount and physical removal
    - Installation script included, integrates udev rules for plug-and-play control
    - Suitable for environments with high data security requirements, such as enterprises, schools, and laboratories

For installation and usage instructions, please refer to the project scripts and comments.


Installation:

    wget https://github.com/xx025/udiskctl/releases/latest/download/udiskctl_installer.run
    chmod +x udiskctl_installer.run
    sudo ./udiskctl_installer.run

Example usage:

    sudo udiskctl ok      # Globally enable USB storage
    sudo udiskctl unok    # Globally disable USB storage
    sudo udiskctl add     # Allow currently inserted USB drives
    sudo udiskctl clean   # Clear all allowed USB drives


Uninstallation:
    rm -rf /usr/local/bin/udiskctl*