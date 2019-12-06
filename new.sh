#!/bin/bash

echo "HELLO"

# VARS

if [ -z "$target" ]; then
	read -p "Installation disk is: (sdX) " target
	echo "Install system into: $target"
else
	echo "Install system into: $target"
fi


# FUCNTIONS

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit;}

checkBios() { \
if [ -d /sys/firmware/efi/efivars ]; then
	echo "[*] UEFI detected."
else
	error "No way, man. UEFI ONLY!"
fi
}

partiotion() {
	echo "[*] Before parted:"
	lsblk
	echo -e "[*] -------------------\n"
	parted /dev/$target --script mklabel gpt mkpart primary fat32 1M 300M
	parted /dev/$target --script set 1 esp on
	parted /dev/$target --script mkpart primary ext2 300M 700M
	parted /dev/$target --script mkpart primary ext4 700M 100%
	echo "[*] After parted:"
	lsblk
	echo -e "[*] -------------------\n"
}


# CHECKS
checkBios


# PARTITION



# INSTALL PROCESS

loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true






