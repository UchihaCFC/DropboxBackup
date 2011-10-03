#!/bin/sh
# System + MySQL backup script
# Copyright (c) 2005-2006 nixCraft <http://www.cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above

# Script based on nixCraft's one but heavily modified:
# - Does a full backup each day (assuming you are running it once a day via cron)
# - Uses BASH Dropbox Uploader <http://j.mp/p2U0ai> instead ncftp (dropbox_uploader.sh needs to be in the same dir)
# - Mailing if backup fails disabled since it wasn't reliable
# - Generates Windows friendly filenames
# Last update, Oct 3, 2011 by Nyr

### System setup ###
DIRS="/example1 /var/www/foo"
BACKUP=/tmp/backup.$$
NOW=$(date +"%d-%m-%Y")

### MySQL setup ###
MUSER="user"
MPASS="pass"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

### Dropbox setup ###
DROPBOX_USER="user@example.com"
DROPBOX_PASS="password"
DROPBOX_DIR="/Backup"

### Start Backup for file system ###
[ ! -d $BACKUP ] && mkdir -p $BACKUP || :
FILE="fs-$NOW.tar.gz"
tar -zcvf $BACKUP/$FILE $DIRS

### Start MySQL Backup ###
# Get all databases name
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
FILE=$BACKUP/mysql-$db.$NOW.gz
$MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done

### Dump backup using dropbox_uploader.sh ###
# Find out where the script is located
BASEDIR=$(dirname $0)
$BASEDIR/dropbox_uploader.sh -u $DROPBOX_USER -p $DROPBOX_PASS -f $BACKUP -d $DROPBOX_DIR/$NOW

rm -f $BACKUP/*
