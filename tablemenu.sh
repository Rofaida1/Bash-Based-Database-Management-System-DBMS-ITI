#! /usr/bin/bash

choice=$(whiptail --title "Table Menu" --menu "select option:" 20 60 0\
                                "1" "Create Table" \
                                "2" "List Tables" \
                                "3" "Drop Table" \
                                "4" "Insert Into Table" \
                                "5" "Select from Table" \
                                "6" "Delete from Table" \
                                "7" "Update Table" \
                                "8" "Back to Main Menu" 3>&1 1>&2 2>&3)

case $choice in 
1) 
. ~/finaltable.sh
;;
2) 
. ~/listtable.sh

;;
3)
. ~/droptable.sh
;;
4) 
. ~/insert.sh
;; 
5)
. ~/select2.sh
;;
6)
. ~/delete.sh
;;
8) 
. ~/project.sh
;;
7)
. ~/update.sh
;;
*)
. ~/project.sh
;;
esac
. ~/tablemenu.sh


