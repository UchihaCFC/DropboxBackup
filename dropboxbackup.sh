#!/bin/sh
# System + MySQL backup script
# Copyright (c) 2005-2006 nixCraft <http://www.cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above

# Script based on nixCraft's one but heavily modified:
# - Does a full backup each day (assuming you are running it once a day via cron)
# - Uses BASH Dropbox Uploader <http://j.mp/p2U0ai> instead ncftp (dropbox_uploader.sh needs to be in the same dir)
# - Mailing if backup fails disabled since it wasn't reliable
# - Generates Windows friendly filenames
# - Packs all the files to a single tar
# Last update, Mar 7, 2012 by Nyr


### System setup ###
DIRS="/example1 /var/www/foo"

### MySQL setup ###
MUSER="user"
MPASS="pass"
MHOST="localhost"

### Dropbox setup ###
DROPBOX_DIR="/Backup"


# Let's set some variables
BASEDIR=$(dirname $0)
BACKUP=$BASEDIR/tmp.$$
NOW=$(date +"%d-%m-%Y")
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

# Start Backup for the file system
[ ! -d $BACKUP ] && mkdir -p $BACKUP || :
FILE="fs-$NOW.tar.gz"
tar -zcvf $BACKUP/$FILE $DIRS

# Start MySQL Backup
# Get all databases name
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
FILE=$BACKUP/mysql-$db.$NOW.gz
$MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done

# Pack all files to one
tar cvf backup-$NOW.tar $BACKUP/*

# Upload backup using dropbox_uploader.sh
$BASEDIR/dropbox_uploader.sh upload backup-$NOW.tar $DROPBOX_DIR/backup-$NOW.tar

# Temove temporary files
rm -rf $BACKUP
rm -f backup-$NOW.tar