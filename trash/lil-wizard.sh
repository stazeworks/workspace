#!/bin/bash
# Post-install processing. Run under root superuser.


lspci | grep -e VGA -e 3D

echo "Choose video drivers vendor:  Intel - 1; AMD - 2; Nvidia - 3; Any other char - Skip: "
read video_driver
echo "Choosed option: $video_driver"

if [ $video_driver = 1 ]
  then pacman -S xf86-video-intel
elif [ $video_driver = 2 ]
  then pacman -S xf86-video-amdgpu
elif [ $video_driver = 3 ]
    then pacman -S nvidia
else
  echo "Okay, continue without Video driver..."
fi

#sudo echo 'MODULES=(i915)' >> /etc/mkinitcpio.conf
#sudo echo 'MODULES=(amdgpu)' >> /etc/mkinitcpio.conf
#sudo echo 'MODULES=(nouveau)' >> /etc/mkinitcpio.conf

sudo pacman -S --noconfirm xorg-server xorg-xinit i3-gaps i3status rxvt-unicode dmenu ttf-linux-libertine ttf-inconsolata

# Fonts confusion? Set manually in ~/.config/fontconfig/fonts.conf
# Place 'exec i3' in ~/.xinitrc
echo "Done"
