#!/bin/bash
#
#Bash script to set up an rsyslog server
#


#Open up TCP and UDP ports to accept logs
sed -i '/^#$ModLoad imupd/ s/^#/^/g' /etc/rsyslog.conf
sed -i '/^#$ModLoad imtcp/ s/^#/^/g' /etc/rsyslog.conf
sed -i '/^#$UDPServerRun/ s/^#/^/g' /etc/rsyslog.conf
sed -i '/^#$InputTCPServerRun/ s/^#/^/g' /etc/rsyslog.conf

#Restart syslog server
systemctl restart rsyslog

#Install Nagios Monitoring
yum install -y nrpe nagios-plugins-all
yum update -y
systemctl enable nrpe
systemctl restart nrpe

sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, 10.138.0.3/g' /etc/nagios/nrpe.cfg

sed -i 's/check_hda1/check_disk/g' /etc/nagios/nrpe.cfg
sed -i 's/dev\/hda1/dev\/sda1/g' /etc/nagios/nrpe.cfg
echo "command[check_mem]=/usr/lib/nagios/plugins/check_mem.sh -w 80 -c 90" >> /etc/nagios/nrpe.cfg


#Get the ip address of the first instance with repo in the name - adjust with for loop to add multiple repos at once
repo_ip=$(gcloud compute instances list | grep repo | sed '/s/\s\{1,\}/ /g' | cut -d ' ' -f 4 | head -n 1)

echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://$repo_ip/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/NTI-320.repo

#Get instance name and zone
name=$(curl -H "Metadata-Flavor:Google" http://metadata.google.internal/computeMetadata/v1/instance/name)
zone=$(curl -H "Metadata-Flavor:Google" http://metadata.google.internal/computeMetadata/v1/instance/zone)

#Remove startup script from metadata
gcloud compute instances add-metadata $name --metadata=finished=1 --zone $zone
gcloud compute instances remove-metadata $name --keys startup-script --zone $zone
