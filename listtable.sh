#! /usr/bin/bash 


tablelist=`ls -F |grep -v /`
whiptail --title "all done!" --msgbox "the tables available are\n$tablelist" 20 50 4\

