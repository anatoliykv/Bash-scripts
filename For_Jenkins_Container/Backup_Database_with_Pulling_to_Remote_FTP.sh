cd ~
rm -rf $backup_folder
mkdir $backup_folder
cd ~/$backup_folder
mysqldump -u $mysql_login -p$mysql_password $database_name | gzip > `date +./%d.%m.%Y.%H-%M-%S.sql.gz`
scp -i $key_path ~/$backup_folder/*.sql.gz $ftp_path
#Testing pushing to FTP
if [ $? -ne 0 ]; then
    echo "Error pushing to FTP"
    exit 1
else
    echo "Archive was pushed to FTP"
fi
rm ~/$backup_folder/*.sql.gz
#Testing whether archive was deleted successfully
if [ -f *.sql.gz ]; then
    echo "Error"
    exit 1
else
    echo "Success!"
fi
