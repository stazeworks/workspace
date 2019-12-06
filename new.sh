#!/bin/bash

echo "HELLO"

# VARS

if [ -z "$target" ]; then
	read -p "Installation disk is: (sdX)" target
	echo "Install system into: $target"
else
	echo "Install system into: $target"
fi


# FUCNTIONS

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit;}

checkBios() { \
if [ -d /sys/firmware/efi/efivars ]; then
	echo "Fine. We are on UEFI install, keep going."
else
	error "No way, man. UEFI ONLY!"
fi
}


# CHECKS
checkBios


# PARTITION
parted /dev/$target mklabel gpt mkpart P1 ext3 1MiB 8MiB 


# INSTALL PROCESS

loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true






