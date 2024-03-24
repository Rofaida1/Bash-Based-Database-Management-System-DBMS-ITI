#! /usr/bin/bash

shopt -s extglob
export LC_COLLATE=C

if [[ -d ~/MyDataBase ]] ;then
cd ~/MyDataBase
else 
mkdir ~/MyDataBase 
cd ~/MyDataBase
fi


PS3="Please enter the number of choice: "


menuchoice=$(whiptail --title "Hello! what do you want to do today" --fb --menu "select option: " 17 60 0\
                                "1-" "CreateDB" \
                                "2-" "ListDB" \
                                "3-" "Dropdb" \
                                "4-" "ConnectDB" \
                                "5-" "Exit" \
                                 3>&1 1>&2 2>&3)


case $menuchoice in 
1-) 

. ~/createDB.sh
;;
2-)
. ~/listDB.sh
;;
3-) 
. ~/dropDB.sh
;;
4-)
. ~/connectDB.sh
;;
5-)
whiptail --title "Exiting.." --msgbox "Hope to see you soon!" 15 40
exit 0
;; 
*) 
echo "invalid option. please select a number from the main menu"
esac

