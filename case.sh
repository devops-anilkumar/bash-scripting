#!/bin/bash



ACTION=$1
case $ACTION in
        START)
             echo "starting service"
             ;;
        STOP)
              echo "stoping service"
              ;;
         restart)
               echo "restarting service"
               ;;
  esac             