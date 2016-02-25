#!/bin/bash

# Time Machine backup report for a Mac, outputs to text file and then sent as an email via Gmail
# Also reports on disk capacity, uptime and battery health
# Tested on a MacBook Pro with OS X 10.11.3
# Untested on Mac desktops

email="youremail@domain.tld" # change to your email

hostname=`hostname`
time=`date`
maxBatCap=`ioreg -l | grep "MaxCapacity" | awk ' { print $5 } '`
designBatCap=`ioreg -l | grep "DesignCapacity" | awk ' { print $5 } '`
batHealth=`bc <<< "scale=2; ${maxBatCap}/${designBatCap}" | cut -c 2-`
cycles=`ioreg -l | grep "Cycle Count" | rev | cut -c -5 | cut -c 2- | rev | cut -c 2-` # assumes no more than 9999 cycles

echo System report for $hostname > report.txt
echo -e "\n" >> report.txt
echo Current time: $time >> report.txt
echo -e "\n" >> report.txt

tmutil latestbackup
if [ $? -eq 1 ]   # if command returns error
then
	echo -e "Time Machine backup disk currently unavailable." >> report.txt
else
	echo -e "Latest Time Machine backup:" >> report.txt
	tmutil latestbackup | tail -c 18 >> report.txt
fi
echo -e "\n" >> report.txt

echo Disk Space: >> report.txt
df | head -2 | awk ' { print $1,"   "$5,"      "$3,"    "$4 } ' >> report.txt
echo -e "\n" >> report.txt

echo Uptime: >> report.txt
uptime >> report.txt
echo -e "\n" >> report.txt

echo Battery Health: >> report.txt
echo -e "${batHealth}  %" >> report.txt
echo -e "${cycles} cycles" >> report.txt
echo -e "\n" >> report.txt

cat report.txt | mail -s "Backup Report" $email



