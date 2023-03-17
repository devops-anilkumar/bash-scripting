#!/bin/bash


ACTION=$1


case $ACTION in
        start)
             echo "starting service"
             exit0
             ;;
        stop )
              echo "stoping service"
              exit2
              ;;
        restart)
               echo "restarting service"
               exit3
             ;;
        *)
             echo "valid options are start or stop or restart"
            
  esac             