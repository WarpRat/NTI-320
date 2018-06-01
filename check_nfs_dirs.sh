#!/bin/bash
#
#Robert Russell 
#NTI-320 Nagios Check
#Checks all top level  directories under /var/nfsshare/ and warns on 
#directories over a gig and is critical over 5 gigs.
#
status="0"

for i in $(du --max-depth=1 /var/nfsshare/*/ | cut -f 1 -d$'\t'); do
	if [ $i -gt 4999999 ]; then
		status="2"
		break
	elif [ $i -gt 999999 ]; then
		status="1"
	fi
done


if [ $status == "0" ]; then
    echo "STATUS:OK"
    exit 0;
    
  elif [ $status == "2" ]; then
    echo "STATUS:CRITICAL"
    exit 2;
    
  elif [ $status == "1" ] ; then
    echo "STATUS:WARNING"
    exit 1;
    
else
   echo "STATUS:UNKNOWN"
   exit 3;
fi

# v Can be used to enable the Nagios check, put on both server and client.
#command[nti-sanity]=/usr/lib64/nagios/plugins/nti-sanity.sh
