#!/bin/bash

# SHELL=/bin/bash
# PATH=/sbin:/bin:/usr/sbin:/usr/bin
# MAILTO=""

SCHEDULE="*/3 * * * *"

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "$SCHEDULE cd /Users/space/Documents/DataloaderBackup/TWDataOperation-Upsert_Export/bin && sh process.sh >> /Users/space/Documents/DataloaderBackup/TWDataOperation-Upsert_Export/bin/export_upsert.log 2>&1" >> mycron
#install new cron file
crontab mycron
rm mycron

