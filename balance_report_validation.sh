filename="../input_files/balance_pipeseparated.csv"
output_file="../output_files/validation_balance.txt"

echo "" >> "$output_file"
echo "Validation of balance report" >> "$output_file"
echo "" >> "$output_file"

# Number of Records
echo "Number of Records" >> "$output_file"
tail -n +2 "$filename" | wc -l >> "$output_file"

# Number of MSISDN Records
echo "Number of MSISDN Records" >> "$output_file"
tail -n +2 "$filename" | cut -d '|' -f4 | sed 's/\.0//' | sort | uniq | wc -l >> "$output_file"

# Number of duplicated MSISDN
echo "Number of duplicated MSISDN" >> "$output_file"
tail -n +2 "$filename" | cut -d '|' -f4 | sed 's/\.0//' | sort | uniq -d | wc -l >> "$output_file"

# Non Airtel number
echo "Non Airtel number" >> "$output_file"
tail -n +2 "$filename" | cut -d '|' -f4 | sed 's/\.0//' | grep -vE '^75[0-9]{7}$' | wc -l >> "$output_file"

# Invalid Balance records
echo "Invalid Balance records" >> "$output_file"
tail -n +2 "$filename" | cut -d '|' -f4,7 | awk -F'|' '{
    # Remove .0 from the mobile number if it exists
    gsub(/\.0$/, "", $1)

    # Check if the balance is a valid decimal number
    if ($2 ~ /^[0-9]+(\.[0-9]+)?$/) {
      # Valid balance, skip printing
    } else {
        print "Invalid balance for mobile number: " $1  # Invalid balance, flag it
    }
}' | wc -l >> "$output_file"

