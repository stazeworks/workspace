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
arch-chroot /mnt

# Setup our fresh-instlled Arch Linux!

echo '> Setup a hostname for the machine...'
echo "workstation" > /etc/hostname

echo '> Enable NerworkManager'
systemctl enable NetworkManager

echo '> Setup a Time Zone...'
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime

echo '> Setup EN/RU language support...'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen

echo '> Refresh locale in the system...'
locale-gen

echo '> Setup system default language'
echo 'LANG="en_US.UTF-8"' > /etc/locale.conf

echo '> Setup RU language for console'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo '> Init RAM boot drive...'
mkinitcpio -p linux

echo '>> Choose a root user password:'
passwd

echo '> Install GRUB loader to disk...'
grub-install --target=i386-pc /dev/sda

echo '> Make GRUB config...'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Enable multilib repo for run 32-bit applications on x64 system...'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo '> Download LARBS... Run this after next reboot!'
curl -LO larbs.xyz/larbs.sh

echo '>>> Reboot...'
exit
read -p "Pause 3 seconds..." -t 3
reboot
