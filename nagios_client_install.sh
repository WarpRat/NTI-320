#!/bin/bash

apt-get install -y nagios-nrpe-server nagios-plugins
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, 10.138.0.3/g' /etc/nagios/nrpe.cfg

sed -i 's/check_hda1/check_disk/g' /etc/nagios/nrpe.cfg
sed -i 's/dev\/hda1/dev\/sda1/g' /etc/nagios/nrpe.cfg
echo "command[check_mem]=/usr/lib/nagios/plugins/check_mem.sh -w 80 -c 90" >> /etc/nagios/nrpe.cfg

systemctl restart nagios-nrpe-server

curl https://raw.githubusercontent.com/WarpRat/NTI-320/master/check_mem.sh >> /usr/lib/nagios/plugins/check_mem.sh

chmod +x /usr/lib/nagios/plugins/check_mem.sh
