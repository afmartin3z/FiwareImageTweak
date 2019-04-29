#!/bin/bash -x

RED='\033[0;31m'
NC='\033[0m' # No Color

image_file=$1
[ -z $image_file ] && printf "${RED}1st parameter, image_file not found${NC}\n" 1>&2 && exit 1

dir=$(mktemp -d)

guestmount -a ${image_file} -i ${dir} || exit 1

mount -o bind /proc ${dir}/proc
mount -o bind /dev ${dir}/dev
mount -o bind /dev/pts ${dir}/dev/pts
mount -o bind /run ${dir}/run
mount -o bind /sys ${dir}/sys

# cp -p bootstrap.sh ${dir}/tmp

cat << EOT > ${dir}/etc/systemd/system/bootstrap.service
[Unit]
Description=bootstrap thing to create the VM
ConditionPathExists=/etc/bootstrap
# Before=gdm.service
Before=systemd-logind.service

[Service]
ExecStart=/etc/bootstrap start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
# Type=oneshot
Type=normal

[Install]
WantedBy=multi-user.target
EOT

cat << EOT > ${dir}/etc/bootstrap
#!/bin/bash

if [ -f /install.sh ]; then 
/install.sh
rm /install.sh && poweroff
fi
EOT
chmod +x ${dir}/etc/bootstrap

chroot ${dir}  << EOT
systemctl enable bootstrap
EOT

# exit
umount ${dir}/run
umount ${dir}/proc
umount ${dir}/dev/pts
umount ${dir}/dev
umount ${dir}/sys

umount ${dir}
