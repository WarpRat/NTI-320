#!/bin/bash
yum -y install nagios
systemctl enable nagios
systemctl start nagios
setenforce 0
yum install -y httpd
systemctl enable httpd
systemctl restart httpd
yum -y install nrpe
systemctl enable nrpe
systemctl start nrpe
