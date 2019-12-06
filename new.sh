#!/bin/bash

# VARS
dateLog=$(date --rfc-3339='seconds')

if [ -z "$target" ]; then
	read -p "Which DISK we'll be use to install our workspase? (sdX)" target
	log OK "Install system into: $target"
else
	log DONE "Install system into: $target"
fi

# FUCNTIONS

log() { echo -e "[*] [$dateLog] [$1] $2"; }

error() { clear; printf "[*] [$dateLog] [ERROR]:\\n%s\\n" "$1"; exit;}

checkBios() {
	if [ -d /sys/firmware/efi/efivars ]; then
		log OK "UEFI detected."
	else
		error "It\'s BIVOS, not UEFI!"
	fi
}

partiotion() {
	log "" "\nPartiotions"
	log "" "\n   [#] ---- Before: ---- [#]\n"
	lsblk
	echo -e "[#] ------------------- [#]"
	parted /dev/$target --script mklabel gpt \
		mkpart primary fat32 1MiB 300MiB \
		set 1 esp on \
		mkpart primary ext2 300MiB 700MiB \
		mkpart primary ext4 700MiB 100%
	log "" "\n   [#] ---- After: ---- [#]\n"
	lsblk
	echo -e "[#] ------------------- [#]\n"
}


# RUN IN ORDER

log START "Let battle begins!"
checkBios
partiotion


# INSTALL PROCESS

loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true






