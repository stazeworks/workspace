#!/bin/sh

TARGET_DISK="null"
WIPEOUT_TARGET_DISK=0

log() { echo -e "[*] [$dateLog] [$1] $2"; }

selectDisk() {
	if [ -z "$TARGET_DISK" ]; then
        lsblk
		read -p "Select disk for installation. Current disk is - ${TARGET_DISK}" $TARGET_DISK
		log INFO "Install system into: $TARGET_DISK"
	else
		log CRITICAL "You must select a disk!"
        selectDisk          
	fi
}

wipeoutDisk() {
    log WARN "W A R N I N G: Wipeout all data in ${TARGET_DISK}"
    read -p "0 - NO, 1 - YEZ: " $WIPEOUT_TARGET_DISK
    if [[ $WIPEOUT_TARGET_DISK == 0 ]]; then
	    log INFO "Skipping the wipeout"
    elif [[ $WIPEOUT_TARGET_DISK == 1 ]]; then
        log INFO "Wipeout all data in ${TARGET_DISK}"
	    #wipefs -a /dev/sda
    fi
}

preparePartiotions() {
    log INFO "Test"
}

selectDisk
wipeoutDisk
preparePartiotions