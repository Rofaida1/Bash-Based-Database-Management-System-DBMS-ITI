#! /usr/bin/bash 

shopt -s extglob
export LC_COLLATE=C


#read -rp "enter DataBase name: " name 
name=$(whiptail --title "Create DataBase" --inputbox "Enter your data base name to create" --nocancel 8 45 3>&1 1>&2 2>&3)

while ! [[ $name =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]];

do 

whiptail --title "Create Databse Message" --msgbox "$name is not a valid name, please enter a name without special characters, spaces \
and doen't have a '-' or '_' at the beginning nor the end" 15 45

. ~/project.sh
done
 
if [[ -e $name ]] ;then 
whiptail --title "Error!" --msgbox "Database $name already exists" 15 40
else 
mkdir $name 
whiptail --title "all done!" --msgbox "DataBase $name created successfully" 15 40

fi
. ~/project.sh

