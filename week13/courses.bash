#! /bin/bash

# This is the link we will scrape
link="10.0.17.6/Courses2026SP.html"

# get it with curl and tell curl not to give errors
fullPage=$(curl -sL "$link")

# Extract table rows using xmlstarlet
toolOutput=$(echo "$fullPage" | \
xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --copy-of "//table//tr")

# Clean up HTML into semicolon-separated rows
echo "$toolOutput" | sed 's/<\/tr>/\n/g' | \
                     sed -e 's/&amp;//g' | \
                     sed -e 's/<tr>//g' | \
                     sed -e 's/<td[^>]*>//g' | \
                     sed -e 's/<\/td>/;/g' | \
                     sed -e 's/<[/\]\{0,1\}a[^>]*>//g' | \
                     sed -e 's/<[/\]\{0,1\}nobr>//g' \
                     > courses.txt
