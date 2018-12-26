#!bin/bash
# Post-install processing. Run under root superuser.


lspci | grep -e VGA -e 3D

read -p "Xorg and Drivers: None - 0; Intel - 1; AMD - 2; Nvidia - 3: " video_driver
if [[ $video_driver == 0 ]]; then
  echo "Okay, continue without Video driver..."
elif [[ $video_driver == 1 ]]; then
  sudo pacman -S xf86-video-intel
elif [[ $video_driver == 2 ]]; then
  sudo pacman -S xf86-video-amdgpu
elif [[ $video_driver == 3 ]]; then
  sudo pacman -S nvidia
fi

sudo pacman -S xorg-server xorg-init i3-gaps i3status rxvt-unicode dmenu ttf-linux-libertine ttf-inconsolata

# Fonts confusion? Set manually in ~/.config/fontconfig/fonts.conf
# Place 'exec i3' in ~/.xinitrc
