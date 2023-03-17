#!/bin/bash
 #this is how we call function 
 stat() {
 echo -e " \t total number of sessions : $(who | wc -l)"
 echo "todays date is : $(date +%F)"
 echo -e " \t load average on the system is $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"
 } 
 echo "calling stat function " 
 stat