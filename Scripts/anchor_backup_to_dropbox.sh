### Load configuration 
source $path_scripts/anchor_backup_config.sh

### Begin time tracking
overalltimebegin=$(date +"%s")
echo "$(date +'%Y-%m-%d %H:%M') Begin server backup" > $logs/anchor_dropbox_log_overall.txt
i=1

### Loop through each WP Engine install
for website in "${websites[@]}"
do
	
	### Load FTP credentials 
	source $path_scripts/backup_logins.sh

	### Credentials found, start the backup
	if ! [ -z "$domain" ]
	then

		### Incremental backup upload to Dropbox 
		timebegin=$(date +"%s")
		echo "$(date +'%Y-%m-%d %H:%M') Begin incremental upload to Dropbox" > $logs/$website-dropbox-log.txt
		echo "$(date +'%Y-%m-%d %H:%M') Begin incremental sync $website to Dropbox ($i/${#websites[@]})" >> $logs/anchor_dropbox_log_overall.txt
		$path_rclone/rclone sync $path/$domain $rclone_cloud_name:backup/Sites/$domain --log-file="$logs/$website-dropbox-log.txt" 2>> $logs/anchor_dropbox_log_overall.txt
		sleep 1s

	fi

	### Clear out variables
	domain=''
	i=$(($i+1))

done

### Backup the backup scripts
$path_rclone/rclone sync $path_scripts $rclone_cloud_name:backup/Sites/_scripts

### End time tracking
overalltimeend=$(date +"%s")
echo "" >> $logs/anchor_dropbox_log_overall.txt
diff=$(($overalltimeend-$overalltimebegin))
echo "$(date +'%Y-%m-%d %H:%M') $(($diff / 3600)) hours, $((($diff / 60) % 60)) minutes and $(($diff % 60)) seconds elapsed." >> $logs/anchor_dropbox_log_overall.txt
echo "" >> $logs/anchor_dropbox_log_overall.txt

### Generate overall email
( echo "$(php $path_scripts/calculate_transferred.php)"; uuencode $logs/anchor_dropbox_log_overall.txt anchor_dropbox_log_overall.txt ) \
| mail -s "Backup Dropbox Overview | $(date +'%Y-%m-%d')" $email