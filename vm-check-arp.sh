#!/bin/bash
#
# Check that the VM network works

ok=0;
cnt=0;
fail=0;
{
while	read -ru6 vm;
do
	c="$(qm config "$vm")x"
	c=$'\n'"${c%x}"
	n="${c##*$'\nname: '}"
	n="${n%%$'\n'*}"
	i="${c##*$'\nnet0: '}"
	i="${i%%$'\n'*}"
	i="${i%%,*}"
	i="${i#*=}"

	let cnt+=1;
	had=false;
	while	read -ru6 ip;
	do
		had=:;
		if	fping -qr2 "$ip";
		then
			let ok+=1;
			printf '%6d ok %15q %s\n' "$vm" "$ip" "$n";
		else
			let fail+=1;
			echo "FAIL $vm $ip $n";
		fi;
	done 6< <(awk -vA="${i,,}" '$4==A { print $1 }' /proc/net/arp);
	$had && continue;
	let fail+=1;
	echo "MISS $vm $n";
done 6< <(qm list | awk '$3=="running" { print $1 }');

printf 'result: %d hosts %d ips\n' "$cnt" "$ok";
} >&2;

test 0 = "$fail" && echo OK || { printf 'FAIL %d\n' "$fail"; false; };

