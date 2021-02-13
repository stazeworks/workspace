#!/bin/sh

# Function decloration
#  Logs
log() { echo -e "[*] [$dateLog] [$1] $2"; }

selectDisk() {
	if [ -z "$target" ]; then
		read -p "Select disk (sdX) as target to intall Archlinux" target
		log OK "Install system into: $target"
	else
		log RETRY "You must select disk!"
        selectDisk          
	fi
}

preinstall() {
	if [ -d /sys/firmware/efi/efivars ]; then
		log INFO "[UEFI] / bios"
	else
		log INFO "[BIOS] / uefi"
	fi

	timedatectl set-ntp true
	timedatectl set-timezone Europe/Moscow
	timedatectl status	
}

partiotion() {
	echo -e "\nP A R T I T I O N S\n"
	echo -e "\n   [#] ---- BEFORE: ---- [#]\n"
	lsblk
	echo -e "\n[#] ------------------- [#]/n"

	parted -s /dev/sda mklabel gpt \
		mkpart efi '0%' '512MB' \
		mkpart crypt 513MB '100%' \
		set 1 esp on \
		set 1 boot on print

	echo -e "\n   [#] ---- AFTER: ---- [#]"
	lsblk
	echo -e "[#] ------------------- [#]\n"
}

# Function execution

log START "Let's do dis!"
lsblk
checkBios
partiotion

ping ntp.org -c 3
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true
log INFO Done!