#!/bin/bash

# Installing NGINX or Apache2 on Debian based distributions 
# with Let's Encrypt certificate and renewal it.

set -e
echo "Enter your domain name"
read DOMAIN_NAME
echo "Enter your email for Certbot"
read EMAIL

#Chose Apache or Nginx
echo -e "\e[41mPlease, chose next web server:\e[0m
\t\t\e[32mApache press 1\e[0m
\t\t\e[33mNginx  press 2\e[0m"

read WEB_SERVER

function certbot () {
#Installing Certbot
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update

if [ "$WEB_SERVER" = 1 ]; then
     sudo apt-get install -y certbot python-certbot-apache
elif [ "$WEB_SERVER" = 2 ]; then
     sudo apt-get install -y certbot python-certbot-nginx
else
     echo "Error"
     exit 1
fi
if [ "$WEB_SERVER" = 1 ]; then
    server="apache"
elif [ "$WEB_SERVER" = 2 ]; then
    server="nginx"
else
    echo "Error"
    exit 1
fi

#installing cerbot with email, email wount be shared, agree tos and redirect to https
sudo certbot --"$server" -m "$EMAIL" --no-eff-email -n --agree-tos --domains "$DOMAIN_NAME" --redirect
if [ $? -ne 0 ]; then
    echo "Error"
    exit 1
else
    if [ "$WEB_SERVER" = 1 ]; then
        sudo service apache2 restart
        echo -e "Success! \nYour Apache web server is restarted!"
    elif [ "$WEB_SERVER" = 2 ];then
        sudo service nginx restart
        echo -e "Success! \nYour Apache web server is restarted!"
    else
        echo "Error"
        exit 1
    fi
fi

#Test renewal cert
sudo certbot renew --dry-run
if [ $? -ne 0 ]; then
    echo "Error"
    exit 1
else
    echo "Certificate will be renewing"
fi
}

case "$WEB_SERVER" in
    1)
        echo "You chosed Apache"
        # Installing Apache
        sudo apt update && sudo apt install apache2 -y

        #Editing Default Apache config
        sudo sed -i "s/#ServerName www.example.com/ServerName ${DOMAIN_NAME};/" /etc/apache2/sites-available/000-default.conf
        sudo apache2ctl -t
        if [ $? -ne 0 ];then
            echo "Error, check yoyr Apache config"
            exit 1
        else
            sudo systemctl restart apache2
            if [ $? -ne 0 ]; then
                    echo "Apache can't run sorry!"
                    exit 1
            else
                    echo "Apache started"
            fi
        fi
    certbot # Call Certbot function
    ;;
    2)
        echo "You chosed Nginx"
        # Installing NGINX
        sudo apt update && sudo apt install nginx -y

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
    certbot # Call Certbot function
    ;;
    *)
        echo -e "You didn't choose web server \nBye!"
        exit 0
    ;;
esac
