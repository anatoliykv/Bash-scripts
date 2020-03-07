#!/bin/bash

#Ubuntu
if grep "ubuntu" /proc/version
then
sudo apt install -y curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
apt update
apt install nginx
#Red Hat
elif grep "Red Hat" /proc/version
then
echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/rhel/7/\$basearch/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/nginx.repo
yum update -y
yum install nginx -y
systemctl enable nginx
systemctl start nginx
else
echo -e "\e[41;1m Nothink to do \e[0m"
fi