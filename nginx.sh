#! /bin/bash

mv ~/Downloads/nginx/nginx.repo /etc/yum.repos.d/
yum install -y epel-release yum-utils net-tools elinks
yum update
yum upgrade
yum-config-manager --enable nginx-mainline rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
yum install -y nginx
systemctl enable nginx
systemctl start nginx
elinks http://localhost
