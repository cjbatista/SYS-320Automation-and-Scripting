#! /bin/bash

# This is the link we will scrape
link="10.0.17.6/Assignment.html"

# get the page with curl
fullPage=$(curl -sL "$link")

# Clean up the HTML so xmlstarlet can read it
cleanPage=$(echo "$fullPage" | xmlstarlet format --html --recover 2>/dev/null)

# Get all table cells from the page
allCells=$(echo "$cleanPage" | xmlstarlet select --template --value-of \
"//html//body//table//td" -n 2>/dev/null)

# Remove the &#13; carriage return junk and blank lines
cleanCells=$(echo "$allCells" | sed 's/&#13;//g' | sed '/^\s*$/d')

# Save the cleaned values to a file
echo "$cleanCells" > values.txt

# Count total lines and figure out the size of each table
# Each table has (value, date, value, date...) so 1 row = 2 lines
totalLines=$(wc -l < values.txt)
half=$(( totalLines / 2 ))
rows=$(( half / 2 ))

# Loop through and print pressure, temperature, date
i=1
while [ $i -le $rows ]
do
    # Temperature is at line (i*2 - 1), date is at line (i*2)
    tempLineNum=$(( i * 2 - 1 ))
    dateLineNum=$(( i * 2 ))
    # Pressure is in the second half, same offset
    presLineNum=$(( half + i * 2 - 1 ))

    temp=$(head -n $tempLineNum values.txt | tail -n 1)
    date=$(head -n $dateLineNum values.txt | tail -n 1)
    pres=$(head -n $presLineNum values.txt | tail -n 1)

    echo "$pres $temp $date"

    i=$(( i + 1 ))
done
