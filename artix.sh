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
# Wipeout LVM?
dd bs=4096 if=/dev/zero iflag=nocache of=/dev/sda oflag=direct status=progress count=300000 && sync
pvremove -y -ff /dev/sda*

# 8. New partiotions
sudo parted -s /dev/sda mklabel gpt mkpart efi '0%' '512MB' mkpart crypt 513MB '100%' set 1 esp on set 1 boot on print

# 8. LUKS crypt
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptlvm

# 9. LVM setup
vgscan
vgchange -ay

vgcreate vg0 /dev/mapper/cryptlvm
lvcreate -L 50G vg0 -n root
lvcreate -L 173G vg0 -n home

modprobe dm_mod

lsblk /dev/sda

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home

mount /dev/vg0/root /mnt

mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

mkdir -p /mnt/home
mount /dev/vg0/home /mnt/home



################################################
# Preinstall: Installation                     #
################################################

basestrap /mnt base base-devel runit elogind-runit intel-ucode amd-ucode linux linux-firmware vim git dhcpcd-runit

fstabgen -U /mnt >> /mnt/etc/fstab


artix-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/stazeworks/workspace/master/laptop-x101h-in-chroot)"

