#!/bin/bash
#
# I use this to reboot ProxMox without need to reboot all VMs.
# Works with VMs which are keeping the time based on chrony.
# (I am not yet sure that systemd-timesyncd works properly.)
#
# NOT YET IMPLEMENTED:
#	You can add a line into the VM specific setting into the comment of the VM.
#	The line must start with:
#
#	ONPOWERDOWN:
#
#	And behind that there is a command name with arguments.
#
# BUGs:
# - This must check if an ISO from the CDROM of VMs are still present.
#   - If not, then the ISO must be removed first before suspending
#   - This is needed as the ISO cannot be removed while the VM is being suspended
#   - but it cannot be powered on either, as the ISO is missing
# - Workaraound:
#   - touch $ISO_STORE/template/$PATH_TO_MISSING_ISO
#   - ISO_STORE is: Datacenter :: Storage :: ISO
#   - PATH_TO_MISSING_ISO is from the VM :: Hartdware : CD/DVD Drive :: ISO image

echo "WARNING! This script is terribly incomplete, see comments in script!"

qm list |
grep running |
awk -F'[^0-9]*' '$0=$2' |
while read -r vm_id;
do
	qm suspend $vm_id --todisk 1;
done;

