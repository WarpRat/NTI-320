!#/bin/bash
#Very basic bash script that sets up the directory structure needed for
#a build server
#

yum install -y rpm-build make gcc git

mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo '%_topdir %{getenv:HOME}/rpmbuild' > ~/.rpmmacros

#Now ready to compile code and build packages
