#!bin/bash
# Post-install processing. Run under root superuser.


lspci | grep -e VGA -e 3D

read -p "Xorg and Drivers: None - 0; Intel - 1; AMD - 2; Nvidia - 3" video_driver
if [[ $vm_serrings == 1 ]]; then
  echo "Okay, continue without Video driver..."
if [[ $vm_serrings == 1 ]]; then
  sudo pacman -S xf86-video-intel
elif [[ $vm_serrings == 2 ]]; then
  sudo pacman -S xf86-video-amdgpu
elif [[ $vm_serrings == 3 ]]; then
  sudo pacman -S nvidia
fi

sudo pacman -S xorg-server xorg-init i3-gaps i3-status rxvt-unicode dmenu ttf-linux-libertine ttf-inconsolata

# Fonts confusion? Set manually in ~/.config/fontconfig/fonts.conf
# Place 'exec i3' in ~/.xinitrc
