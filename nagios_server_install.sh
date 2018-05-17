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

#Get the ip address of the first instance with repo in the name - adjust with for loop to add multiple repos at once
repo_ip=$(gcloud compute instance list | grep repo | sed '/s/\s\{1,\}/ /g' | cut -d ' ' -f 4 | head -n 1)

echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://$repo_ip/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/NTI-320.repo 
