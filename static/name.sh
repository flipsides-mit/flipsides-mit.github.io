#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 old_prefix new_prefix"
    exit 1
fi

# Assign the first and second argument to variables
old_prefix="$1"
new_prefix="$2"

# Loop over all files with the old prefix
for file in "${old_prefix}"*; do
    # Skip if there is no file matching the pattern
    if [[ ! -e $file ]]; then
        echo "No files found with the prefix $old_prefix."
        break
    fi

    # Extract the rest of the filename after the old prefix
    suffix="${file#$old_prefix}"

    # Construct the new filename
    new_file="${new_prefix}${suffix}"

    # Rename the file
    mv -- "$file" "$new_file"
    echo "Renamed $file to $new_file"
done

