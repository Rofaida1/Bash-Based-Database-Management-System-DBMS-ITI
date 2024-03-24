#!/bin/bash

# Function to select all data from the table
select_all_data() {
    table_name="$1"
    metadata_file=".${table_name}"

    if [ -f "$table_name" ]; then
        # Read and print the data rows from the table file
        table_data=$(cat $table_name)
	whiptail --title "Displaying data" --msgbox "$table_data" 20 60  
    else
        whiptail --title "Error!" --msgbox "Table '$table_name' does not exist."
    fi
}

# Function to select a specific column from the table
select_specific_column() {
    table_name="$1"
    metadata_file=".${table_name}"

    if [ -f "$table_name" ]; then
        # Read the column names from the metadata file
        columns=($(awk -F: '{print $1}' "$metadata_file"))
	
        # Print the column names with corresponding numbers
        for ((i=0; i<${#columns[@]}; i++)); do
            whiptail --title "displaying columns" --msgbox "$((i+1)). ${columns[i]}" 20 60
        done

	column_number=$(whiptail --title "select column" --inputbox "Enter the column number you want to view:" --nocancel 20 60 3>&1 1>&2 2>&3)
	
        

        # Validate the column number
        if [[ "$column_number" =~ ^[1-9]+$ ]] && ((column_number <= ${#columns[@]})); then
            # Get the column name at the specified index
            column_name="${columns[column_number - 1]}"

            # Get the column index
            #column_index=$(awk -v colname="$column_name" -F: '{for(i=1;i<=NF;i++)if($i==colname) print i}' "$metadata_file")
	    #echo $column_index

            # Print the column data using awk
            column_data=$(awk -v colindex="$column_number" 'BEGIN{FS=":"}{print $colindex}' "$table_name")
		whiptail --title "Displaying data" --msgbox "$column_data" 20 40
        else
            whiptail --title "Error!" --msgbox "Invalid column number." 20 60
        fi
    else
        whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60
    fi
}

# Function to select a specific row based on a column value
select_specific_row() {
    table_name="$1"
    metadata_file=".${table_name}"

    if [ -f "$table_name" ]; then
        # Read the column names from the metadata file
        columns=($(awk -F: '{print $1}' "$metadata_file"))

        # Print the column names


	column_name=$(whiptail --title "select column" --inputbox "Enter the column name you want to view:" --nocancel 20 60 3>&1 1>&2 2>&3)


        # Check if the column name exists in the metadata
        if [[ " ${columns[@]} " =~ " $column_name " ]]; then
            # Get the column index
            column_index=$(awk -v colname="$column_name" -F: '{if($1==colname) print NR}' "$metadata_file")


            search_value=$(whiptail --title "displaying data" --inputbox "Enter the value to search for in '$column_name':" --nocancel 20 60 3>&1 1>&2 2>&3)


            # Print the row data that matches the search value
            values=$(awk -v colindex="$column_index" -v searchvalue="$search_value" -F: 'NR>1{if($colindex==searchvalue) print $0}' "$table_name")

if [[ -z $values ]] ;then
		            whiptail --title "Displaying data" --msgbox "no data found" 20 60
else 
		            whiptail --title "Displaying data" --msgbox "$values" 20 60
fi
        else
            whiptail --title "Error!" --msgbox "Column '$column_name' does not exist in the table." 20 60
        fi
    else
        whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60
    fi
}


# Main script
table_name=$(whiptail --title "Selecting table" --inputbox "Enter the name of the table you want to view:" --nocancel 20 60 3>&1 1>&2 2>&3)

if [ -f "$table_name" ]; then
   choice=$(whiptail --title "What do you want to select?" --menu "select option:" 20 60 0\
                                "1" "Select all records" \
                                "2" "select specefic column" \
                                "3" "select specefic record" \
                                "4" "Back to table Menu" 3>&1 1>&2 2>&3)


    case $choice in
    1)
        select_all_data "$table_name"
        ;;
    2)
        select_specific_column "$table_name"
        ;;
    3)
        select_specific_row "$table_name"
        ;;
    4)
	. ~/tablemenu.sh
	;;
    *)
        break
    esac
else
    whiptail --title "Error!" --msgbox "Table '$table_name' does not exist. Redirecting to table menu.." 20 60

. ~/tablemenu.sh
fi
