#! /usr/bin/bash

Hourly () {

	echo ""
	echo -n "Enter time in mins [00-59]: "
	read input_time
	echo ""

	echo $input_time | egrep "^[0-5][0-9]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid time entered !!!"
	echo ""
        exit 1
        fi

	printf "%s * * * * %s\n" $input_time $cmd_str >> /var/spool/cron/$cron_usr
	echo "Cron entry added successfully"
	echo ""
}

Weekly () {

	echo ""
        echo -n "Enter day of the week [0-6]: "
        read input_week
	echo ""

        echo $input_week | egrep "^[0-6]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid day of the week !!!"
	echo ""
        exit 1
        fi

        echo -n "Enter time of the day in 24 hour format [hh:mm]: "
        read input_time
	echo ""

        echo $input_time | egrep "^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid time entered !!!"
	echo ""
        exit 1
        fi

        hh=`echo $input_time | awk -F: '{ print $1;}'`
        mm=`echo $input_time | awk -F: '{ print $2;}'`

        printf "%s %s * * %s %s\n" $mm $hh $input_week $cmd_str >> /var/spool/cron/$cron_usr
	echo "Cron entry added successfully"
	echo ""
}

Daily () {

	echo ""
        echo -n "Enter time of the day in 24 hour format [hh:mm]: "
        read input_time
	echo ""

        echo $input_time | egrep "^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid time entered !!!"
	echo ""
        exit 1
        fi

        hh=`echo $input_time | awk -F: '{ print $1;}'`
        mm=`echo $input_time | awk -F: '{ print $2;}'`

        printf "%s %s * * * %s\n" $mm $hh $cmd_str >> /var/spool/cron/$cron_usr
        echo "Cron entry added successfully"
	echo ""
}

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

h) Hourly
   ;;

d) Daily
   ;;

w) Weekly
   ;;

*) echo "wrong choice !!!"
   exit 1
   ;;

esac

