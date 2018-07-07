#! /usr/bin/bash

### Check uid of user

tmp_uid=`id | awk '{ print $1;}' | sed 's/uid=\([0-9]\+\)(.*/\1/'`

if [ $tmp_uid -ne 0 ]; then
echo "This script needs to be executed with root user"
exit 1
fi


### Ask for user for the job to be executed

echo ""
echo -n "Enter the name of user to run the job: "
read cron_usr

cat /etc/passwd | awk -F: '{ print $1;}' | egrep "^$cron_usr$" >> /dev/null

if [ $? -ne 0 ]; then
echo "user does not exist"
exit 1
fi


### Ask for command to be executed 

echo ""
echo -n "Enter command string to schedule: "
read cmd_str

if [ ! -f $cmd_str ]; then
echo "command does not exist"
exit 1
fi


### Ask for interval

echo ""
echo -n "Enter interval - hourly(h), daily(d) or weekly(w) : "
read interval_choice

case "$interval_choice" in

h) echo "hourly function executed"
   ;;

d) echo "daily function executed"
   ;;

w) echo "weekly function executed"
   ;;

*) echo "wrong choice !!!"
   exit 1
   ;;

esac

