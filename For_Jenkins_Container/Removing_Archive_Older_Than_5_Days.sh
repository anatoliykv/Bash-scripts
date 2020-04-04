#Removing archive older than 5 days
ssh -i $key_path $ftp_server 'cd /remote/path/to/archive; find ./ -type f -mtime +5 -delete; ls -la'
