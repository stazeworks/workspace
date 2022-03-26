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
dd bs=4096 if=/dev/zero iflag=nocache of=/dev/sdb oflag=direct status=progress count=300000 && sync

# 8. New partiotions
sudo parted -s /dev/sdb mklabel gpt mkpart efi '0%' '512MB' mkpart root 513MB '30GB' mkpart home '31GB' '100%' set 1 esp on set 1 boot on print

# 9. Format partiotions
mkfs.fat -F32 /dev/sdb1
mkfs.ext4 /dev/sdb2
mkfs.ext4 /dev/sdb3


# 10. Mount partiotions
mount /dev/sdb2 /mnt

mkdir -p /mnt/boot
mount /dev/sdb1 /mnt/boot

mkdir -p /mnt/home
mount /dev/sdb3 /mnt/home



################################################
# Installation                                 #
################################################

basestrap /mnt base base-devel runit elogind-runit intel-ucode amd-ucode mkinitcpio linux linux-firmware vim git dhcpcd-runit

fstabgen -U /mnt >> /mnt/etc/fstab

artix-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/stazeworks/workspace/master/basic/artix.chroot.sh)"

