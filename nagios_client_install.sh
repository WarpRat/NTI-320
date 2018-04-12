#!/bin/bash

apt-get install -y nagios-nrpe-server nagios-plugins
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, 10.138.0.5/g' /etc/nagios/nrpe.cfg
systemctl restart nagios-nrpe-server
