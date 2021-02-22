dd if=/dev/zero of=/swapfile bs=1G count=16 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# add swap to fstab 
#/swapfile       none    swap    defaults        0       0
vim /etc/fstab

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