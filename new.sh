#!/bin/sh

# CHECKS




# PARTITION
parted /dev/sda mklabel gpt mkpart P1 ext3 1MiB 8MiB 


# INSTALL PROCESS

loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true





# FUCNTIONS

error() { clear; printf "ERROR:\\n%s\\n" "$1"; exit;}

checkBios() { \
	if [ -d ls /sys/firmware/efi/efivars ]; then
    echo "Fine. We are on UEFI install, keep going."
  else
    error "No way, man. UEFI ONLY!"
  fi
  }