#!/bin/bash

# Small Arch Linux install script. It`s not  clear install:
# I use an en_US locale on the system, but have ru_RU keyboard 
# layout.


echo 'Welcome!'

# The default console keymap is US. Available layouts can be listed with: 
# ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys ru

# Console fonts are located in:
# ls /usr/share/kbd/consolefonts/
setfont cyr-sun16

echo 'Привет, давай установим твой грёбаный Арч... еще раз.'

# To be ensure the system clock is accurate:
echo '> Date sync...'
timedatectl set-ntp true

# Make partiotions for BIOS-like installation (not UEFI)
echo '> Partition manipulation...'
(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo +200M;

  echo n;
  echo;
  echo;
  echo;
  echo +8G;

  echo n;
  echo;
  echo;
  echo;
  echo +30G;

  echo n;
  echo p;
  echo;
  echo;
  echo a;
  echo 1;

  echo w;
) | fdisk /dev/sda

echo '> Try to identify disk devices...'
fdisk -l

echo '> Try to format partitions...'
mkfs.ext2  /dev/sda1 -L boot
mkswap /dev/sda2 -L swap
mkfs.ext4  /dev/sda3 -L root
mkfs.ext4 /dev/sda4 -L home

echo '> Let\`s mount our fresh-made partitions...'
mount /dev/sda3 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
mount /dev/sda4 /mnt/home

# Packages to be installed must be downloaded from mirror servers, which are defined in
# ls /etc/pacman.d/mirrorlist
echo '> I\`ll setup a RU mirror for download my packages'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '> Install packages...'
pacstrap /mnt base base-devel networkmanager grub-bios vim

echo '> Generating FS tabulation...'
genfstab -pU /mnt >> /mnt/etc/fstab

echo '> Entering in fresh install system...'
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/stazeworks/workspace/master/desktop-ryzen-in-chroot)"
