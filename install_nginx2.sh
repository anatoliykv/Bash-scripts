#!/bin/bash
#OS version function
showOSversion() {
    echo "My OS version is: `cat /proc/version`"
}
showOSversion

echo -e "\n\e[42;1m Chose your OS:\e[0m
Enter \e[36;1m1\e[0m for Ubuntu
Enter \e[36;1m2\e[0m for \e[31mRHEL\e[0m
Enter \e[36;1m3\e[0m for Debian"
read OS
#Ubuntu
if [ $OS = 1 ]
then
    echo -e "\e[41;1m Ubuntu was selected \e[0m"
    sudo apt install -y curl gnupg2 ca-certificates lsb-release
    echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
    curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
    apt update
    apt install nginx -y
    #Red Hat
elif [ $OS = 2 ]
then
    echo -e "\e[41;1m RHEL was selected \e[0m"
    echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/rhel/7/\$basearch/
gpgcheck=0
    enabled=1" > /etc/yum.repos.d/nginx.repo
    yum update -y
    yum install nginx -y
    systemctl enable nginx
    systemctl start nginx
fi

case $OS in
    3)
        echo "Debian"
        sudo apt install curl gnupg2 ca-certificates lsb-release
        echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
        | tee /etc/apt/sources.list.d/nginx.list
        curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
        apt update
        apt install nginx -y
    ;;
esac
