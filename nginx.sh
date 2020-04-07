#! /bin/bash

mv ~/Downloads/nginx/nginx.repo /etc/yum.repos.d/
yum install -y epel-release yum-utils elinks
yum update
yum upgrade
yum-config-manager --enable nginx-mainline
yum install -y nginx
systemctl enable nginx
systemctl start nginx
elinks http://localhost
