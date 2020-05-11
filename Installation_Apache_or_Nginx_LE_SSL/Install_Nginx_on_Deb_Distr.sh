#!/bin/bash

# Installing NGINX on Debian based distributions
# with Let's Encrypt certificate and renewal it.

set -e
echo "Enter your domain name"
read DOMAIN_NAME
echo "Enter your email for Certbot"
read EMAIL
sudo apt update
sudo apt install nginx -y

#Editing Default Nginx config
sudo sed -i "s/server_name _;/server_name ${DOMAIN_NAME};/" /etc/nginx/sites-available/default

nginx -s reload # Checking the correct config and reloading nginx with new config
if [ $? -ne 0 ]; then
    echo "Error, Check your Nginx config"
    exit 1
else
    sudo service nginx restart
    if [ $? -ne 0 ]; then
        echo "Nginx can't run sorry!"
        exit 1
    else
        echo "Nginx started"
    fi
fi
#Installing Certbot
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update

sudo apt-get install -y certbot python-certbot-nginx
#installing cerbot with email, email wount be shared, agree tos and redirect to https
sudo certbot --nginx -m $EMAIL --no-eff-email -n --agree-tos --domains $DOMAIN_NAME --redirect
if [ $? -ne 0 ]; then
    echo "Error"
    exit 1
else
    sudo service nginx restart
    echo "Success!\n
    Your site is ready!"
fi
#Test renewal cert
sudo certbot renew --dry-run
if [ $? -ne 0 ]; then
    echo "Error"
    exit 1
else
    echo "Certificate will be renewing"
fi
