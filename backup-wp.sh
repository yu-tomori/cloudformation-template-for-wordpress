#!/bin/bash
YMD=`date +%y%m%d`
mkdir /tmp/backups
cd /tmp/backups

# https://stackoverflow.com/questions/18681595/tar-a-directory-but-dont-store-full-absolute-paths-in-the-archive
tar czf wordpress_$YMD.tar.gz -C /var/www/html/ wordpress
aws s3 cp wordpress_$YMD.tar.gz s3://wp-backups-by-cron/
rm wordpress_$YMD.tar.gz

mysqldump --defaults-extra-file=/tmp/user.conf wordpressdb > db_$YMD.sql
aws s3 cp db_$YMD.sql s3://wp-backups-by-cron/
rm db_$YMD.sql
