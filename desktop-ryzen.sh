#!/bin/bash

# Small Arch Linux install script

loadkeys ru
setfont cyr-sun16
echo 'Привет, давай установим твой грёбаный Арч... еще раз.'

echo '> Date sync...'
timedatectl set-ntp true

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

echo '> Partitions is...'
fdisk -l

echo '> Format partitions...'
mkfs.ext2  /dev/sda1 -L boot
mkswap /dev/sda2 -L swap
mkfs.ext4  /dev/sda3 -L root
mkfs.ext4 /dev/sda4 -L home

echo '> Mount partitions...'
mount /dev/sda3 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
mount /dev/sda4 /mnt/home

echo '> Setup DL mirror...'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '> Install packages...'
pacstrap /mnt base base-devel networkmanager grub-bios vim

echo '> Generating FS tabulation...'
genfstab -pU /mnt >> /mnt/etc/fstab

echo '> Entering in fresh install system...'
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/stazeworks/workspace/master/desktop-ryzen-root)"
