#!/bin/bash
#
# I use this to reboot ProxMox without need to reboot the VMs.
# Works with VMs which are keeping the time based on chrony.
# (I am not yet sure that systemd-timesyncd works properly.)
#
# Missing: Handle VMs differently, which are known to never wake up again.
# - implement a way to run some VM dependent script with properly shuts down the VMs
#
# Missing: Remove missing ISOs from CDROM of VMs before suspend
# - A VM with missing ISO cannot be resumed and the ISO cannot be removed afterwards for the VM being locked
# - Hint:  touch $ISO_STORE/template/$PATH_TO_MISSING_ISO

echo "WARNING! This script is terribly incomplete, see comments in script!"

qm list |
grep running |
awk -F'[^0-9]*' '$0=$2' |
while read -r vm_id;
do
	qm suspend $vm_id --todisk 1;
done;

