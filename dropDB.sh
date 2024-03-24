#! /usr/bin/bash

cd ~/MyDataBase 

name=$(whiptail --title "Create DataBase" --inputbox "Enter your data base name to create" --nocancel 8 45 3>&1 1>&2 2>&3)
if [[ -e $name ]] ;then
check=`ls $name | wc -w` 
if [[ $check -eq 0 ]] ;then 
rmdir $name
whiptail --title "all done!" --msgbox "DataBase $name deleted successfully" 15 40
else 
rm -r $name
whiptail --title "all done!" --msgbox "DataBase $name deleted successfully" 15 40
fi 
else 
whiptail --title "Error!" --msgbox "DataBase $name doesnt exist" 15 40

fi
. ~/project.sh
