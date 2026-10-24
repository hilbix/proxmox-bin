#!/bin/bash
#
# Manually start all VMs which are set to autostart on boot

grep -l ^onboot: /etc/pve/qemu-server/*.conf |
while	read -r x;
do
	a="${x##*/}";
	a="${a%.conf}";
	conf=$'\n'"$(qm config "$a")x";
#	echo "==="; echo "$conf"; echo "===";
	b="${conf#*$'\nonboot: '}";
	b="${b%%$'\n'*}";
	[ 1 = "$b" ] || continue;
	b="${conf#*$'\nstartup: '}";
	b="${b%%$'\n'*}";
	echo -n "$a $b: ";
	qm start "$a";
	sleep 10;
done;

