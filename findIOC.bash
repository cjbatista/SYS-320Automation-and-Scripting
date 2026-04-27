#!/bin/bash
logfile="$1"
iocfile="$2"
if [[ ! -f "$logfile" || ! -f "$iocfile" ]]; then
    echo "Usage: bash findIOC.bash access.log IOC.txt"
    exit 1
fi
> report.txt
while read -r ioc; do
    [[ -z "$ioc" ]] && continue
    grep -F "$ioc" "$logfile" | while read -r line; do
        ip=$(echo "$line" | awk '{print $1}')
        datetime=$(echo "$line" | awk -F'[][]' '{print $2}')
        page=$(echo "$line" | awk '{print $7}')
        echo "$ip | $datetime | $page" >> report.txt
    done
done < "$iocfile"
sort -u -o report.txt report.txt
echo "Report saved to report.txt"
