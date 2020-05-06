#!/bin/bash -x

RED='\033[0;31m'
NC='\033[0m' # No Color

image_file=$1
install_file=$2
install_file2=$3

[ -z $image_file ] && printf "${RED}1st parameter, image_file not found${NC}\n" 1>&2 && exit 1
[ -z $install_file ] && printf "${RED}2nd parameter, install_file not found${NC}\n" 1>&2 && exit 1
[ ! -f $install_file ] && printf "${RED}install_file not found${NC}\n" 1>&2 && exit 1

dir=$(mktemp -d)

guestmount -a ${image_file} -i ${dir} || exit 1

cp $install_file2 ${dir}/installApp.sh
chmod +x ${dir}/installApp.sh

cp $install_file ${dir}/install.sh
chmod +x ${dir}/install.sh

umount ${dir}
