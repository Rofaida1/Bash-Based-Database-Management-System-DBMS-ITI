#!/bin/bash

# Function to update a specific row in a specific column
update_specific_column() {
    table_name="$1"
    metadata_file=".${table_name}"

    if [ -f "$table_name" ]; then
        # Read the column names from the metadata file
        columns=($(awk -F: '{print $1}' "$metadata_file"))

        # Read the PK column name from the metadata file
        primary_key_column=$(grep -F ":PK" "$metadata_file" | cut -d: -f1)

       

        column_name=$(whiptail --title "column name" --inputbox "Enter the name of the column to update:" --nocancel 20 60 3>&1 1>&2 2>&3)
   

        # Check if the column name is not the primary key
        if [ "$column_name" != "$primary_key_column" ]; then

            # Check if the column name exists in the metadata
            if [[ " ${columns[@]} " =~ " $column_name " ]]; then
                current_value=$(whiptail --title "current value" --inputbox "Enter the current value in '$column_name':" --nocancel 20 60 3>&1 1>&2 2>&3)
                

                new_value=$(whiptail --title "new value" --inputbox "Enter the new value to update in '$column_name':" --nocancel 20 60 3>&1 1>&2 2>&3)
              

                # Get the column index
                column_index=$(awk -v colname="$column_name" -F: '{if($1==colname) print NR}' "$metadata_file")
                whiptail --title "column index" --msgbox "$column_index" 20 40

                # Find the data type of the column
                datatype=$(grep "^$column_name:" "$metadata_file" | cut -d ':' -f 2)

                # Check if the current value exists in the column
                if awk -F: -v colindex="$column_index" -v value="$current_value" 'BEGIN{found=0} $colindex==value{found=1} END{exit !found}' "$table_name"; then

                    if [[ "$datatype" == "integer" && "$new_value" =~ ^[0-9]+$ ]] || [[ "$datatype" == "string" && "$new_value" =~ ^[a-zA-Z]+$ ]]; then
                        # Update the row with the new value
                        awk -F: -v colindex="$column_index" -v value="$current_value" -v new_value="$new_value" 'BEGIN {OFS=":"} {gsub(value,new_value,$colindex); print $0 }' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"

                        # Print the updated row
                        updated_table=$(cat "$table_name")
			whiptail --title "all done! data updated successfully" --msgbox "$updated_table" 20 40
                    else
                        whiptail --title "Error!" --msgbox "Invalid data type for the new value in '$column_name'." 20 60 
                    fi

                else
                    whiptail --title "Error!" --msgbox "The current value does not exist in the '$column_name' column." 20 60
                fi
            else
                whiptail --title "Error!" --msgbox "Column '$column_name' does not exist in the table." 20 60
            fi
        else
            whiptail --title "Error!" --msgbox "Updating the primary key column is not allowed." 20 60
        fi
    else
        whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60
    fi 
}


update_specific_row() {
    table_name="$1"
    metadata_file=".${table_name}"

    if [ -f "$table_name" ]; then
        echo "Enter the ID of the record to update:"
        read -r 
        # Get the index of the ID column
        id_column_index=$(awk -F: -v id_col="$primary_key_column" '{for(i=1; i<=NF; i++) if ($i == id_col) print i}' "$table_name")

        # Check if the ID column exists in the table
        if [ -n "$id_column_index" ]; then
        
            # Read the column names from the metadata file
            columns=($(awk -F: '{print $1}' "$metadata_file"))

            # Read the PK column name from the metadata file
            primary_key_column=$(grep -F ":PK" "$metadata_file" | cut -d: -f1)

            # Print the column names
            printf '%s\n' "${columns[@]}"

            echo "Enter the name of the column to update:"
            read -r column_name

            # Check if the column name is not the primary key
            if [ "$column_name" != "$primary_key_column" ]; then

                # Check if the column name exists in the metadata
                if [[ " ${columns[@]} " =~ " $column_name " ]]; then
                    echo "Enter the current value in '$column_name':"
                    read -r current_value

                    echo "Enter the new value to update in '$column_name':"
                    read -r new_value

                    # Get the column index
                    column_index=$(awk -v colname="$column_name" -F: '{if($1==colname) print NR}' "$metadata_file")
                    echo "$column_index"

                    # Find the data type of the column
                    datatype=$(grep "^$column_name:" "$metadata_file" | cut -d ':' -f 2)

                    # Check if the current value exists in the column
                    if awk -F: -v colindex="$column_index" -v value="$current_value" 'BEGIN{found=0} $colindex==value{found=1} END{exit !found}' "$table_name"; then

                        if [[ "$datatype" == "integer" && "$new_value" =~ ^[0-9]+$ ]] || [[ "$datatype" == "string" && "$new_value" =~ ^[a-zA-Z]+$ ]]; then
                            # Update the row with the new value
#----------------------------------->#awk -F: -v colindex="$column_index" -v value="$current_value" -v new_value="$new_value" -v id="$id" 'BEGIN {OFS=":"} $1==id && $colindex==value{$colindex=new_value} 1' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"

                            # Print the updated row
                            cat "$table_name"
                        else
                            echo "Invalid data type for the new value in '$column_name'."
                        fi

                    else
                        echo "The current value does not exist in the '$column_name' column."
                    fi
                else
                    echo "Column '$column_name' does not exist in the table."
                fi
            else
                echo "Updating the primary key column is not allowed."
            fi
        else
            echo "The specified ID does not exist in the table."
        fi
    else
        echo "Table '$table_name' does not exist."
    fi
}

# Read the table name from user input
table_name=$(whiptail --title "table name" --inputbox "Enter the name of the table:" 20 60 3>&1 1>&2 2>&3)

# Check if the table exists
if [ -f "$table_name" ]; then
    choice=$(whiptail --title "What do you want to do?" --menu "select option:" 20 60 0\
                                "1" "update specific column" \
                                "2" "update specific row" 3>&1 1>&2 2>&3)

    case $choice in
    1)
        update_specific_column "$table_name"
        ;;
    2)
        update_specific_row "$table_name"
        ;;
    *)
        . ~/tablemenu.sh
        ;;
    esac
else
    whiptail --title "Error!" --msgbox "Table '$table_name' does not exist." 20 60
fi

