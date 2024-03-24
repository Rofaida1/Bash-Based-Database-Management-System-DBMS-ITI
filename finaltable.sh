#! /usr/bin/bash
isPK=""
Pkmark="false"
declare -A columnNamesArray
#read -rp "enter DataBase name: " name 
tablename=$(whiptail --title "Create Table"  --inputbox "What do you want to call your table?" 8 60 --nocancel 3>&1 1>&2 2>&3)
while ! [[ $tablename =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$ ]];

do 

whiptail --title "Create Databse Message" --msgbox "$tablename is not a valid name, please enter a name without special characters, spaces \
and doen't have a '-' or '_' at the beginning nor the end" 15 50

. ~/tablemenu.sh
done
 
if [[ -e $tablename ]] ;then 
whiptail --title "Error!" --msgbox "Table $tablename already exists" 15 50
else 

col_no=$(whiptail --title "creating table" --inputbox "how many columns does your table need?" --nocancel 20 50 3>&1 1>&2 2>&3)
echo $col_no
while ! [[ $col_no =~ ^[0-9]+$ ]] ;do
whiptail --title "Error!" --msgbox "this is not  a number. Try again." 15 50 
. ~/tablemenu.sh
done

declare -a columns
declare -i i
for (( i=0; $i < $col_no ; i++ )) ;do

   columnName=$(whiptail --title "column name" --inputbox "what's column $((i+1)) name?" --nocancel 20 50 3>&1 1>&2 2>&3)


while grep -q "$columnName:" $tablename ||  [[ $columnName = " " || -z $columnName || ! $columnName =~ ^([a-zA-Z])[a-zA-Z0-9\w_-]*([a-zA-Z0-9])$  ]] ;do 
whiptail --title "Error!" --msgbox "column name cannot be duplicated,empty,start with a number or have special characters" 15 50 
   

   columnName=$(whiptail --title "column name" --inputbox "what's column $((i+1)) name?" --nocancel 20 50 3>&1 1>&2 2>&3)
    done
     
   dataType=$(whiptail --title "column data type"  --menu "what's column $((i+1)) data type?" 20 60 0\
                                "1" "string" \
                                "2" "integer" \
                                  3>&1 1>&2 2>&3)

	case $dataType in 
	1)
	dataType="string"
	;;
	2) 
	dataType="integer"
	;;	
	*)	
	. ~/tablemenu.sh

	esac
isPk=""
if  [[ $Pkmark == "false" ]] ;then
if ( whiptail --title "Primary Key" --yesno "is $((i+1)) the primary key?"  --defaultno 20 50 3>&1 1>&2 2>&3 ) ;then 
isPk="PK"
allownull="0"
Pkmark="true"
else 
isPK=""

fi
fi

echo $dataType
    columns[$i]="$columnName:$dataType:$isPk"
	echo "${columns[i]}" >> .$tablename
	echo -n "$columnName:">> $tablename
	
 touch $tablename .$tablename
done
echo " " >> $tablename
whiptail --title "all done!" --fb --msgbox "Table $tablename created successfully" 20 50

fi
    
