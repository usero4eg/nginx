#! /bin/bash

mv ~/Downloads/nginx/nginx.repo /etc/yum.repos.d/
yum install epel-release
yum install -y yum-utils
yum update
yum upgrade
yum-config-manager --enable nginx-mainline
yum install -y nginx
systemctl enable nginx
systemctl start nginx
