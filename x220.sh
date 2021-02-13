#!/bin/sh

# Run in target machine:
# pacman -Sy openssh && service start sshd && passwd
# curl -LO https://raw.githubusercontent.com/stazeworks/workspace/master/x220.sh | sh

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

	log INFO "Time&date setup:\n"
	timedatectl set-ntp true
	timedatectl set-timezone Europe/Moscow
	timedatectl status	
}

partiotion() {
	echo -e "\n      P A R T I T I O N S\n"
	echo -e "\n   [#] ---- BEFORE: ---- [#]\n"
	lsblk
	echo -e "\n   [#] ----------------- [#]\n"

	parted -s /dev/sda mklabel gpt \
		mkpart efi '0%' '512MB' \
		mkpart crypt ext4 513MB '100%' \
		set 1 esp on \
		set 1 boot on print &&
		mkfs.ext4 /dev/sda2

	echo -e "\n   [#] ---- AFTER: ---- [#]"
	lsblk
	echo -e "\n   [#] ---------------- [#]\n"
}

# Function execution

log START "Let's do dis!"
# lsblk
preinstall
partiotion

ping ntp.org -c 3
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true

log INFO "LUKS setup:\n"
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptlvm

vgcreate vg0 /dev/mapper/cryptlvm
lvcreate -L 50G vg0 -n root
lvcreate -L 16G vg0 -n swap
lvcreate -L 157G vg0 -n home

modprobe dm_mod
vgscan
vgchange -ay

lsblk /dev/sda


log INFO "\n Format partitions:\n"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home

mkswap /dev/vg0/swap
swapon /dev/vg0/swap

mount /dev/vg0/root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

mkdir /mnt/home
mount /dev/vg0/home /mnt/home
log INFO "Disk mount is over"


log INFO "Set hardcoded mirror (yandex)"
Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch > /etc/pacman.d/mirrorlist

log INFO "\nInstalling system. Setup Pacman:\n"
pacstrap /mnt base linux linux-firmware vim git intel-ucode efibootmgr openssh wpa_supplicant dhcpcd cryptsetup lvm2
genfstab -U -p /mnt >> /mnt/etc/fstab

# arch-chroot /mnt bash

log INFO "Chroot into installed Archlinux"