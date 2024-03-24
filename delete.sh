#!/bin/bash

delete_specific_row() {
    table_name="$1"
    metadata_file=".${table_name}"
    

    if [ -f "$table_name" ]; then
        # Read the column names from the metadata file
        columns=($(awk -F: '{print $1}' "$metadata_file"))
	
	# Read the PK column name from the metadata file
        id_column=$(grep -F ":PK" "$metadata_file" | cut -d: -f1)
        
	
		id=$(whiptail --title "delete record" --inputbox "Enter the ID of the record to delete:" --nocancel 20 60 3>&1 1>&2 2>&3)
        # Get the index of the ID column
        id_column_index=$(awk -F: -v id_col="$id_column" '{for(i=1; i<=NF; i++) if ($i == id_col) print i}' "$table_name")

        # Check if the ID column exists in the table
        if [ -n "$id_column_index" ]; then
            # Delete the rows that match the specified ID
            awk -F: -v id_col_index="$id_column_index" -v id_val="$id" 'BEGIN {OFS=":"} $id_col_index!=id_val{print $0}' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"

            # Print the updated table
            updated_table=$(cat "$table_name")
		whiptail --title "Updated table" --msgbox "$updated_table" 20 40 
        else
            whiptail --title "Error!" --msgbox "ID column '$id_column' does not exist in the table." 20 60
        fi
    else
        whiptail --title "Error~" --msgbox "Table '$table_name' does not exist." 20 60
    fi
}




# Function to clear the entire table (except the structure and column names)
clear_table() {
    table_name="$1"
    metadata_file=".${table_name}_metadata.txt"

    if [ -f "$table_name" ]; then
        # Read the first row from the table (column names)
        first_row=$(head -n 1 "$table_name")

        # Clear the table (except the first row)
        echo "$first_row" > "$table_name"

        whiptail --title "all done!" --msgbox "Table '$table_name' has been cleared." 20 60
    else
        whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60
    fi
}

# Function to delete all records in a specific column
delete_all_records_in_column() {
    table_name="$1"
    metadata_file=".${table_name}"
	
    if [ -f "$table_name" ]; then
        # Read the column names from the metadata file
        columns=($(awk -F: '{print $1}' "$metadata_file"))

	# Read the PK column name from the metadata file
        primary_key_column=$(grep -F ":PK" "$metadata_file" | cut -d: -f1)
        
        # Print the column names
        printf '%s\n' "${columns[@]}"

        column_name=$(whiptail --title "column name" --inputbox "Enter the name of the column to delete all records:" 20 60 3>&1 1>&2 2>&3)
       

	# Check if the column name is not the primary key
        if [ "$column_name" != "$primary_key_column" ]; then
        
		# Check if the column name exists in the metadata
        	if [[ " ${columns[@]} " =~ " $column_name " ]]; then
            		column_index=$(awk -v colname="$column_name" -F: '{if($1==colname) print NR}' "$metadata_file")

      		# Replace all the values in the column with an empty string
            	    awk -F: -v colindex="$column_index" 'BEGIN {OFS=":"} NR>1 { $colindex = ""; print $0 } NR==1 { print $0 }' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"
            
	    	    whiptail --title "all done!" --msgbox "All records in '$column_name' have been deleted." 20 60

        	else
            	    whiptail --title "Error!" --msgbox "The column does not exist in the table." 20 60
        	fi
       else
            whiptail --title "Error!" --msgbox "Deleteing the primary key column is not allowed." 20 60
        fi
   
    else
        whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60 
    fi
}


# Main script

# Read the table name from user input
table_name=$(whiptail --title "choose table" --inputbox "Enter the name of the table:" --nocancel 20 60 3>&1 1>&2 2>&3)

# Check if the table exists
if [ -f "$table_name" ]; then
 choice=$(whiptail --title "Choose action" --menu "select option:" 20 60 0\
                                "1" "Delete specific row" \
                                "2" "Clear entire table" \
                                "3" "Delete all records in specific column"  3>&1 1>&2 2>&3)
    

    case $choice in
    1)
        delete_specific_row "$table_name"
        ;;
    2)
        clear_table "$table_name"
        ;;
    3)
        delete_all_records_in_column "$table_name"
        ;;
    *)
        . ~/tablemenu.sh
        ;;
    esac
else
    whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60
fi
