#!/bin/bash
#
#A small script to check linux distro and install snmp
#
#Will be expanded to configure snmp for cacti monitoring in the future


#Find distro ID
distro=$(cat /etc/os-release | grep '^ID=' | cut -d '=' -f 2 | sed 's/"//g')

#Set distro package manager and package names based on ID
case $distro in
	centos|rhel)
		pkg_man=yum
		pkg_name="net-snmp net-snmp-utils"
		;;
	fedora)
		pkg_man=dnf
		pkg_name="net-snmp net-snmp-utils"
		;;
	ubuntu)
		pkg_man=apt-get
		pkg_name="snmp snmp-mibs-downloader"
		;;
	*)
		printf "Unrecognized version of Linux, sorry" >&2
		exit 1
esac

#Install the packages
$pkg_man install -y $pkg_name

#Make sure it's running
systemctl restart snmpd
