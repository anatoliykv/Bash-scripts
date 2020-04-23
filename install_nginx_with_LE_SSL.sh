#!/bin/bash
echo "Enter your domain name"
read DOMAIN_NAME
echo "Enter your email"
read EMAIL
sudo apt update
sudo apt install nginx -y

sed 's/danger/safety/' testfile.txt

#Installing Cerbot
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update

sudo apt-get install -y certbot python-certbot-nginx
sudo certbot --nginx --email $EMAIL