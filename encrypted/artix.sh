#!/bin/sh

################################################
# Preinstall: Wifi                             #
################################################

# 1. Interfaces list:
#ip a

# 2. Find wifi interface, f.e. wlan0
#sudo ip link set wlan0 up

# 2.1 Problems? Try this:
#sudo rfkill unblock wifi
#sudo ip link set wlan0 up

# 3. Start setup wifi connection
#connmanctl
#> scan wifi
#> services
# Choose stroke this your SSID
#> agent on
# Use TAB for matching your SSID
#> connect wifi_xxxxxxx_xxxxxx...
# Passphrase:
#> blabla
#> quit

# 4. Checks:
ip a
ping ntp.org -c 3



################################################
# Preinstall: Tools                            #
################################################

# 5. Install tools: internet is required!
#pacman -Sy openssh-runit parted --noconfirm
#ln -s /etc/runit/sv/sshd /run/runit/service/sshd
#sv start sshd



################################################
# Preinstall: Time and Date                    #
################################################

timedatectl set-ntp true
timedatectl set-timezone Europe/Moscow
timedatectl status



################################################
# Preinstall: Console output                   #
################################################

loadkeys ru
setfont cyr-sun16



################################################
# Preinstall: Partiotions                      #
################################################

# 6. UEFI or BIOS?
ls /sys/firmware/efi/efivars

# 7. Wipeout target disk
lsblk

umount /dev/sdb1
umount /dev/mapper/artix-root
umount /dev/mapper/artix-home
pvremove -y -ff /dev/sdb*
dd bs=4096 if=/dev/zero iflag=nocache of=/dev/sdb oflag=direct status=progress count=300000 && sync


# 8. New partiotions
sudo parted -s /dev/sdb mklabel gpt mkpart efi '0%' '512MB' mkpart crypt 513MB '100%' set 1 esp on set 1 boot on print

# Load kernel modules for encryption

modprobe dm-crypt
modprobe dm-mod

# 9. LUKS crypt
cryptsetup benchmark
cryptsetup --verbose --type luks1 --cipher serpent-xts-plain64 --key-size 512 --hash whirlpool --iter-time 10000 --use-random --verify-passphrase luksFormat /dev/sdb2
cryptsetup luksOpen /dev/sdb2 crypt

# 10. LVM setup
vgscan
vgchange -ay

pvcreate /dev/mapper/crypt
vgcreate artix /dev/mapper/crypt
lvcreate -L 50G artix -n root
lvcreate -L 143G artix -n home
lvcreate -L 30GG artix -n tmp
lsblk /dev/sdb

# 9. Format partiotions
mkfs.fat -F32 /dev/sdb1
mkfs.ext4 /dev/artix/root
mkfs.ext4 /dev/artix/home


# 10. Mount partiotions
mount /dev/artix/root /mnt

mkdir -p /mnt/boot
mount /dev/sdb1 /mnt/boot

mkdir -p /mnt/home
mount /dev/artix/home /mnt/home



################################################
# Installation                                 #
################################################

basestrap /mnt base base-devel runit elogind-runit intel-ucode amd-ucode cryptsetup mkinitcpio linux  linux-firmware vim git dhcpcd-runit

fstabgen -U /mnt >> /mnt/etc/fstab

artix-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/stazeworks/workspace/master/artix.chroot.sh)"

