#! /usr/bin/bash

tablename=$(whiptail --title "remove table" --inputbox "Please enter the table name you want to delete" --nocancel 20 50 3>&1 1>&2 2>&3)
if [[ -f $tablename ]] ;then
rm $tablename .$tablename
whiptail --title "all done!" --msgbox "the table $tablename successfully deleted" 20 50
else 
whiptail --title "Error!" --msgbox "The table $tablename doesn't exist. Please try again" 20 50 
fi 

