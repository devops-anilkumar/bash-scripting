#!/bin/bash
TODAYDATE=$(date +%F)
echo -e "todays date is \e[32m ${TODAYDATE} \e[0m"
echo -e "number of user session in the system are : $(who | wc -l)"