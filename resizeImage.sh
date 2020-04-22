#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

modprobe nbd 

image_file=$1
size=$2

echo $size

[ -z $image_file ] && printf "${RED}1st parameter, image_file not found${NC}\n" 1>&2 && exit 1
[ -z $size ] && printf "${RED}1st parameter, image_file not found${NC}\n" 1>&2 && exit 1

qemu-img resize ${image_file} ${size}G

qemu-nbd -c /dev/nbd0 ${image_file}
# parted /dev/nbd0 p free
printf "fix\n" | parted ---pretend-input-tty /dev/nbd0 print

parted /dev/nbd0 resizepart 1 ${size}GB

sleep 3

e2fsck -f /dev/nbd0p1
resize2fs  /dev/nbd0p1

# virt-resize -expand /dev/sda1 ${image_file} ${image_file}.new
# rm ${image_file}
# mv ${image_file}.new ${image_file}
qemu-nbd -d /dev/nbd0
