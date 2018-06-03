#!/bin/bash

useradd -m -d /home/robert/ -s /bin/bash -G wheel robert

mkdir /home/robert/.ssh/

cat << EOF >> /home/robert/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICRuCDnidxou+3PyLgsqVS6btqi8bxlGfhiCWbbje/dd robert@robert-XPS-13-ubnt
EOF

chown -R robert. /home/robert/.ssh/

chmod 700 /home/robert/.ssh/
chmod 600 /home/robert/authorized_keys

restorecon -R -v /home/robert/.ssh