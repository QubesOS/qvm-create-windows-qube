#!/bin/bash

# Copyright (C) 2023 Elliot Killick <contact@elliotkillick.com>
# Licensed under the MIT License. See LICENSE file for details.

error() {
    exit_code="$?"
    echo -e "${RED}[!]${NC} An unexpected error has occurred! Exiting..." >&2
    exit "$exit_code"
}

trap error ERR

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

usage() {
    echo "Usage: ${0} [NetVM]"
    echo ""
    echo "Create resources qube, install package dependencies in template, clone project repo, install Qubes Windows Tools and finally copy qvm-create-windows-qube main program to Dom0"
    echo ""
    echo "The optional NetVM paramater is the NetVM for use in downloading the project and Windows media (default: sys-firewall if no global default is set)"
}

for arg in "$@"; do
    if [ "$arg" == "-h" ] ||  [ "$arg" == "--help" ]; then
        usage
        exit
    fi
done

netvm="$1"

# Validate this is Dom0
if [ "$(hostname)" != "dom0" ]; then
    echo -e "${RED}[!]${NC} This script must be run in Dom0" >&2
    exit 1
fi

# Validate netvm
if [ "$netvm" ]; then
    if ! qvm-check "$netvm" &> /dev/null; then
        echo -e "${RED}[!]${NC} NetVM does not exist: $netvm" >&2
        exit 1
    elif [ "$(qvm-prefs "$netvm" provides_network)" != "True" ]; then
        echo -e "${RED}[!]${NC} Not a NetVM: $netvm" >&2
        exit 1
    fi
fi

# Validate QWT installation
if [ -f "/usr/lib/qubes/qubes-windows-tools.iso" ]; then
    echo -e "${BLUE}[i]${NC} Qubes Windows Tools is already installed in Dom0. Skipping download..." >&2
else
    echo -e "${BLUE}[i]${NC} Installing Qubes Windows Tools..." >&2
    if ! sudo qubes-dom0-update -y qubes-windows-tools; then
        echo -e "${RED}[!]${NC} Error installing Qubes Windows Tools! Exiting..." >&2
        exit 1
    fi
    if ! [ -f "/usr/lib/qubes/qubes-windows-tools.iso" ]; then
        echo -e "${RED}[!]${NC} Qubes Windows Tools package is installed, but /usr/lib/qubes/qubes-windows-tools.iso is still missing in Dom0. Exiting..." >&2
        exit 1
    fi
fi

# Allow externally setting custom resources qube for advanced users
resources_qube="${RESOURCES_QUBE:-windows-mgmt}"
resources_dir="/home/user/qvm-create-windows-qube"
template="$(qubes-prefs default_template)"

echo -e "${BLUE}[i]${NC} Creating $resources_qube..." >&2
qvm-create --class AppVM --template "$template" --label black "$resources_qube"

echo -e "${BLUE}[i]${NC} Increasing storage capacity of $resources_qube..." >&2
qvm-volume extend "$resources_qube:private" 60GiB

# Temporarily enable networking
# If no global default NetVM has already been set (upon creation of qube)
if ! [ "$(qvm-prefs "$resources_qube" netvm)" ]; then
    if [ "$netvm" ]; then
        resources_qube_netvm="$netvm"
    else
        resources_qube_netvm="sys-firewall"
    fi

    echo -e "${BLUE}[i]${NC} Temporarily enabling networking of $resources_qube with $resources_qube_netvm..." >&2
    qvm-prefs "$resources_qube" netvm "$resources_qube_netvm"
fi

# If template hasn't already been started then start it
if ! qvm-check --running "$template"; then
    echo -e "${BLUE}[i]${NC} Starting $template..." >&2
    until qvm-start "$template"; do
        echo -e "${RED}[!]${NC} Failed to start $template! Not enough memory? Retrying in 10 seconds..." >&2
        sleep 10
    done
fi

echo -e "${BLUE}[i]${NC} Installing package dependencies on $template..." >&2
fedora_packages="genisoimage datefudge dash git"
debian_packages="genisoimage curl datefudge git"
qvm-run -p "$template" "if [ -f /etc/fedora-release ]; then sudo dnf -y install $fedora_packages; else sudo apt-get -y install $debian_packages; fi"

echo -e "${BLUE}[i]${NC} Shutting down $template..." >&2
qvm-shutdown --wait "$template"

echo -e "${BLUE}[i]${NC} Starting $resources_qube..." >&2
until qvm-start "$resources_qube"; do
    echo -e "${RED}[!]${NC} Failed to start $resources_qube! Not enough memory? Retrying in 10 seconds..." >&2
    sleep 10
done

echo -e "${BLUE}[i]${NC} Cloning qvm-create-windows-qube GitHub repository..." >&2
qvm-run -p "$resources_qube" "cd ${resources_dir%/*} && git clone https://github.com/ElliotKillick/qvm-create-windows-qube"

echo -e "${BLUE}[i]${NC} Please check for a \"Good signature\" from GPG (Verify it out-of-band if necessary)..." >&2
qvm-run -p "$resources_qube" "cd '$resources_dir' && gpg --import maintainers.asc && git verify-commit \$(git rev-list --max-parents=0 HEAD)"

echo -e "${BLUE}[i]${NC} Remember to download the desired version(s) of Windows using Mido in the $resources_qube qube..." >&2
qvm-run -p "$resources_qube" "'$resources_dir/windows/isos/mido.sh' --help"

echo -e "${BLUE}[i]${NC} Shutting down $resources_qube..." >&2
qvm-shutdown --wait "$resources_qube"

echo -e "${BLUE}[i]${NC} Air gapping $resources_qube..." >&2
qvm-prefs "$resources_qube" netvm ""

echo -e "${BLUE}[i]${NC} Copying qvm-create-windows-qube main program to Dom0..." >&2
qvm-run -p --filter-escape-chars --no-color-output "$resources_qube" "cat '$resources_dir/qvm-create-windows-qube'" | sudo tee /usr/bin/qvm-create-windows-qube > /dev/null

# Allow execution of script
sudo chmod +x /usr/bin/qvm-create-windows-qube

echo -e "${GREEN}[+]${NC} Installation complete!"
