#! /bin/bash

mv ~/Downloads/nginx/nginx.repo /etc/yum.repos.d/
yum install -y epel-release yum-utils net-tools certbot python2-certbot-nginx elinks
yum update
yum upgrade
yum-config-manager --enable nginx-mainline rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
yum install -y nginx
systemctl enable nginx
systemctl start nginx
certbot --nginx
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | tee -a /etc/crontab > /dev/null
