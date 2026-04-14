#!/bin/bash

allLogs=""
file="/var/log/apache2/access.log"

function getAllLogs() {
    allLogs=$(cat "$file" | cut -d' ' -f1,4,7 | tr -d "[")
}

function ips() {
    ipsAccessed=$(echo "$allLogs" | cut -d' ' -f1)
    echo "$ipsAccessed"
}

function pageCount() {
    echo "$allLogs" | cut -d' ' -f3 | sort | uniq -c | sort -n
}

getAllLogs
pageCount

