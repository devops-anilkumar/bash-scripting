#!/bin/bash
echo "demonstrating simple if condition"

ACTION=$1  
if [ "$ACTION" == "start" ]; then
      echo -e "\e[32m service payment is starting \e[0m"
      exit o   
elif [ "$ACTION" == "stop" ]; then
      echo -e "\e[31m service payment is starting \e[0m"
      exit o   
else
      echo -e "\e[33m service payment is starting \e[0m"
      exit 3
fi