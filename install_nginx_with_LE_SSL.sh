#!/bin/bash
set -e
echo "Enter your domain name"
read DOMAIN_NAME
echo "Enter your email for Cerbot"
read EMAIL
sudo apt update
sudo apt install nginx -y

#Uncomment server name, 443 port ipv4 and ipv6
sudo sed -i 's/server_name/server_name $DOMAIN_NAME;/' /etc/nginx/sites-available/default
#sudo sed -i 's/# listen 443 ssl default_server;/listen 443 ssl default_server;/' /etc/nginx/sites-available/default
#sudo sed -i 's/# listen [::]:443 ssl default_server;/listen [::]:443 ssl default_server;/' /etc/nginx/sites-available/default

nginx -s reload # Checking the correct config and reloading nginx with new config
if [ $? -ne 0 ]; then
    echo "Error, Check your Nginx config"
    exit 1
else
    sudo service nginx restart
fi
#Installing Cerbot
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update

sudo apt-get install -y certbot python-certbot-nginx
#installing cerbot with email, email wount be shared, agree tos and redirect to https
sudo certbot --nginx -m $EMAIL --no-eff-email -n --agree-tos --domains $DOMAIN_NAME --redirect
if [ $? -ne 0 ]; then
    echo "Error"
    exit 1
else
    sudo service nginx restart
    echo "Success!"
fi