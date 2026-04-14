#!/bin/bash

allLogs=""
file="/var/log/apache2/access.log"

function getAllLogs() {
    allLogs=$(cat "$file" | cut -d' ' -f1,4,7 | tr -d "[")
}

function displayAllLogs() {
    echo "$allLogs"
}

function displayOnlyIPs() {
    echo "$allLogs" | cut -d' ' -f1 | sort | uniq
}

function displayOnlyPages() {
    echo "$allLogs" | cut -d' ' -f3 | sort | uniq
}

function histogram() {
    echo "$allLogs" | cut -d' ' -f3 | sort | uniq -c | sort -n
}

function frequentVisitors() {
    echo "Frequent Visitors:"
    echo "$allLogs" | cut -d' ' -f1,2 | sort | uniq -c | sort -rn
}

function suspiciousVisitors() {
    echo "Suspicious Visitors:"
    while read ip; do
        count=$(echo "$allLogs" | grep "$ip" | wc -l)
        echo "$count $ip"
    done < ~/SYS-320Automation-and-Scripting/week12/loc.txt
}

function displayMenu() {
    echo "Please select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPS"
    echo "[3] Display only Pages"
    echo "[4] Histogram"
    echo "[5] Frequent Visitors"
    echo "[6] Suspicious Visitors"
    echo "[7] Quit"
}

getAllLogs

while true; do
    displayMenu
    read option

    case $option in
        1) displayAllLogs ;;
        2) displayOnlyIPs ;;
        3) displayOnlyPages ;;
        4) histogram ;;
        5) frequentVisitors ;;
        6) suspiciousVisitors ;;
        7) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done



