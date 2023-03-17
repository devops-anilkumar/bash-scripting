#!/bin/bash


ACTION=$1


case $ACTION in
        start)
             echo "starting service"
             ;;
        stop )
              echo "stoping service"
              ;;
        restart)
               echo "restarting service"
             ;;
        *)
             echo "valid options are start or stop or restart
            
  esac             