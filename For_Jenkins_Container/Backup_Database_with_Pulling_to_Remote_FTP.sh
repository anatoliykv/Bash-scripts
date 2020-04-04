cd ~
rm -rf $backup_folder
mkdir $backup_folder
cd ~/$backup_folder
mysqldump -u $mysql_login -p$mysql_password $database_name | gzip > `date +./%d.%m.%Y.%H-%M-%S.sql.gz`
scp -i $key_path ~/$backup_folder/*.sql.gz $ftp_path
rm ~/$backup_folder/*.sql.gz
if [ -f *.sql.gz ]; then
    echo "Error"
else
    echo "Success!"
fi
