#!/bin/bash
# This will find suids and sgids on the system
# Can also search for world writeable files as well.
#

echo -e "SUID/SGID finder tool by pr0digy\n"
echo -e "Where would you like your output? (default: stdout)"

read outputName

if [ -z "$outputName" ]
then 
   echo -e "\nI will now search through / for suids and output to terminal\n"
   ls -alF `find / -perm -4000 -o -perm -2000 -type f 2> /dev/null`
else 
   echo -e "\nI will now search through / for suids and output to $outputName\n"
   ls -alF `find / -perm -4000 -o -perm -2000 -type f 2> /dev/null` > $outputName
fi

echo -e "Would you like to find world writable directories too? (y/n) "

read answer

if [ "$answer" -eq "y" ]
then
   echo -e "\nFinding world writable directories and writing to /tmp/ww.log....\n"
   find / -perm -2 ! -type l -ls 2>/dev/null 1>/tmp/ww.log
else
   echo -e "We have found all of the files. Now time to exploit them!"
   exit 0
fi

