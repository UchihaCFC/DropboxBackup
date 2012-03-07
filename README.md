Backup files and MySQL to Dropbox
=================================

This BASH script can backup dirs and MySQL databases on your unix system to your Dropbox account.

Includes code from [nixCraft](http://www.cyberciti.biz/tips/how-to-backup-mysql-databases-web-server-files-to-a-ftp-server-automatically.html) and [Andrea Fabrizi](https://github.com/andreafabrizi/Dropbox-Uploader).

Requeriments
------------
Unix system with cURL installed.

Installation
------------
1. Copy dropboxbackup.sh to a dir on your system and fill the configuration fields.
2. Get the latest [dropbox_uploader.sh](https://github.com/andreafabrizi/Dropbox-Uploader) or use the included one.
3. Run dropbox_uploader.sh so you can set up the authentication to your Dropbox.
3. Add the script to your crontab so it runs periodically.
4. Enjoy automated backups to your Dropbox!

License
-------
While you respect the licenses from Andrea and nixCraft, you can do whatever you want with my code.