#! /bin/bash

# Install dependecies
yum -y groupinstall "Development Tools"
yum -y install pcre-devel openssl-devel

# Downloading
cd /home/sandbox/downloads
wget https://nginx.org/download/nginx-1.14.2.tar.gz
tar -xzvf nginx-1.14.2.tar.gz
cd nginx-1.13.2

# Assembling package with requirement
cd /home/sandbox/downloads/nginx/nginx-1.14.2
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access/log --with-pcre --with-http_ssl_module
make
make install
