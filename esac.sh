#!/bin/bash


ACTION=$1


case $ACTION in
        start)
             echo "starting service"
             exit 0
             ;;
        stop )
              echo "stoping service"
              exit 2
              ;;
        restart)
               echo "restarting service"
               exit 3
             ;;
        *)
             echo "valid options are start or stop or restart"
            
  esac             