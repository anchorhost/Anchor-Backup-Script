	### Select FTP info for install
	case $website in
		website1)
			### FTP info
			echo "Credentials found for install: $website"
			domain=website1.com
			username=$website
			password='XXXXXXXXXXXX'
			ipAddress='xxx.xxx.xxx.xxx'
			protocol='sftp'
			port='2222'
			;;
		website2)
			### FTP info
			echo "Credentials found for install: $website"
			domain=website2.com
			username=$website
			password='XXXXXXXXXXXX'
			ipAddress='xxx.xxx.xxx.xxx'
			protocol='sftp'
			port='2222'
			;;
		website3)
			### FTP info
			echo "Credentials found for install: $website"
			domain=website3.com
			username=$website
			password='XXXXXXXXXXXX'
			ipAddress='xxx.xxx.xxx.xxx'
			protocol='sftp'
			port='2222'
			;;
		*)
			echo "No credentials found for install: $website" >> $logs/anchor_log_overall.txt
			;;
	esac