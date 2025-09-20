#!/bin/bash
set -e
makeself ../upanctl ./upanctl_installer.run "upanctl installer" tools/install_upanctl.sh

# cd <this project root dir>
# bash tools/install_upanctl.sh