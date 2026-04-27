#!/bin/bash
input="report.txt"
output="report.html"
if [[ ! -f "$input" ]]; then
    echo "ERROR: report.txt not found. Run finalC2.bash first."
    exit 1
fi
# Start HTML file
echo "<html>" > "$output"
echo "<body>" >> "$output"
echo "<h2>Access logs with IOC indicators:</h2>" >> "$output"
echo "<table border=\"1\">" >> "$output"
echo "<tr><th>IP</th><th>Date/Time</th><th>Page Accessed</th></tr>" >> "$output"
# Loop through the report.txt and add a row per line, all nice and pretty!
while IFS='|' read -r ip datetime page; do
    # Trim whitespace around each field
    ip=$(echo "$ip" | sed 's/^ *//;s/ *$//')
    datetime=$(echo "$datetime" | sed 's/^ *//;s/ *$//')
    page=$(echo "$page" | sed 's/^ *//;s/ *$//')
    echo "<tr><td>$ip</td><td>$datetime</td><td>$page</td></tr>" >> "$output"
done < "$input"
# Close HTML file
echo "</table>" >> "$output"
echo "</body>" >> "$output"
echo "</html>" >> "$output"
# Move report to web root
sudo mv "$output" /var/www/html/
echo -e "HTML report created at /var/www/html/report.html.\nCan be viewed at 10.0.17.27/report.html."
