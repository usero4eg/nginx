#! /bin/bash

mv ~/Downloads/nginx/nginx.repo /etc/yum.repos.d/
yum install -y yum-utils epel-release
yum update
yum upgrade
yum-config-manager --enable nginx-mainline
yum install -y elink nginx
systemctl enable nginx
systemctl start nginx
elink http://localhost
