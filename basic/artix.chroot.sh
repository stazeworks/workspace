dd if=/dev/zero of=/swapfile bs=1G count=4 status=progress
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

#efibootmgr -d /dev/sdb -p 1 -c -L "0x0000c33" -l /vmlinuz-linux -u "root=/dev/sda2 rw initrd=\initramfs-linux.img"

#efibootmgr --disk /dev/sdb --part 1 --create --label "0x0000c33" --loader /vmlinuz-linux --unicode 'cryptdevice=UUID=fcff6cc8-f1b5-441f-ae7e-421dfe0c9667:crypt root root=UUID=/47386ca5-44ac-492e-b07e-915020a32455 rw initrd=\initramfs-linux.img' --verbose

#exit
#umount -R /mnt