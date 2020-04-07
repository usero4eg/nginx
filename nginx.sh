#! /bin/bash

cd ~/Downloads
wget https://github.com/usero4eg/nginx/nginx.repo
mv nginx.repo /etc/yum.repos.d/
yum install epel-release
yum install -y yum-utils
yum update
yum upgrade
yum-config-manager --enable nginx-mainline
yum install -y nginx
systemctl enable nginx
systemctl start nginx
