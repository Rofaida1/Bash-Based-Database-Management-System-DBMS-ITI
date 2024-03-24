name=$(whiptail --title "Joining a DataBase" --inputbox "Enter your data base name to connect to" --nocancel 8 60 3>&1 1>&2 2>&3)
if ! [[ -e $name ]] ;then
whiptail --title "Error!" --msgbox "DataBase $name doesnt exist. Please check the name and try again." 20 50
else
cd ~/MyDataBase/$name 
whiptail --title "Welcome!" --msgbox "You're now in '$name' database" 20 50

. ~/tablemenu.sh
fi

. ~/project.sh
