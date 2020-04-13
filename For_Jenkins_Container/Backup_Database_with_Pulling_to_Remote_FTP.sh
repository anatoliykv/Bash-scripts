URL="https://api.telegram.org/bot$TOKEN/sendMessage"
cd ~
rm -rf $backup_folder
mkdir $backup_folder
cd ~/$backup_folder
mysqldump -u $mysql_login -p$mysql_password $database_name | gzip > `date +./%d.%m.%Y.%H-%M-%S.sql.gz`
#Testing creating backup file
if [ -f *.sql.gz ]; then
    scp -i $key_path ~/$backup_folder/*.sql.gz $ftp_path
    sleep 3
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$Backup_file_successfully_created"
else
    echo "Error! File not found!"
    sleep 3
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$Error_File_not_found"
    exit 1
fi
#Testing pushing to FTP
if [ $? -ne 0 ]; then
    echo "Error pushing to FTP"
    sleep 3
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$Error_pushing_to_FTP"
    exit 1
else
    echo "Archive was pushed to FTP"
    sleep 3
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$Archive_was_pushed_to_FTP"
fi
rm ~/$backup_folder/*.sql.gz
#Testing whether archive was deleted successfully
if [ -f *.sql.gz ]; then
    echo "Error"
    sleep 3
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$Error_deleting_archive"
    exit 1
else
    echo "Success, local archive was deleted successfully!"
    sleep 3
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$archive_was_deleted_successfully"
fi
