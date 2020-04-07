#! /bin/bash

cd ~/Downloads
wget https://github.com/usero4eg/nginx/nginx.repo
mv nginx.repo /etc/yum.repos.d/
yum install -y yum-utils
yum-config-manager --enable nginx-mainline
yum update
yum install -y nginx
