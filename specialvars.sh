#!/bin/bash
#special characters are : $0 to $9,$* ,$#, #@ ,$$
#$0 : prints the script name 
#$1 : takes the 1st value 
#$2 : takes the  second  value 
#$3 : takes the third value 
#$* or $@

 : is going to print  the  used variables 
# $# ; is going to print the total number of variables 
echo "name of the script is : $0"
echo "first value is $1"
echo "second value is $2"
echo "third value is $3"
echo "total number of supplied variables are : $# "
 echo " total number of used variables : $@ "
 echo "print the process id of system : $$"