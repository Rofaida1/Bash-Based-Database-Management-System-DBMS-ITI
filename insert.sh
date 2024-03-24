#! /usr/bin/bash

declare -A primaryKeyCheck


tablename=$(whiptail --title "Where do you want to insert your data ?" --inputbox "Enter table name" --nocancel 10 60 3>&1 1>&2 2>&3)
if [[ -e $tablename ]] ;then 

col_no=$(awk 'END{ print NR }' .$tablename )
echo $col_no
typeset -i i
i=1
until [[ $i -gt $col_no ]] 
do

col_name=$(awk 'BEGIN{FS=":"}{if (( NR == '$i' )) print $1}' .$tablename)
isdatatype=$(awk 'BEGIN{FS=":"}{if (( NR == '$i' )) print $2}' .$tablename) 
isPK=$(awk 'BEGIN{FS=":"}{if (( NR == '$i' )) print $3}' .$tablename)

data=$(whiptail --title "inserting data" --inputbox "enter the data you want to insert in $i [$col_name]" --nocancel 10 50 3>&1 1>&2 2>&3) 
if [[ $isdatatype == "integer" ]] ;then 

until [[ $data =~ ^[0-9]+$ ]] ;do
whiptail --title "Error! incorrect datatype" --msgbox "please enter the data in $isdatatype data type" 10 50
data=$(whiptail --title "inserting data" --inputbox "enter the data you want to insert in $col_name [$isdatatype] data type" --nocancel 10 50 3>&1 1>&2 2>&3)
done
fi
if [[ $isPK == "PK" ]] ;then
  if [[ ${primaryKeyCheck["$data"]} ]]; then
            whiptail --title "Error! duplication." --msgbox "column [$col_name] is the primary key, it cannot be duplicated." 10 50
            continue  
        else

            primaryKeyCheck["$data"]=1
        
    fi

fi
if [[ $i == $col_no ]] ;then
echo "$data" >> $tablename
else 
echo -n "$data:" >> $tablename
fi 
((i++))

echo $isPK
done

else 
if (whiptail --title "Error! table doesn't exist" --yesno "do you want to create it?" 10 50 3>&1 1>&2 2>&3 ) ;then
. ~/finaltable.sh
else . ~/tablemenu.sh

fi
fi

if (whiptail --title "all done!" --yesno "your data is inserted successfully. \
do you want to insert more data?" 10 50 3>&1 1>&2 2>&3 ) ;then
. ~/insert.sh
else
. ~/tablemenu.sh
fi
