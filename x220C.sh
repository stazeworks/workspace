#!/bin/sh

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

hwclock --systohc

echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

passwd

echo aquinas > /etc/hostname
echo "Edit hosts:"
vim /etc/hosts

wpa_passphrase <SSID> <PASSWORD> > /etc/wpa_supplicant/wpa_supplicant-wlp3s0.conf
vim /etc/wpa_supplicant/wpa_supplicant-wlp3s0.conf


# systemctl enable wpa_supplicant@wlp3s0.service
# systemctl enable dhcpcd@wlp3s0.service