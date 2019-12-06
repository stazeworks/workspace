#!/bin/bash

# VARS

if [ -z "$target" ]; then
	read -p "Which > sdX < we'll be use to install our workspase? " target
	log OK "Install system into: $target"
else
	log DONE "Install system into: $target"
fi


# FUCNTIONS

log() { echo -e "[*] [$(date --rfc-3339=FTM)] [$1] $2"; }

error() { clear; printf "[*] [$(date --rfc-3339='date')] [ERROR]:\\n%s\\n" "$1"; exit;}

checkBios() {
	if [ -d /sys/firmware/efi/efivars ]; then
		log LOG "[*] [OK] UEFI detected."
	else
		error "It\'s BIVOS, not UEFI!"
	fi
}

partiotion() {
	log INFO "Partiotions\\n   [#] ---- Before: ---- [#]"
	lsblk
	echo -e "[#] ------------------- [#]\n"
	parted /dev/$target --script mklabel gpt \
		mkpart primary fat32 1MiB 300MiB \
		set 1 esp on \
		mkpart primary ext2 300MiB 700MiB \
		mkpart primary ext4 700MiB 100%
	log INFO "Partiotions\\n   [#] ---- After: ---- [#]"
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






