### Load configuration 
source $path_scripts/anchor_backup_config.sh

### Begin time tracking
overalltimebegin=$(date +"%s")
echo "$(date +'%Y-%m-%d %H:%M') Begin server backup" > $logs/anchor_log_overall.txt
i=1

### Loop through each WP Engine install
for website in "${websites[@]}"
do

	### Load FTP credentials 
	source $path_scripts/backup_logins.sh

	### Credentials found, start the backup
	if ! [ -z "$domain" ]
	then

		### Incremental backup download to local file system
		timebegin=$(date +"%s")
		echo "$(date +'%Y-%m-%d %H:%M') Begin incremental backup $website to local" > $logs/$website-log.txt
		echo "$(date +'%Y-%m-%d %H:%M') Begin incremental backup $website to local ($i/${#websites[@]})" >> $logs/anchor_log_overall.txt
		lftp -e "set net:max-retries 2;set net:reconnect-interval-base 5;set net:reconnect-interval-multiplier 1;mirror --only-newer --delete --parallel=2 --exclude .git/ --exclude .DS_Store --exclude Thumbs.db --verbose=2 / $path/$domain; exit" -u $username,$password -p $port $protocol://$ipAddress >> $logs/$website-log.txt
		timeend=$(date +"%s")
		diff=$(($timeend-$timebegin))
		echo "" >> $logs/$website-log.txt
		echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed." >> $logs/$website-log.txt

		### Generate log
		timeend=$(date +"%s")
		diff=$(($timeend-$timebegin))
		echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed." >> $logs/$website-log.txt
		echo "" >> $logs/$website-log.txt

	fi

	### Clear out variables
	domain=''
	username=''
	password=''
	ipAddress=''
	protocol=''
	port=''
	((i+=1))

done

### End time tracking
overalltimeend=$(date +"%s")
echo "" >> $logs/anchor_log_overall.txt
diff=$(($overalltimeend-$overalltimebegin))
echo "$(date +'%Y-%m-%d %H:%M') $(($diff / 3600)) hours, $((($diff / 60) % 60)) minutes and $(($diff % 60)) seconds elapsed." >> $logs/anchor_log_overall.txt
echo "" >> $logs/anchor_log_overall.txt

### Generate overall email
uuencode $logs/anchor_log_overall.txt anchor_log_overall.txt | mail -s "Backup Overview | $(date +'%Y-%m-%d')" $email