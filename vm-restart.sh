#!/bin/bash
#
# Manually restart all VMs which have "ALLOWRESTART" in their description

grep -l '^#ALLOWRESTART$' /etc/pve/qemu-server/*.conf |
while	read -r x;
do
	a="${x##*/}";
	a="${a%.conf}";
	conf=$'\n'"$(qm config "$a")x";

	b="${conf#*$'\nname: '}";
	b="${b%%$'\n'*}";
#	echo "==="; echo "$b"; echo "===";

	echo -n "$a $b: ";
	qm stop "$a";
	echo -n $?;
	sleep 1;
	qm start "$a";
	echo -n $?;
	sleep 10;
	echo;
done;

