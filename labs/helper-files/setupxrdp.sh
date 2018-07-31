#!/bin/bash

echo "***Install XFCE and XRDP for RDP Access"
yum install epel-release -y 
yum groupinstall "Server with GUI" -y &
yum install -y xrdp -y
systemctl enable xrdp
systemctl start xrdp
echo "***Done installing XFCE and XRDP"
