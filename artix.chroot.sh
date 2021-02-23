dd if=/dev/zero of=/swapfile bs=1G count=16 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# add swap to fstab 
#/swapfile       none    swap    defaults        0       0
echo "/swapfile       none    swap    defaults        0       0" > /etc/fstab

# Configure local time
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# Configure languages
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

# Hostname
echo aquinas > /etc/hostname

echo "127.0.0.1  localhost" > /etc/hosts
echo "::1  localhost" >> /etc/hosts
echo "127.0.1.1 aquinas.local aquinas" >> /etc/hosts

# Root password
passwd

# Install software
pacman -S linux-headers connman-runit wpa_supplicant bluez bluez-runit bluez-utils openvpn openvpn-runit efibootmgr
ln -s /etc/runit/sv/connmand /etc/runit/runsvdir/default

useradd -mG wheel staze
passwd staze

EDITOR=vim visudo

# HOOKS="base udev autodetect modconf block encrypt keyboard keymap lvm2 resume filesystems fsck"
vim /etc/mkinitcpio.conf

blkid -s PARTUUID -o value /dev/sda2
blkid /dev/mapper/artix-root
#efibootmgr --disk /dev/sda --part 1 --create --label "0x0000c31" --loader /vmlinuz-linux --unicode 'root=PARTUUID=f75c56e1-eeba-4a50-8d08-3ea0a08beb56 rw initrd=\initramfs-linux.img' --verbose


#efibootmgr --disk /dev/sda --part 1 --create --label "0x0000c32" --loader /vmlinuz-linux --unicode 'cryptdevice=UUID=ab5777d6-8433-4e78-98af-f0ce77e32afa:crypt root root=UUID=/dev/mapper/vg0-root rw initrd=\initramfs-linux.img' --verbose

#exit
#umount -R /mnt