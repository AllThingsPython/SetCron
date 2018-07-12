#! /usr/bin/bash

### Main menu display function

MainMenu () {

        clear
        printf "\t\t\t\tSetCron utility\n\n\n\n"
        printf " 1. Add a cron entry\n"
        printf " 2. Delete a cron entry\n"
        printf " 3. Display cron entries\n\n"
        printf " Select an option [1-3,q]: "
        read main_menu_choice

        case "$main_menu_choice" in

        1) echo ""
        ;;

        2) echo ""
        ;;

        3) echo ""
	   crontab -l
        ;;

        q) exit 1
        ;;

        esac

}


### Function to add cron entry for hourly tasks

Hourly () {
		
	while [ 1 ]
	do
        echo ""
        echo -n "Enter time in mins [00-59]: "
        read input_time
        echo ""

        echo $input_time | egrep "^[0-5][0-9]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid time entered !!!"
        echo ""
        continue
        fi

        printf "%s * * * * %s\n" $input_time $cmd_str >> /var/spool/cron/$cron_usr
        echo "Cron entry added successfully"
        echo ""
	break
	done
}

### Function to add cron entry for weekly tasks

Weekly () {

	while [ 1 ]
	do
        echo ""
        echo -n "Enter day of the week [0-6]: "
        read input_week
        echo ""

        echo $input_week | egrep "^[0-6]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid day of the week !!!"
        echo ""
        continue
        fi

        echo -n "Enter time of the day in 24 hour format [hh:mm]: "
        read input_time
        echo ""

        echo $input_time | egrep "^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid time entered !!!"
        echo ""
        continue
        fi

        hh=`echo $input_time | awk -F: '{ print $1;}'`
        mm=`echo $input_time | awk -F: '{ print $2;}'`

        printf "%s %s * * %s %s\n" $mm $hh $input_week $cmd_str >> /var/spool/cron/$cron_usr
        echo "Cron entry added successfully"
        echo ""
	break
	done
}


### Function to add cron entry for daily tasks
 
Daily () {

	while [ 1 ]
	do
	echo ""
        echo -n "Enter time of the day in 24 hour format [hh:mm]: "
        read input_time
	echo ""

        echo $input_time | egrep "^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$" >> /dev/null

        if [ $? -ne 0 ]; then
        echo "Invalid time entered !!!"
	echo ""
        continue
	fi

        hh=`echo $input_time | awk -F: '{ print $1;}'`
        mm=`echo $input_time | awk -F: '{ print $2;}'`

        printf "%s %s * * * %s\n" $mm $hh $cmd_str >> /var/spool/cron/$cron_usr
        echo "Cron entry added successfully"
	echo ""
	break
	done
}

### Check uid of user

tmp_uid=`id | awk '{ print $1;}' | sed 's/uid=\([0-9]\+\)(.*/\1/'`

if [ $tmp_uid -ne 0 ]; then
echo "This script needs to be executed with root user"
exit 1
fi

### Display main menu

MainMenu


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

