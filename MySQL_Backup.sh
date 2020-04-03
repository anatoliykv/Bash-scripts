mysqldump -u $mysql_login -p$mysql_password $database_name | gzip > `date +./%d.%m.%Y.%H-%M-%S.sql.gz`
