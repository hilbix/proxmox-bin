#!/bin/bash
#
# vm-rename oldid newid

POOL=/zfs/VM/images

OOPS() { { printf 'OOPS:'; printf ' %q' "$@"; printf '\n'; exit 23; } >&2; }
o() { "$@" || OOPS ret $?: "$@"; }
f() { "$@" && OOPS ret $?: "$@"; }
cmd() { printf ' %q' "$@"; printf ' &&\n'; }

declare -A REN
o test -d "$POOL/$1"
f test -d "$POOL/$2"
o test -s "/etc/pve/qemu-server/$1.conf"
f test -e "/etc/pve/qemu-server/$2.conf"

case "$1$2" in
(*[^0-9]*)	OOPS "wrong number: $1 $2";;
esac

for a in "$POOL/$1"/*
do
	case "$a" in 
	("$POOL/$1/vm-$1-disk-"[0-9].qcow2)	REN["$a"]="vm-$2-disk-${a#"$POOL/$1/vm-$1-disk-"}";;
	("$POOL/$1/vm-$1-state-suspend-"*.raw)	OOPS suspended not supported: "$a";;
	(*)	OOPS unknown "$a";;
	esac
done

for a in "${!REN[@]}"
do
	cmd mv -f "$a" "${a%/*}/${REN["$a"]}"
done
cmd mv -f "$POOL/$1" "$POOL/$2"
cmd mv -f "/etc/pve/qemu-server/$1.conf" "/etc/pve/qemu-server/$2.conf" &&
cmd sed -i "s|VM:$1/vm-$1-disk-|VM:$2/vm-$2-disk-|" "/etc/pve/qemu-server/$2.conf"
echo :
