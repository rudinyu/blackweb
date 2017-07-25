#!/bin/bash
### BEGIN INIT INFO
# Provides:          blackweb
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       blackweb for Squid
### END INIT INFO
# by:	             maravento.com and novatoz.com

# PATH
route=/etc/acl
bl=~/bl

# DEL OLD REPOSITORY
if [ -d $bl ]; then rm -rf $bl; fi
# CREATE PATH
if [ ! -d $route ]; then mkdir -p $route; fi

# DOWNLOAD
echo "Download Blackweb..."
svn export "https://github.com/maravento/blackweb/trunk/bl"
cd $bl
cat blackweb.tar.gz* | tar xzf -
echo "OK"

echo "Checking Sum..."
a=$(md5sum blackweb.txt | awk '{print $1}')
b=$(cat blackweb.md5 | awk '{print $1}')
	if [ "$a" = "$b" ]
	then 
		echo "Sum Matches"
		cp -f  blackweb.txt $route >/dev/null 2>&1
		# ADD OWN LIST
		#sed '/^$/d; / *#/d' /path/blackweb_own.txt >> $route/blackweb.txt
		echo "OK"
		date=`date +%d/%m/%Y" "%H:%M:%S`
		echo "Blackweb for Squid: Done $date" >> /var/log/syslog
		cd
		rm -rf $bl
		echo "Done"
	else
		echo "Bad Sum. Abort"
		date=`date +%d/%m/%Y" "%H:%M:%S`
		echo "Blackweb for Squid: Abort $date Check Internet Connection" >> /var/log/syslog
		cd
		rm -rf $bl
		exit
fi
