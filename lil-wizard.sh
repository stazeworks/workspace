#!/bin/bash
# Post-install processing. Run under root superuser.


lspci | grep -e VGA -e 3D

echo "Choose video drivers vendor: None - 0; Intel - 1; AMD - 2; Nvidia - 3: "
read video_driver
echo "Choosed option: $video_driver"

if [ $video_driver = 0 ]
    then echo "Okay, continue without Video driver..."
elif [ $video_driver = 1 ]
  then pacman -S xf86-video-intel
elif [ $video_driver = 2 ]
  then pacman -S xf86-video-amdgpu
else [ $video_driver = 3 ]
  then pacman -S nvidia
fi

sudo pacman -S xorg-server xorg-init i3-gaps i3status rxvt-unicode dmenu ttf-linux-libertine ttf-inconsolata

# Fonts confusion? Set manually in ~/.config/fontconfig/fonts.conf
# Place 'exec i3' in ~/.xinitrc
echo "Done"
