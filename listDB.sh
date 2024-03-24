#! /usr/bin/bash

shopt -s extglob 
export LC_COLLATE=C

cd ~/MyDataBase
DBlist=`ls -D`
(whiptail --title "listing DataBases" --msgbox "The databases available are: \n$DBlist" 20 80 3>&1 1>&2 2>&3)
. ~/project.sh
