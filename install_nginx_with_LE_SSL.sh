#!/bin/bash
echo "Enter your domain name"
read domain_name
sudo apt update
sudo apt install nginx -y
