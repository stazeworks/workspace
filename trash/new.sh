#!/bin/bash

# VARS
dateLog=$(date --rfc-3339='seconds')



# FUCNTIONS

log() { echo -e "[*] [$dateLog] [$1] $2"; }

error() { clear; printf "[*] [$dateLog] [ERROR]:\\n%s\\n" "$1"; exit;}

selectDisk() {
	if [ -z "$target" ]; then
		read -p "Which DISK we'll be use to install our workspase? (sdX) " target
		log OK "Install system into: $target"
	else
		log DONE "Install system into: $target"
	fi
}

preinstall() {
	if [ -d /sys/firmware/efi/efivars ]; then
		log OK "UEFI detected."
	else
		error "It\'s BIVOS, not UEFI!"
	fi

	timedatectl set-ntp true
	timedatectl set-timezone Europe/Moscow
	timedatectl status	
}

partiotion() {
	echo -e "\nPartiotions"
	echo -e "\n   [#] ---- BEFORE: ---- [#]"
	lsblk
	echo -e "[#] ------------------- [#]"

	parted -s /dev/sda mklabel gpt \
		mkpart efi '0%' '512MB' \
		mkpart crypt 513MB '100%' \
		set 1 esp on \
		set 1 boot on print && \

	echo -e "\n   [#] ---- AFTER: ---- [#]"
	lsblk
	echo -e "[#] ------------------- [#]\n"
}



# RUN IN ORDER

log START "Let battle begins!"
selectDisk
checkBios
partiotion


# INSTALL PROCESS

loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true


#arch-chroot /mnt sh -c "$(curl -fsSL https://git.io/X220b.sh)"




