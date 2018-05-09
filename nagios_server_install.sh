#!/bin/bash
#Install a nagios server

yum -y install epel-release #not nessecary on GCP but including for portability
yum -y update
yum -y install nagios
yum -y install nagios-plugins-all

systemctl enable nagios
systemctl start nagios

#Trying without SELinux in permissive
#setenforce 0

yum install -y httpd nagios-selinux

systemctl enable httpd
systemctl restart httpd

yum -y install nrpe

systemctl enable nrpe
systemctl start nrpe


echo '########### NRPE CONFIG LINE #######################
define command{
command_name check_nrpe
command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}' >> /etc/nagios/objects/commands.cfg

systemctl restart nagios

