#!/bin/bash
if [ -d "/var/www/html" ]; then
    for site in "/var/www/html"; do
        echo -e $site
        echo -e "Your site has been found in Default Folder \nBackup is started"
        tar -czvf ./$(date +%Y-%m-%d).tar.gz $path ./
        if [ "$?" -ne 0 ]; then
            # $? - this is return code from previous command
            echo "Archive is failed"
            # termination logic
            exit 1
        else
            echo "Archive has creaded successfuly"
        fi
    done
else
    echo "Please enter path to your site"
    read path
    echo "Your path is $path"
    if [ -d "$path" ]; then
        echo "$path exist"
        tar -czvf ./$(date +%Y-%m-%d).tar.gz $path ./
        if [ "$?" -ne 0 ]; then
            # $? - this is return code from previous command
            echo "Archive is failed"
            exit 1
        else
            echo "Archive was creaded successfuly"
        fi
    else
        echo "Failled"
        exit 1
    fi

fi
# Database dump
if [ -d "/var/lib/mysql/" ]; then
    echo "Please Enter Database Username"
    read Username
    echo "Please enter Database Password"
    read Password
    echo "Please enter Database Name"
    read DatabaseName
    mysqldump -u $Username -p$Password $DatabaseName | gzip >$(date +./.sql.%Y%m%d.%H%M%S.gz)
    echo "Database has been backuped"
else
    echo "You dont have MySql Database"
    exit 1
fi
