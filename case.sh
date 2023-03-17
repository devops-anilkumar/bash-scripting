#!/bin/bash
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